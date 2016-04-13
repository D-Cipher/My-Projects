//
//  EditProfileAge.swift
//  Hello World
//
//  Created by Tingbo Chen on 3/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class EditProfileAge: UIViewController, UITextViewDelegate {
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    @IBOutlet var addMessageField: UITextView!
    
    @IBOutlet var customAgeLabel: UILabel!
    
    @IBOutlet var showAgeSwitchOutlet: UISwitch!
    
    @IBAction func showAgeSwitch(sender: AnyObject) {
        if showAgeSwitchOutlet.on {
            customAgeLabel.hidden = true
            addMessageField.hidden = true
        } else {
            customAgeLabel.hidden = false
            addMessageField.hidden = false
        }
        
    }
    
    func saveAgeStatusData() {
        //Save Perm storage and Save to Parse
        
        if showAgeSwitchOutlet.on == true {
            self.userProfileData["age_show"] = "true"
        } else if showAgeSwitchOutlet.on == false {
            self.userProfileData["age_show"] = "false"
        }
        
        if addMessageField.text == "Sorry, but you will have to ask me for my age." || addMessageField.text.isEmpty {
            self.userProfileData["age_msg"] = "Default"
        } else {
            self.userProfileData["age_msg"] = addMessageField.text
        }
        
        NSUserDefaults.standardUserDefaults().setObject(self.userProfileData, forKey: "userProfileData")
        print("saved")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
            
            let query = PFQuery(className: "_User")
            
            query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                if error != nil {
                    print(error)
                } else if let object = object {
                    if self.showAgeSwitchOutlet.on == true {
                        PFUser.currentUser()?["age_show"] = "true"
                    } else if self.showAgeSwitchOutlet.on == false {
                        PFUser.currentUser()?["age_show"] = "false"
                    }
                    
                    if self.addMessageField.text == "Sorry, but you will have to ask me for my age." || self.addMessageField.text.isEmpty {
                        PFUser.currentUser()?["age_msg"] = "Default"
                    } else {
                        PFUser.currentUser()?["age_msg"] = self.addMessageField.text
                    }
                    
                    PFUser.currentUser()?.save()
                }
            })
            
        })
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
            self.addMessageField.text = "Sorry, but you will have to ask me for my age."
            self.addMessageField.textColor = textGrey
        } else if status == 1 && addMessageField.textColor == textGrey {
            self.addMessageField.text = nil
            self.addMessageField.textColor = UIColor.blackColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults().objectForKey("userProfileData") != nil {
            self.userProfileData = NSUserDefaults().objectForKey("userProfileData")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            //self.age_var = self.userProfileData["age"] as? String
            
            //self.ageShow_var = self.userProfileData["age_show"] as? String
            
            //self.ageMsg_var = self.userProfileData["age_msg"] as? String
            
        }
        
        //print(userProfileData)
        
        self.addMessageField.delegate = self
        
        //Set up switch and text field
        if self.userProfileData["age_msg"] as! String == "Default" {
            addMessageField.text = ""
        } else {
            addMessageField.text = self.userProfileData["age_msg"] as! String
        }
        
        if self.userProfileData["age_show"] as! String == "true" {
            showAgeSwitchOutlet.on = true
            customAgeLabel.hidden = true
            addMessageField.hidden = true
        } else if self.userProfileData["age_show"] as! String == "false" {
            showAgeSwitchOutlet.on = false
            customAgeLabel.hidden = false
            addMessageField.hidden = false
        }
        
        self.textBoxSpecs(0)
        
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
    
    //Segue Back to EditProfileMainController
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            
            self.saveAgeStatusData()
        }
    }


}
