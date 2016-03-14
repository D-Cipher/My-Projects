//
//  ProfileViewController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UITableViewController {
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    @IBOutlet var profileImageOutlet: UIImageView!
    
    @IBOutlet var bgImageOutlet: UIImageView!

    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet var titleLabel_1: UILabel!
    
    @IBOutlet var titleLabel_2: UILabel!
    
    @IBOutlet var titleLabel_3: UILabel!
    
    @IBOutlet var titleLabel_4: UILabel!
    
    @IBOutlet var subLabel_1: UILabel!
    
    @IBOutlet var subLabel_2: UILabel!
    
    @IBOutlet var subLabel_3: UILabel!
    
    @IBOutlet var subLabel_4: UILabel!
    
    @IBAction func editProfileButton(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfileSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults().objectForKey("userProfileData") != nil {
            self.userProfileData = NSUserDefaults().objectForKey("userProfileData")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            self.userNameLabel.text = self.userProfileData["name"] as? String
        }
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            if self.userProfileImages["image_0"] != nil {
                self.profileImageOutlet.image = UIImage(data: (self.userProfileImages["image_0"] as? NSData)!)
            }
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        //Adjust subLabel Text size
        let font_ratio = self.view.frame.size.width / 375.0
        self.subLabel_1.font = UIFont(name: "HelveticaNeue", size: 14 * font_ratio)
        self.subLabel_2.font = UIFont(name: "HelveticaNeue", size: 14 * font_ratio)
        self.subLabel_3.font = UIFont(name: "HelveticaNeue", size: 14 * font_ratio)
        self.subLabel_4.font = UIFont(name: "HelveticaNeue", size: 14 * font_ratio)
        
        //Round out corner of images
        profileImageOutlet.layer.masksToBounds = true
        profileImageOutlet.layer.cornerRadius = CGRectGetWidth(self.profileImageOutlet.frame)/8.0
        
        profileImageOutlet.layer.borderWidth = 2
        profileImageOutlet.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Set background image
        bgImageOutlet.image = UIImage(named: "blacktexture.png")
        bgImageOutlet.layer.masksToBounds = true
        bgImageOutlet.contentMode = .ScaleAspectFill
        
        /*
        //create blur effect
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = bgImageOutlet.bounds
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        visualEffectView.alpha = 0.6
        bgImageOutlet.addSubview(visualEffectView)
        */


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 207 * (view.frame.height/736)
        }
        else {
            return 80
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            //print("public profile")
            self.performSegueWithIdentifier("userPublicProfileSegue", sender: self)
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            print(indexPath.row)
            
            //performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Single","In Relationship","N/A"])
            
        } else if indexPath.section == 0 && indexPath.row == 2 {
            print(indexPath.row)
            
            //performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Men","Women","Both","N/A"])
        } else if indexPath.section == 0 && indexPath.row == 3 {
            print(indexPath.row)
            
        } else if indexPath.section == 0 && indexPath.row == 4 {
            print(indexPath.row)
        }
        
        return indexPath
    }
    
    @IBAction func unwindToProfileView(segue:UIStoryboardSegue) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
