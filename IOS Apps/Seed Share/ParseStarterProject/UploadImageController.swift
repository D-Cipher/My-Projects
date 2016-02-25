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
    
    @IBOutlet var uploadBar: UINavigationBar!
    
    @IBOutlet var ImageOutlet: UIImageView!
    
    @IBOutlet var addMessageField: UITextView!
    
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
            
            self.addMessageField.text = ""
            
            self.textBoxSpecs(0)
            
        } else if status == 0 {
            
            self.ImageOutlet.contentMode = .ScaleToFill
            
            self.ImageOutlet.alpha = 1
            
        }
        
    }
    
    func textBoxSpecs(status: Int = 0) {
        
        let boarderGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
        let textGrey = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.4)
        self.addMessageField.textContainerInset =
            UIEdgeInsetsMake(5,2,2,2)
        self.addMessageField.layer.borderWidth = 2.0
        self.addMessageField.layer.borderColor = boarderGray.CGColor
        self.addMessageField.layer.cornerRadius = 5.0
        
        if status == 0 && self.addMessageField.text.isEmpty {
            self.addMessageField.text = "Add message"
            self.addMessageField.textColor = textGrey
        } else if status == 1 && addMessageField.textColor == textGrey {
            self.addMessageField.text = nil
            self.addMessageField.textColor = UIColor.blackColor()
        }
    }
    
    @IBAction func postButton(sender: AnyObject) {
        
        if ImageOutlet.image != nil && self.ImageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            //Turn on Spinner
            self.activityIndFunc(1)
            
            //Upload Image To Parse
            let post = PFObject(className: "Posts")
            
            if addMessageField.text == "Add message" {
                post["message"] = ""
            } else {
                post["message"] = addMessageField.text
            }
            
            post["userID"] = PFUser.currentUser()!.objectId!
            
            post["date"] = self.dateString()

            let imageData = UIImagePNGRepresentation(ImageOutlet.image!)
            
            let imageFile = PFFile(name: "image.png", data: imageData!)
            
            post["imageFile"] = imageFile
            
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    //print("success")
                    self.activityIndFunc(0)
                    
                    //Post Success Alert
                    //self.alertFunc(["Upload Successful", "Your post has been updated."])
                    
                    self.placeholdPicReset(1)
                    
                } else {
                    
                    self.alertFunc(["Upload Unsuccessful", String(error)])
                }
            }
            
        } else {
            //Please select Image Alert
            self.alertFunc(["No Image to Post", "Please choose an image to post."])
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //print("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ImageOutlet.image = image
        
        if self.ImageOutlet.image != nil && self.ImageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            
            self.placeholdPicReset(0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textBoxSpecs(0)
        
        self.addMessageField.delegate = self
        
        self.uploadBar.topItem?.title = self.dateString()
        
        self.placeholdPicReset(1)
        
        //Set the initial load to the Feed tab
        dispatch_async(dispatch_get_main_queue()) {
            self.tabBarController!.selectedIndex = 1
            //self.performSegueWithIdentifier("feedSegue", sender: self)  //alternative
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tapping Outside the keyboard will close it:
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.textBoxSpecs(1)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.textBoxSpecs(0)
    }

    
    //Tapping "Return" will tab to next label then submit and hide keyboard:
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
