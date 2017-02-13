//
//  BookmarkedController.swift
//  Where Is My Car
//
//  Created by Tingbo Chen on 2/11/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

//Need to change fromsegue global to renameSegue and in map view update the status to "location bookmarked"

import UIKit

class BookmarkedController: UITableViewController {
    
    var bmLocName: [AnyObject] = []
    
    var bmLocData: [AnyObject] = []
    
    @IBOutlet var reorderOutlet: UIBarButtonItem!
    
    @IBAction func reorderButton(sender: AnyObject) {
        
        if self.tableView.editing == false {
            self.tableView.setEditing(true, animated: true)
            reorderOutlet.title = "Done"
            
        } else if self.tableView.editing == true {
            self.tableView.setEditing(false, animated: true)
            
            //Saves reordered data
            NSUserDefaults.standardUserDefaults().setObject(self.bmLocData, forKey: "bookmarkedArray")
            
            reorderOutlet.title = "Edit"
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setObject(self.bmLocData, forKey: "bookmarkedArray")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Set Reorder button
        self.tableView.editing = false
        reorderOutlet.title = "Edit"
        
        //Retrieve Saved Data
        if NSUserDefaults().objectForKey("bookmarkedArray") != nil {
            self.bmLocData = NSUserDefaults().objectForKey("bookmarkedArray")! as! NSArray as [AnyObject] //Converting back to Array
        }
        
        
        if self.bmLocData.count > 0{
            self.bmLocName = []
            
            for (index,_) in self.bmLocData.enumerate(){
                self.bmLocName.append(self.bmLocData[index]["name"]!!)
            }
            
            self.tableView.reloadData()
            
            //print(self.bm_loc) //for testing
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.bmLocName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell_Bookmarks", forIndexPath: indexPath)
        
        cell.textLabel?.text = bmLocName[indexPath.row] as? String
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            bmLocName.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        //Removes Location and Saves
        self.bmLocData.removeAtIndex(indexPath.row)
        
        NSUserDefaults.standardUserDefaults().setObject(self.bmLocData, forKey: "bookmarkedArray")
        
        //print(self.savedArray)
        
    }
    
    // Overrides to support moving cells in table
    /*
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    */
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        //Prevents moving across sections
        if proposedDestinationIndexPath.section != sourceIndexPath.section {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
        
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let movedName = bmLocName[sourceIndexPath.row]
        let movedData = bmLocData[sourceIndexPath.row]
        
        //Move bmLocName
        bmLocName.removeAtIndex(sourceIndexPath.row)
        bmLocName.insert(movedName, atIndex: destinationIndexPath.row)
        
        //Move bmLocData
        bmLocData.removeAtIndex(sourceIndexPath.row)
        bmLocData.insert(movedData, atIndex: destinationIndexPath.row)
        
    }
    
    
    
    //Track User's selected row
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlace_GLOBAL = indexPath.row
        
        return indexPath
    }
    
    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    @IBAction func unwindToBookmarkedController(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != nil {
            fromSegue_Global = segue.identifier!
        }
        
        
    }
}


