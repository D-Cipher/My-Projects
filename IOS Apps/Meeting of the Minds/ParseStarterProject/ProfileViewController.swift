//
//  ProfileViewController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    var userProfileData = Dictionary<String,String>()
    
    @IBAction func editProfileButton(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfileSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults().objectForKey("userProfileData") != nil {
            
            self.userProfileData = NSUserDefaults().objectForKey("userProfileData")! as! NSDictionary as! Dictionary<String,String>
        } else {
            print("error")
        }
        
        //print(self.userProfileData)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromEditProfileMain(segue:UIStoryboardSegue) {
        
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
