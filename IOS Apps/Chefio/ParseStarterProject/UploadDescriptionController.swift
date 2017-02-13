//
//  UploadDescriptionController.swift
//  Chefio
//
//  Created by Tingbo Chen on 5/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadDescriptionController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    let boarderGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
    let textGrey = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.4)
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var postData = Dictionary<String,AnyObject>()
    
    @IBOutlet var titleInput: UITextView!

    @IBOutlet var descripInput: UITextView!
    
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
    
    func textBoxSpecs() {
        
        let textBoxes = [descripInput, titleInput]
        
        for textBox in textBoxes {
            textBox.textContainerInset =
                UIEdgeInsetsMake(5,2,2,2)
            textBox.layer.borderWidth = 2.0
            textBox.layer.borderColor = boarderGray.CGColor
            textBox.layer.cornerRadius = 5.0
        }
        
    
    }
    
    func descripInputSpecs(status: Int = 0) {
        
        if status == 0 && self.descripInput.text.isEmpty {
            descripInput.text = "Add Description"
            descripInput.textColor = textGrey
            
        } else if status == 1 && descripInput.textColor == textGrey {
            descripInput.text = nil
            descripInput.textColor = UIColor.blackColor()
        }
    }
    
    func titleInputSpecs(status: Int = 0) {
        
        if status == 0 && self.titleInput.text.isEmpty {
            titleInput.text = "Add Title"
            titleInput.textColor = textGrey
            
        } else if status == 1 && titleInput.textColor == textGrey {
            titleInput.text = nil
            titleInput.textColor = UIColor.blackColor()
        }
    }
    
    
    func populateFields() {
        
        if NSUserDefaults().objectForKey("postData") != nil {
            
            var postData = NSUserDefaults().objectForKey("postData")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            descripInput.text = postData["descrip"]! as! String
            titleInput.text = postData["title"]! as! String
            
        } else {
            
            descripInput.text = ""
            titleInput.text = ""
            descripInputSpecs(0)
            titleInputSpecs(0)
            
        }

    }
    
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        
        if titleInput.text == "" || titleInput.text == nil || descripInput.text == "" || descripInput.text == nil || titleInput.text == "Add Title" || descripInput.text == "Add Description" {
            
            alertFunc(["Fields cannot be blank", "Your post must have a title and a description."])
            
        } else {
            
            postData["title"] = titleInput.text
            
            postData["descrip"] = descripInput.text
            
            NSUserDefaults.standardUserDefaults().setObject(postData, forKey: "postData")
            
            self.performSegueWithIdentifier("postImageSegue", sender: nil)
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textBoxSpecs()
        
        populateFields()
        
        descripInput.delegate = self
        titleInput.delegate = self
        
        navigationController?.navigationBar.topItem?.title = "Post"
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            
            let query = PFQuery(className: "_User")
            
            query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                if error != nil {
                    print(error)
                    self.activityIndFunc(0)
                    
                } else if let object = object {
                    
                    self.postData["name"] = object["name"]!
                    
                    //self.postData["userID"] = object["userID"]!
                    
                }
            })
            
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
        descripInputSpecs(1)
        titleInputSpecs(1)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        descripInputSpecs(0)
        titleInputSpecs(0)
    }
    
    //Tapping "Return" will tab to next label then submit and hide keyboard:
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            
            if titleInput.isFirstResponder() {
                titleInput.resignFirstResponder()
                return false
            }
        }
        return true
    }

}
