//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import CoreData

class LoginViewController: UIViewController {
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var context: NSManagedObjectContext? //Core Data Context
    
    private func existingUserUpdate(fb_result: Dictionary<String,AnyObject>, parse_object: PFObject) {
        
        print("Existing User")
        
        //Update User data in Parse based on FB
        PFUser.currentUser()?["name"] = fb_result["name"]
        PFUser.currentUser()?["first_name"] = fb_result["first_name"]
        PFUser.currentUser()?["last_name"] = fb_result["last_name"]
        PFUser.currentUser()?["gender"] = fb_result["gender"]
        PFUser.currentUser()?["age"] = "25" //Get from FB
        PFUser.currentUser()?["college"] = "N/A" //Get from FB
        PFUser.currentUser()?["work"] = "N/A" //Get from FB
        PFUser.currentUser()?["location"] = "N/A" //Get from geolocation
        
        PFUser.currentUser()?.save()
        
        self.userProfileData = [
            "username": (parse_object["username"] as? String)!,
            "FB_id": (fb_result["id"] as? String)!,
            "name":(fb_result["name"] as? String)!,
            "first_name":(fb_result["first_name"] as? String)!,
            "gender":(fb_result["gender"] as? String)!,
            "age":"25",
            
            "age_show":(parse_object["age_show"] as? String)!,
            "age_msg":(parse_object["age_msg"] as? String)!,
            "college":"N/A",
            "work":"N/A",
            "location":"N/A",
            "about":(parse_object["about"] as? String)!,
            "racial_id":(parse_object["racial_id"] as? String)!,
            "sexual_id":(parse_object["sexual_id"] as? String)!,
            "relationship_status":(parse_object["relationship_status"] as? String)!]
        
        //Save Data to phone storage
        NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
        
        //print(self.userProfileData)
        
        
        //====Updates User Pictures on Phone Storage from Parse
        self.userProfileImages = ["image_0":NSData(),"image_1":NSData(),"image_2":NSData(),"image_3":NSData(),"image_4":NSData(),"image_order":["image_1","image_2","image_3","image_4"]]
        
        self.userProfileImages["image_0"] = nil
        self.userProfileImages["image_1"] = nil
        self.userProfileImages["image_2"] = nil
        self.userProfileImages["image_3"] = nil
        self.userProfileImages["image_4"] = nil
        
        //Get image order from Parse:
        if PFUser.currentUser()?["image_order"] != nil {
            self.userProfileImages["image_order"] = PFUser.currentUser()?["image_order"]
        }
        
        //Get image_0 to image_4 from Parse:
        let image_str = ["image_0","image_1","image_2","image_3","image_4"]
        
        for (index,_) in image_str.enumerate() {
            if PFUser.currentUser()?[image_str[index]] != nil {
                PFUser.currentUser()?[image_str[index]]?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if let downloadedImage = UIImage(data: data!) {
                        if let imageData = UIImagePNGRepresentation(downloadedImage){
                            self.userProfileImages[image_str[index]] = imageData
                            
                            NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
                            //print("Profile Updated")
                        }
                    }
                })
            } else if PFUser.currentUser()?[image_str[index]] == nil {
                
                self.userProfileImages[image_str[index]] = nil
                
                NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
            }
            
        }
    }
    
    private func newUserAdd(fb_result: Dictionary<String,AnyObject>, parse_object: PFObject){
        
        print("New User")
        
        //Create new Parse data for user
        PFUser.currentUser()?["FB_id"] = fb_result["id"]
        PFUser.currentUser()?["name"] = fb_result["name"]
        PFUser.currentUser()?["first_name"] = fb_result["first_name"]
        PFUser.currentUser()?["last_name"] = fb_result["last_name"]
        PFUser.currentUser()?["gender"] = fb_result["gender"]
        
        PFUser.currentUser()?["age"] = "25" //Get from FB
        PFUser.currentUser()?["college"] = "N/A" //Get from FB
        PFUser.currentUser()?["work"] = "N/A" //Get from FB
        PFUser.currentUser()?["location"] = "N/A" //Get from geolocation
        
        PFUser.currentUser()?["age_show"] = "true"
        PFUser.currentUser()?["age_msg"] = "Default"
        PFUser.currentUser()?["about"] = "N/A"
        PFUser.currentUser()?["racial_id"] = "N/A"
        PFUser.currentUser()?["sexual_id"] = "Straight"
        PFUser.currentUser()?["relationship_status"] = "Single"
        
        PFUser.currentUser()?["image_order"] = ["image_1","image_2","image_3","image_4"]
        PFUser.currentUser()?.save()
        
        self.userProfileData = [
            "username": (parse_object["username"] as? String)!,
            "FB_id": (fb_result["id"] as? String)!,
            "name":(fb_result["name"] as? String)!,
            "first_name":(fb_result["first_name"] as? String)!,
            "gender":(fb_result["gender"] as? String)!,
            "age":"25",
            "age_show":"true",
            "age_msg":"Default",
            "college":"N/A",
            "work":"N/A",
            "location":"N/A",
            "about":"N/A",
            "racial_id":"N/A",
            "sexual_id":"Straight",
            "relationship_status":"Single"]
        
        //Save Data to phone storage
        NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
        
        //print(self.userProfileData)
        
        //Get User FB Profile Pic and Save to Parse and Perm storage
        let userID = fb_result["id"] as! String
        
        let facebookProfilePictureUrl = "https://graph.facebook.com/" + userID + "/picture?type=large"
        
        if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
            if let data = NSData(contentsOfURL: fbpicUrl) {
                
                self.userProfileImages = ["image_0":NSData(),"image_1":NSData(),"image_2":NSData(),"image_3":NSData(),"image_4":NSData(),"image_order":["image_1","image_2","image_3","image_4"]]
                
                self.userProfileImages["image_0"] = nil
                self.userProfileImages["image_1"] = nil
                self.userProfileImages["image_2"] = nil
                self.userProfileImages["image_3"] = nil
                self.userProfileImages["image_4"] = nil
                
                //Save Image File to Parse
                let imageFile: PFFile = PFFile(data: data)
                PFUser.currentUser()?["image_0"] = imageFile
                PFUser.currentUser()?.save()
                
                //Set userProfileImage
                if let imageData = UIImagePNGRepresentation(UIImage(data: data)!){
                    
                    self.userProfileImages["image_0"] = imageData
                    
                    NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
                }
                
            }
        }
    }
    
    
    private func initiateUserData() {
        
        //Gets information about the user from Facebook.
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender, locale"])
        
        self.activityIndFunc(1, warningMsg: "Loading...")
        
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
                self.activityIndFunc(0)
                
            } else if let result = result {
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                    
                    print(result)
                    
                    let query = PFQuery(className: "_User")
                    
                    query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                        if error != nil {
                            print(error)
                            self.activityIndFunc(0)
                            
                        } else if let object = object {
                            
                            query.whereKey("FB_id", equalTo: result["id"] as! String)
                            query.findObjectsInBackgroundWithBlock {
                                (objects: [AnyObject]?, error: NSError?) in
                                if error != nil {
                                    print(error)
                                    self.activityIndFunc(0)
                                    
                                } else {
                                    if (objects!.count > 0){
                                        
                                        //Existing User Data Update
                                        self.existingUserUpdate(result as! Dictionary<String, AnyObject>, parse_object: object)
                                        
                                        self.activityIndFunc(0)
                                        
                                        self.performSegueWithIdentifier("tabBarSegue", sender: self)
                                        
                                    } else {
                                        
                                        //New User Add Data
                                        self.newUserAdd(result as! Dictionary<String, AnyObject>, parse_object: object)
                                        
                                        self.activityIndFunc(0)
                                        
                                        self.performSegueWithIdentifier("tabBarSegue", sender: self)
                                        
                                    }
                                }
                            }
                            
                        }
                    })
                    
                }
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            print("Object has been saved.")
        }
        */
    }
    
    @IBAction func FBloginButton(sender: AnyObject) {
        let permission = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permission) { (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                print(error)
            } else {
                if let user = user {
                    print(user)
                    
                    self.initiateUserData()
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let username = PFUser.currentUser()?.username {
            
            self.initiateUserData()
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //PFUser.logOut() //For testing
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tab = segue.destinationViewController as! UITabBarController
        let nav = tab.viewControllers![0] as! UINavigationController
        let chatTabVC = nav.topViewController as! ChatTabController
        
        chatTabVC.context = context
        
    }
    
}

