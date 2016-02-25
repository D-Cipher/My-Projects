//
//  PlayViewController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import Foundation

class PlayViewController: UIViewController {
    
    var userProfileData = Dictionary<String,String>()
    
    var userFBprofImage = [UIImage]()

    func updateUserProfileData() {
        
        //Gets information about the user from Facebook.
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, gender, locale"])
        
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if let result = result {
                print(result)
                
                let query = PFQuery(className: "_User")
                
                query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                    if error != nil {
                        
                    } else if let object = object {
                        
                        query.whereKey("FB_id", equalTo: result["id"] as! String)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [AnyObject]?, error: NSError?) in
                            if error == nil {
                                if (objects!.count > 0){
                                    print("Existing User")
                                    
                                    //Update User Parse data
                                    PFUser.currentUser()?["name"] = result["name"]
                                    PFUser.currentUser()?["first_name"] = result["first_name"]
                                    PFUser.currentUser()?["gender"] = result["gender"]
                                    PFUser.currentUser()?["college"] = "N/A" //Get from FB
                                    PFUser.currentUser()?["location"] = "N/A" //Get from geolocation
                                    
                                    PFUser.currentUser()?.save()
                                    
                                    //Set userProfileData
                                    self.userProfileData = ["id": (result["id"] as? String)!,
                                        "name":(result["name"] as? String)!,"first_name":(result["first_name"] as? String)!,
                                        "gender":(result["gender"] as? String)!,"college":"N/A","location":"N/A","about":(object["about"] as? String)!,
                                        "relationship_status":(object["relationship_status"] as? String)!,"interested_in":(object["interested_in"] as? String)!]
                                    
                                    //Save to phone storage
                                    NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
                                    
                                    print(self.userProfileData)
                                    
                                } else {
                                    print("New User")
                                    
                                    var interestedIn_guess = ""
                                    
                                    if result["gender"] as! String == "male" {
                                        interestedIn_guess = "women"
                                    } else if result["gender"] as! String == "female" {
                                        interestedIn_guess = "men"
                                    }
                                    
                                    //Save and Update Parse data
                                    PFUser.currentUser()?["FB_id"] = result["id"]
                                    PFUser.currentUser()?["name"] = result["name"]
                                    PFUser.currentUser()?["first_name"] = result["first_name"]
                                    PFUser.currentUser()?["gender"] = result["gender"]
                                    PFUser.currentUser()?["college"] = "N/A" //Get from FB
                                    PFUser.currentUser()?["location"] = "N/A" //Get from geolocation
                                    
                                    PFUser.currentUser()?["about"] = "N/A"
                                    PFUser.currentUser()?["relationship_status"] = "N/A"
                                    PFUser.currentUser()?["interested_in"] = interestedIn_guess
                                    
                                    PFUser.currentUser()?.save()
                                    
                                    //Set userProfileData
                                    self.userProfileData = ["id": (result["id"] as? String)!,
                                        "name":(result["name"] as? String)!,"first_name":(result["first_name"] as? String)!,
                                        "gender":(result["gender"] as? String)!,"college":"N/A","location":"N/A","about":"N/A",
                                        "relationship_status":"N/A","interested_in":interestedIn_guess]
                                    
                                    //Save to phone storage
                                    NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
                                    
                                    print(self.userProfileData)
                                }
                            } else {
                                print("error")
                            }
                        }
                        
                    }
                })
                
                /*
                //Get User FB Profile Pic
                let userID = result["id"] as! String
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userID + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        //self.profilePic.image = UIImage(data: data)
                        
                        //self.nameOutlet.text = result["first_name"] as? String
                        
                        self.userFBprofImage = [UIImage(data: data)!]
                        
                        //Save Image File to Parse
                        let imageFile: PFFile = PFFile(data: data)
                        PFUser.currentUser()?["image"] = imageFile
                        PFUser.currentUser()?.save()
                        
                    }
                }
                */
            }

        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUserProfileData()
        
        //Get user Profile Preferences from Parse
        //if user exists in parse then save userprofiledata to perm data
        //if perm data is not empty then
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
