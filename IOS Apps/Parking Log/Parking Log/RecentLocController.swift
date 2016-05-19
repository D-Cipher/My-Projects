//
//  RecentLocController.swift
//  Where Is My Car
//
//  Created by Tingbo Chen on 1/18/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

var activePlace_GLOBAL = -1

var fromSegue_Global = ""

class TableViewController: UITableViewController {
    
    var recent_loc: [AnyObject] = []
    
    var savedArray: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if NSUserDefaults().objectForKey("savedArray") != nil {
            self.savedArray = NSUserDefaults().objectForKey("savedArray")! as! NSArray as [AnyObject] //Converting back to Array
            
            if self.savedArray.count > 0{
                self.recent_loc = []
                
                for (index,_) in self.savedArray.enumerate(){
                    self.recent_loc.append(self.savedArray[index]["name"]!!)
                }
                
                self.tableView.reloadData()
                
                //print(self.savedArray) //for testing
            }
            
        } else {
            
            self.recent_loc = []
            
            //print(self.recent_loc.count)
            
            self.tableView.reloadData()
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.recent_loc.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = self.recent_loc[indexPath.row] as? String

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
            recent_loc.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        //Removes Location and Saves
        self.savedArray.removeAtIndex(indexPath.row)
        
        NSUserDefaults.standardUserDefaults().setObject(self.savedArray, forKey: "savedArray")
        
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
    
    @IBAction func unwindToRecentLocController(segue:UIStoryboardSegue) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlaceSegue" {
            activePlace_GLOBAL = -1
        }
        
        if segue.identifier != nil {
            fromSegue_Global = segue.identifier!
        }
        
    }

}
