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
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()

    @IBOutlet var profilePicOutlet: UIImageView!
    
    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet var ageDetail: UILabel!
    
    @IBOutlet var relationshipStatusDetail: UILabel!
    
    @IBOutlet var sexualIdDetail: UILabel!
    
    @IBOutlet var racialIdDetail: UILabel!
    
    @IBOutlet var collegeDetail: UILabel!
    
    var currentSelectedChoice:String? = "N/A"
    
    var relationshipStatusVar:String? = "Single" {
        didSet {
            
            relationshipStatusDetail.text? = relationshipStatusVar!
        
        }
    }
    
    var sexualIdVar:String? = "Straight" {
        didSet {
            
            sexualIdDetail.text? = sexualIdVar!
            
        }
    }
    
    var racialIdVar:String? = "N/A" {
        didSet {
            
            racialIdDetail.text? = racialIdVar!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        //print("init PlayerDetailsViewController")
        super.init(coder: aDecoder)
    }
    
    deinit {
        //print("deinit PlayerDetailsViewController")
    }
    
    func updateUserProfileDetails() {
        if NSUserDefaults().objectForKey("userProfileData") != nil {
            self.userProfileData = NSUserDefaults().objectForKey("userProfileData")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            self.relationshipStatusVar = self.userProfileData["relationship_status"] as? String
            
            self.sexualIdVar = self.userProfileData["sexual_id"] as? String
            
            self.racialIdVar = self.userProfileData["racial_id"] as? String
            
            self.userNameLabel.text = self.userProfileData["first_name"] as? String
            
            if self.userProfileData["age_show"] as? String == "true" {
                self.ageDetail.text = self.userProfileData["age"] as? String
            } else if self.userProfileData["age_show"] as? String == "false" {
                self.ageDetail.text = "Custom"
            }
        }
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            if self.userProfileImages["image_0"] != nil {
                self.profilePicOutlet.image = UIImage(data: (self.userProfileImages["image_0"] as? NSData)!)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //Adjust text size
        let font_ratio = self.view.frame.size.width / 375.0
        self.collegeDetail.font = UIFont(name: "HelveticaNeue", size: 15 * font_ratio)
        */
        
        
        //Round out corner of images
        self.profilePicOutlet.layer.masksToBounds = true
        self.profilePicOutlet.layer.cornerRadius = CGRectGetWidth(self.profilePicOutlet.frame)/6.0
        
        self.updateUserProfileDetails()
        
        //print(self.userProfileData)

    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            //print("profile_pic")
            self.performSegueWithIdentifier("EditPictureSegue", sender: self)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("AgeSwitchSegue", sender: self)
            
        } else if indexPath.section == 2 && indexPath.row == 0 {
            //print("racial_id")
            
            currentSelectedChoice = racialIdVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["White","Black","Hispanic","Asian","Other","N/A"])
            
        } else if indexPath.section == 2 && indexPath.row == 1 {
            //print("interested_in")
            
            currentSelectedChoice = sexualIdVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Straight","Gay","Bi","N/A"])
            
        } else if indexPath.section == 2 && indexPath.row == 2 {
            //print("relationship_status")
            
            currentSelectedChoice = relationshipStatusVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Single","In Relationship","N/A"])
        } else if indexPath.section == 3 && indexPath.row == 0 {
            //print("Hello World")
            
            performSegueWithIdentifier("aboutTextFieldSegue", sender: self)
        }
        
        return indexPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Unwind Multiple Choice Segue
    @IBAction func unwindToEditProfileMain(segue:UIStoryboardSegue) {
        
        if let EditProfileMultipleChoice = segue.sourceViewController as? EditProfileMultipleChoice,
            selectedChoice = EditProfileMultipleChoice.selectedChoice {
                
                if EditProfileMultipleChoice.headerTitle.title == "Relationship Status" {
                    relationshipStatusVar = selectedChoice
                    self.userProfileData["relationship_status"] = relationshipStatusVar
                } else if EditProfileMultipleChoice.headerTitle.title == "Sexual Identity" {
                    sexualIdVar = selectedChoice
                    self.userProfileData["sexual_id"] = sexualIdVar
                } else if EditProfileMultipleChoice.headerTitle.title == "Racial Identity" {
                    racialIdVar = selectedChoice
                    self.userProfileData["racial_id"] = racialIdVar
                }
                
        }
        
        //Save to phone storage
        NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
            //Save to parse
            let query = PFQuery(className: "_User")
            
            query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                if error != nil {
                    print(error)
                } else if let object = object {
                    //Save and Update Parse data
                    
                    //PFUser.currentUser()?["location"] = "N/A" //Get from geolocation
                    //PFUser.currentUser()?["about"] = "N/A"
                    PFUser.currentUser()?["relationship_status"] = self.relationshipStatusVar
                    PFUser.currentUser()?["sexual_id"] = self.sexualIdVar
                    PFUser.currentUser()?["racial_id"] = self.racialIdVar
                    
                    PFUser.currentUser()?.save()
                }
            })
            
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUserProfileDetails()

        
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
