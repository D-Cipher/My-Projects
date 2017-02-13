//
//  UploadImageController.swift
//  Chefio
//
//  Created by Tingbo Chen on 5/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

//
//  UploadImageController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 6/7/15.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadImageController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var ImageOutlet: UIImageView!
    
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.ImageOutlet.image = UIImage(named: "placeholder-camera-green.png")
    }
    
    func activityIndFunc(status: Int = 0) {
        
        if status == 1 {
            //Show Activity Indicator
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        } else if status == 0 {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        
    }
    
    func alertFunc(alertMsg: [AnyObject]) {
        
        //Alerts
        let alert = UIAlertController(title: alertMsg[0] as? String, message: alertMsg[1] as? String, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func dateString() -> String {
        //Date Extraction
        var dateValue: String = ""
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        dateValue = String(dateComponents.month) + "/" + String(dateComponents.day) + "/" + String(dateComponents.year)
        
        return dateValue
    }
    
    func placeholdPicReset(status: Int = 0) {
        if status == 1 {
            //Resets placeholders
            self.ImageOutlet.contentMode = .ScaleToFill
            
            self.ImageOutlet.image = UIImage(named: "placeholder-camera-green.png")
            
            self.ImageOutlet.alpha = 0.5
            
        } else if status == 0 {
            
            self.ImageOutlet.contentMode = .ScaleToFill
            
            self.ImageOutlet.alpha = 1
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //print("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ImageOutlet.image = image
        
        if self.ImageOutlet.image != nil && self.ImageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            
            self.placeholdPicReset(0)
            
            if let imageData = UIImagePNGRepresentation(self.ImageOutlet.image!){
                
                NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "userProfileImages")
                print("saved New Image")
            }
            
        }
        
    }
    
    @IBAction func chooseImageButton(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //image.sourceType = UIImagePickerControllerSourceType.Camera //To import from camera
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBAction func postButton(sender: AnyObject) {
        
        let imageData = NSUserDefaults().objectForKey("userProfileImages")
        
        let postWarning = ["Are you sure?", "Are you sure you want to post?"]
            
        let alert = UIAlertController(title: postWarning[0], message: postWarning[1], preferredStyle: UIAlertControllerStyle.Alert)
            
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                
        //Turn on Spinner
        self.activityIndFunc(1)
                
        //Upload Image To Parse
        let post = PFObject(className: "Posts")
            
        if NSUserDefaults().objectForKey("postData") != nil {
            var postData = NSUserDefaults().objectForKey("postData")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            post["title"] = postData["title"]
            
            post["descrip"] = postData["descrip"]
            
            post["date"] = self.dateString()
            
            post["name"] = postData["name"]
            
            post["authData"] = postData["authData"]
            
            var imageData = UIImagePNGRepresentation(UIImage())
            
            if NSUserDefaults().objectForKey("userProfileImages") != nil {
                
                let image = UIImage(data: (NSUserDefaults().objectForKey("userProfileImages") as? NSData)!)
                
                imageData = UIImagePNGRepresentation(image!)
                
                let imageFile = PFFile(name: "image.png", data: imageData!)
                
                post["imageFile"] = imageFile
                
            } else {
                print("image error")
            }
        
        } else {
            print("data error")
        }

        post.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                        
                self.activityIndFunc(0)
                        
                //Post Success Alert
                self.alertFunc(["Upload Successful", "Your post has been updated."])
                
                //Clear saved data
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userProfileImages")
                        
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "postData")
                        
                } else {
                        
                    self.alertFunc(["Upload Unsuccessful", String(error)])
                    self.activityIndFunc(0)
                }
            }
                
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                
        }))
            
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            
            self.ImageOutlet.image = UIImage(data: (NSUserDefaults().objectForKey("userProfileImages") as? NSData)!)
            
        } else {
        
            self.placeholdPicReset(1)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

