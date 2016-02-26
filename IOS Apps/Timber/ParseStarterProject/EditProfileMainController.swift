//
//  EditProfileMainController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class EditProfileMainController: UITableViewController {
    
    var userProfileData = Dictionary<String,String>()

    @IBOutlet var relationshipStatusDetail: UILabel!
    
    @IBOutlet var interestedInDetail: UILabel!
    
    var currentSelectedChoice:String? = "N/A"
    
    var relationshipStatusVar:String? = "N/A" {
        didSet {
            
            relationshipStatusDetail.text? = relationshipStatusVar!
        
        }
    }
    
    var interestedInVar:String? = "Women" {
        didSet {
            
            interestedInDetail.text? = interestedInVar!
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        //print("init PlayerDetailsViewController")
        super.init(coder: aDecoder)
    }
    
    deinit {
        //print("deinit PlayerDetailsViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults().objectForKey("userProfileData") != nil {
            self.userProfileData = NSUserDefaults().objectForKey("userProfileData")! as! NSDictionary as! Dictionary<String,String>
            
            self.relationshipStatusVar = self.userProfileData["relationship_status"]
            
            self.interestedInVar = self.userProfileData["interested_in"]
        }
        
        //print(self.userProfileData)

    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            //print("relationship_status")
            
            currentSelectedChoice = relationshipStatusVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Single","In Relationship","N/A"])
            
        } else if indexPath.section == 2 && indexPath.row == 1 {
            //print("interested_in")
            
            currentSelectedChoice = interestedInVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Men","Women","Both","N/A"])
        }
        
        return indexPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Unwind Multiple Choice Segue
    @IBAction func unwindFromEditProfileMultipleChoice(segue:UIStoryboardSegue) {
        
        if let EditProfileMultipleChoice = segue.sourceViewController as? EditProfileMultipleChoice,
            selectedChoice = EditProfileMultipleChoice.selectedChoice {
                
                if EditProfileMultipleChoice.headerTitle.title == "Relationship Status" {
                    relationshipStatusVar = selectedChoice
                    self.userProfileData["relationship_status"] = relationshipStatusVar
                } else if EditProfileMultipleChoice.headerTitle.title == "Interested In" {
                    interestedInVar = selectedChoice
                    self.userProfileData["interested_in"] = interestedInVar
                }
                
                //Save to phone storage
                NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
                
                //Save to parse
                let query = PFQuery(className: "_User")
                
                query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                    if error != nil {
                        
                    } else if let object = object {
                        //Save and Update Parse data
                        
                        //PFUser.currentUser()?["location"] = "N/A" //Get from geolocation
                        //PFUser.currentUser()?["about"] = "N/A"
                        PFUser.currentUser()?["relationship_status"] = self.relationshipStatusVar
                        PFUser.currentUser()?["interested_in"] = self.interestedInVar
                        
                        PFUser.currentUser()?.save()
                        
                        
                    }
                })
                
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MultipleChoiceSegue" {
            if let EditProfileMultipleChoice = segue.destinationViewController as? EditProfileMultipleChoice {
                EditProfileMultipleChoice.multiChoiceOptions = (sender as? [String])!
                EditProfileMultipleChoice.selectedChoice = currentSelectedChoice
                
            }

        }
    }

}
