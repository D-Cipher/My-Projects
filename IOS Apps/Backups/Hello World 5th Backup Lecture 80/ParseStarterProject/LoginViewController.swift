//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import CoreData
import Firebase

class LoginViewController: UIViewController {
    
    let firebase = Firebase(url: "https://helloworld-0.firebaseio.com")
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var context: NSManagedObjectContext? //Core Data Context
    
    var contactImporter: ContactImporter? //Contact Importer
    
    var remoteStore: RemoteStore? //Remote Store
    
    private func existingUserUpdate(fb_result: Dictionary<String,AnyObject>, parse_object: PFObject) {
        
        //print("Existing User parse")
        
        if NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") != nil {
            PFUser.currentUser()?["phoneNumber"] = NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as! String
        } else {
            PFUser.currentUser()?["phoneNumber"] = "N/A"
        }
        
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
        
        //print("New User parse")
        
        //Create new Parse data for user
        PFUser.currentUser()?["phoneNumber"] = "N/A"
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
    
    private func firebaseAuthwithFB(userFullName: String) {
        
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        
        firebase.authWithOAuthProvider("facebook", token: accessToken) { (error, authData) -> Void in
            if error != nil {
                print(error)
                self.activityIndFunc(0)
                
            } else {
                if let authData = authData {
                    
                    let facebookID = authData.uid.stringByReplacingOccurrencesOfString("facebook:", withString: "")
                    
                    //Check if new user
                    self.firebase.observeEventType(FEventType.Value) { (snapshot: FDataSnapshot!) -> Void in
                        guard let snapshot = snapshot.value["users"] else {
                            print("Error in retrieving snapshot")
                            self.activityIndFunc(0)
                            return
                        }
                        
                        if ((snapshot?.objectForKey(facebookID)) == nil) {
                            print("New user firebase")
                            self.firebase.childByAppendingPath("users").childByAppendingPath(facebookID).setValue(["phoneNumber": "needs validation", "name":userFullName])
                            
                            /* ??unsure if needed
                             //self.firebase.removeAllObservers()
                             //self.activityIndFunc(0)
                             //self.performSegueWithIdentifier("phoneVarification", sender: self)
                             */
                            
                        } else {
                            
                            self.firebase.childByAppendingPath("users").childByAppendingPath(facebookID).updateChildValues(["name" : userFullName])
                            
                            let user_phoneNum = (snapshot!.objectForKey(facebookID)!["phoneNumber"]!)! as! String
                            
                            let valid_phone = self.phoneValidate(user_phoneNum)
                            
                            if valid_phone == false {
                                print("Existing user firebase. Invalid phone.")
                                self.firebase.removeAllObservers()
                                self.activityIndFunc(0)
                                self.performSegueWithIdentifier("phoneVarification", sender: facebookID)
                                
                            } else if valid_phone == true {
                                print("Existing user firebase. Valid phone.")
                                
                                if NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") == nil {
                                    NSUserDefaults.standardUserDefaults().setObject(user_phoneNum, forKey: "phoneNumber")
                                }
                                
                                self.firebase.removeAllObservers()
                                
                                //Start Syncing
                                self.remoteStore?.startSyncing()
                                self.contactImporter?.fetch()
                                self.contactImporter?.listenForChanges()
                                
                                self.activityIndFunc(0)
                                self.performSegueWithIdentifier("tabBarSegue", sender: self)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func parseAuthwithFB(result_dict: Dictionary<String, AnyObject>) {
        
        let query = PFQuery(className: "_User")
        
        query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
            if error != nil {
                print(error)
                self.activityIndFunc(0)
                
            } else if let object = object {
                
                query.whereKey("FB_id", equalTo: result_dict["id"] as! String)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) in
                    if error != nil {
                        print(error)
                        self.activityIndFunc(0)
                        
                    } else {
                        
                        if (objects!.count > 0){
                            
                            print("Existing User Parse Update")
                            self.existingUserUpdate(result_dict, parse_object: object)
                            
                            self.firebaseAuthwithFB(result_dict["name"] as! String)
                            
                        } else {
                            
                            print("New User Add Parse")
                            self.newUserAdd(result_dict, parse_object: object)
                            
                            self.firebaseAuthwithFB(result_dict["name"] as! String)
                        }
                    }
                }
                
            }
        })
    }
    
    private func init_Authentication() {
        
        //Gets information about the user from Facebook.
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender, locale"])
        
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
                self.activityIndFunc(0)
                
            } else if let result = result {
                //print(result)
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                    
                    let result_dict = result as! Dictionary<String, AnyObject>
                    
                    self.parseAuthwithFB(result_dict)
                    
                })
            }
        }
        
    }
    
    
    @IBAction func FBloginButton(sender: AnyObject) {
        
        self.activityIndFunc(1, warningMsg: "Loading...")
        
        let permission = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permission) { (user: PFUser?, error: NSError?) -> Void in
            
            if error != nil {
                print(error)
                self.activityIndFunc(0)
                
            } else {
                if let user = user {
                    //print(user)
                    
                    self.init_Authentication()
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //contactImporter?.listenForChanges()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.activityIndFunc(1, warningMsg: "Loading...")
        
        guard let username = PFUser.currentUser()?.username else {
            self.activityIndFunc(0)
            return
        }
        
        guard firebase.authData != nil else {
            self.activityIndFunc(0)
            return
        }
        
        self.init_Authentication()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //PFUser.logOut() //For testing
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tabBarSegue" {
            
            let tab = segue.destinationViewController as! UITabBarController
            let nav_0 = tab.viewControllers![0] as! UINavigationController
            let nav_1 = tab.viewControllers![1] as! UINavigationController
            let nav_2 = tab.viewControllers![2] as! UINavigationController
            
            let chatTabVC = nav_0.topViewController as! ChatTabController
            let favoritesTabVC = nav_1.topViewController as! FavoritesTabController
            let contactsTabVC = nav_2.topViewController as! ContactsTabController
            
            chatTabVC.context = context
            favoritesTabVC.context = context
            contactsTabVC.context = context
        }
        
        if segue.identifier == "phoneVarification" {
            
            let nav = segue.destinationViewController as! UINavigationController
            
            if let phoneVarVC = nav.topViewController as? PhoneVarificationController {
                phoneVarVC.facebookID = sender as! String
                phoneVarVC.context = context
                phoneVarVC.remoteStore = remoteStore
                phoneVarVC.contactImporter = contactImporter
            }
        }
        
    }
}

