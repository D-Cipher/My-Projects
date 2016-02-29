//
//  EditProfilePictures.swift
//  MM
//
//  Created by Tingbo Chen on 2/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class EditProfilePictures: UITableViewController {

    @IBOutlet var image0_view: UIImageView!
    @IBOutlet var image1_view: UIImageView!
    @IBOutlet var image2_view: UIImageView!
    @IBOutlet var image3_view: UIImageView!
    @IBOutlet var image4_view: UIImageView!
    
    var addPic_ls: [AnyObject] = ["image_1","image_2","image_3","image_4"]
    
    @IBOutlet var reorderOutlet: UIBarButtonItem!
    
    @IBAction func reorderButton(sender: AnyObject) {
        
        if self.tableView.editing == false {
            self.tableView.setEditing(true, animated: true)
            reorderOutlet.title = "Done"
            
        } else if self.tableView.editing == true {
            self.tableView.setEditing(false, animated: true)
            reorderOutlet.title = "Reorder"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.recent_loc.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pictureCell", forIndexPath: indexPath)
        
        //cell.textLabel?.text = self.recent_loc[indexPath.row] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Add up to five pictures"
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
        //self.savedArray.removeAtIndex(indexPath.row)
        
        //NSUserDefaults.standardUserDefaults().setObject(self.savedArray, forKey: "savedArray")
        
        //print(self.savedArray)
        
    }
    */
    
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        //Prevents moving across sections
        if proposedDestinationIndexPath.section != sourceIndexPath.section {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
        
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let movedObject = self.addPic_ls[sourceIndexPath.row]
        addPic_ls.removeAtIndex(sourceIndexPath.row)
        addPic_ls.insert(movedObject, atIndex: destinationIndexPath.row)
        //NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(data)")
        // To check for correctness enable:  self.tableView.reloadData()
        
    }

    //Track User's selected row
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        return indexPath
    }

}
