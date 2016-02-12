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
    
    var bm_loc: [AnyObject] = []
    
    var bookmarkedArray: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults().objectForKey("bookmarkedArray") != nil {
            self.bookmarkedArray = NSUserDefaults().objectForKey("bookmarkedArray")! as! NSArray as [AnyObject] //Converting back to Array
        }
        
        if self.bookmarkedArray.count > 0{
            self.bm_loc = []
            
            for (index,_) in self.bookmarkedArray.enumerate(){
                self.bm_loc.append(self.bookmarkedArray[index]["name"]!!)
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
        
        return self.bm_loc.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
        IMPORTANT!!! Must change the "reuseIdentifier" to "Cell" in:
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        AND click on Prototype Cells then "Show Attributes Inspector" (in the left bar) then type Cell in the Identifier box.
        Took me 5 hours to figure this out!!!
        */
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell_Bookmarks", forIndexPath: indexPath)
        
        cell.textLabel?.text = bm_loc[indexPath.row] as? String
        
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
            bm_loc.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        //Removes Location and Saves
        self.bookmarkedArray.removeAtIndex(indexPath.row)
        
        NSUserDefaults.standardUserDefaults().setObject(self.bookmarkedArray, forKey: "bookmarkedArray")
        
        //print(self.savedArray)
        
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != nil {
            fromSegue_Global = segue.identifier!
        }
        
        
    }
}


