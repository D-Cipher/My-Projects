//
//  EditProfilePictures.swift
//  MM
//
//  Created by Tingbo Chen on 2/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class EditProfilePictures: UITableViewController {

    @IBOutlet var image0_view: UIImageView!
    @IBOutlet var imageA_view: UIImageView!
    @IBOutlet var imageB_view: UIImageView!
    @IBOutlet var imageC_view: UIImageView!
    @IBOutlet var imageD_view: UIImageView!
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var updateCurrentImage_str: String = ""
    
    var image_order: [AnyObject] = []
    
    @IBOutlet var reorderOutlet: UIBarButtonItem!
    
    @IBAction func reorderButton(sender: AnyObject) {
        
        if self.tableView.editing == false {
            self.tableView.setEditing(true, animated: true)
            reorderOutlet.title = "Done"
            
        } else if self.tableView.editing == true {
            self.tableView.setEditing(false, animated: true)
            self.saveImageOrderData()
            reorderOutlet.title = "Reorder"
            print(image_order)
        }
        
    }
    
    func saveImageOrderData() {
        //Save Perm storage and Save to Parse
        self.userProfileImages["image_order"] = self.image_order
        NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
        print("saved")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
            
            let query = PFQuery(className: "_User")
            
            query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                if error != nil {
                    print(error)
                } else if let object = object {
                    PFUser.currentUser()?["image_order"] = self.image_order
                    PFUser.currentUser()?.save()
                }
            })
            
        })
    }
    
    func updateProfileImages(){
        //Load Images
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            self.image_order = (self.userProfileImages["image_order"] as? Array)!
            print(self.image_order)
            
            if self.userProfileImages["image_0"] != nil {
                self.image0_view.image = UIImage(data: (self.userProfileImages["image_0"] as? NSData)!)
            } else {
                self.image0_view.image = UIImage(named: "placeholder-camera-green.png")
            }
            
            if self.userProfileImages[self.image_order[0] as! String] != nil {
                self.imageA_view.image = UIImage(data: (self.userProfileImages[self.image_order[0] as! String] as? NSData)!)
            } else {
                self.imageA_view.image = UIImage(named: "placeholder-camera-green.png")
            }
            
            if self.userProfileImages[self.image_order[1] as! String] != nil {
                self.imageB_view.image = UIImage(data: (self.userProfileImages[self.image_order[1] as! String] as? NSData)!)
            } else {
                self.imageB_view.image = UIImage(named: "placeholder-camera-green.png")
            }
            
            if self.userProfileImages[self.image_order[2] as! String] != nil {
                self.imageC_view.image = UIImage(data: (self.userProfileImages[self.image_order[2] as! String] as? NSData)!)
            } else {
                self.imageC_view.image = UIImage(named: "placeholder-camera-green.png")
            }
            
            if self.userProfileImages[self.image_order[3] as! String] != nil {
                self.imageD_view.image = UIImage(data: (self.userProfileImages[self.image_order[3] as! String] as? NSData)!)
            } else {    
                self.imageD_view.image = UIImage(named: "placeholder-camera-green.png")
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Auto set Row height for screen size
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.editing = false
        
        //Round out corner of images
        self.image0_view.layer.masksToBounds = true
        self.image0_view.layer.cornerRadius = CGRectGetWidth(self.image0_view.frame)/6.0
        self.imageA_view.layer.masksToBounds = true
        self.imageA_view.layer.cornerRadius = CGRectGetWidth(self.imageA_view.frame)/6.0
        self.imageB_view.layer.masksToBounds = true
        self.imageB_view.layer.cornerRadius = CGRectGetWidth(self.imageB_view.frame)/6.0
        self.imageC_view.layer.masksToBounds = true
        self.imageC_view.layer.cornerRadius = CGRectGetWidth(self.imageC_view.frame)/6.0
        self.imageD_view.layer.masksToBounds = true
        self.imageD_view.layer.cornerRadius = CGRectGetWidth(self.imageD_view.frame)/6.0
        
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
        
        let movedObject = self.image_order[sourceIndexPath.row]
        image_order.removeAtIndex(sourceIndexPath.row)
        image_order.insert(movedObject, atIndex: destinationIndexPath.row)
        
        //NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(self.image_order)")
        // To check for correctness enable:  self.tableView.reloadData()
        
    }

    //Track User's selected row
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            //print("image_0")
            self.performSegueWithIdentifier("UploadImageSegue", sender: "image_0")
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            //print(self.image_order[0])
            self.performSegueWithIdentifier("UploadImageSegue", sender: self.image_order[0])
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            //print(self.image_order[1])
            self.performSegueWithIdentifier("UploadImageSegue", sender: self.image_order[1])
            
        } else if indexPath.section == 1 && indexPath.row == 2 {
            //print(self.image_order[2])
            self.performSegueWithIdentifier("UploadImageSegue", sender: self.image_order[2])
            
        } else if indexPath.section == 1 && indexPath.row == 3 {
            //print(self.image_order[3])
            self.performSegueWithIdentifier("UploadImageSegue", sender: self.image_order[3])
            
        }

        return indexPath
    }
    
    //Segue From EditProfileUploadImage
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        self.updateProfileImages()
        
    }
    
    //Segue Back to EditProfileMainController
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            
            self.saveImageOrderData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print("test")
        
        self.saveImageOrderData()
        
        if segue.identifier == "UploadImageSegue" {
            if let EditProfileUploadImage = segue.destinationViewController as? EditProfileUploadImage {
                EditProfileUploadImage.currentImage_str = (sender as? String)!
                
            }
            
        }
        
        
    }

}
