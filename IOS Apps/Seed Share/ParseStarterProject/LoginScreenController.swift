//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var mode = 0
    
    var clearAllFields: Bool = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var currentCredentials: [AnyObject] = []

    @IBOutlet var welcomeOutlet: UILabel!
    
    @IBOutlet var textFieldTop: UITextField!
    
    @IBOutlet var textFieldMid: UITextField!
    
    @IBOutlet var textFieldBot: UITextField!
    
    @IBOutlet var centralButtonOutlet: UIButton!
    
    @IBOutlet var sideButtonOutlet: UIButton!

    @IBOutlet var modeLabel: UILabel!
    
    @IBOutlet var rememberOutlet: UISwitch!
    
    func alertFunc(alertMsg: [AnyObject]) {
        
        //Alerts
        let alert = UIAlertController(title: alertMsg[0] as? String, message: alertMsg[1] as? String, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func activityIndFunc(status: Int = 0) {
        
        if status == 1 {
            //Show Activity Indicator
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
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
    
    @IBAction func centralButton(sender: AnyObject?) {
        
        //Tapping button stops text field editing:
        self.textFieldTop.endEditing(true)
        self.textFieldMid.endEditing(true)
        self.textFieldBot.endEditing(true)
        
        if self.mode == 0 {
            //print("Log In") For testing
            
            if textFieldMid.text != "" && textFieldBot.text != "" {
                
                self.activityIndFunc(1) //Turn on Act Indicator
                
                //Access Parse for User Credentials
                PFUser.logInWithUsernameInBackground(textFieldMid.text!, password: textFieldBot.text!, block: { (user, error) -> Void in
                    if user != nil {
                        //print("Logged In")
                        
                        //Remember me - save to perm storage
                        if self.rememberOutlet.on == true {
                            
                            self.currentCredentials = []
                            self.currentCredentials.append(self.textFieldMid.text!)
                            self.currentCredentials.append(self.textFieldBot.text!)
                            NSUserDefaults.standardUserDefaults().setObject(self.currentCredentials, forKey: "savedArray") //Saving new savedArray
                        }
                        
                        self.activityIndFunc(0) //Turn off Act Indicator
                        
                        //Preform Segue
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? NSString {
                            
                            self.alertFunc(["Login Unsuccessful",errorString])
                            
                            self.activityIndFunc(0) //Turn off Act Indicator
                        }
                    }
                })
                
            } else if textFieldMid.text == "" || textFieldBot.text == "" {
                
                //Invalid Login Alert
                self.alertFunc(["Invalid Login","Username or password cannot be blank."])
            }

            
        } else if self.mode == 1 {
            //print("Sign Up") //for testing
            
            if textFieldTop.text != "" && textFieldMid.text != "" && textFieldBot.text != "" && textFieldMid.text == textFieldBot.text {
                
                self.activityIndFunc(1) //Turn on Activity Indicator
                
                //Save User to Parse
                let user = PFUser()
                user.username = textFieldTop.text
                user.password = textFieldBot.text
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityIndFunc(0) //Turn off Act Indicator
                    
                    if error == nil{
                        //print("Signup Successful")
                        
                        //Sign up Success Alert
                        self.alertFunc(["Sign-up Successful","You are now successfully signed up."])
                        
                        //Activate Side Button
                        self.clearAllFields = false
                        self.textFieldMid.text = self.textFieldTop.text
                        self.sideButton(nil)
                        
                    } else {
                        if let errorString = error!.userInfo["error"] as? NSString {
                            
                            self.alertFunc(["Sign-up Unsuccessful",errorString])
                            
                            self.activityIndFunc(0) //Turn off Act Indicator
                        }
                        
                    }
                })
                
                
                
            } else if textFieldMid.text == "" || textFieldBot.text == "" {
                
                //Blank Field Alert
                self.alertFunc(["Invalid Sign-up","Username or password cannot be blank."])
                
            } else if textFieldMid.text != textFieldBot.text {
                
                //Password Mismatch Alert
                self.alertFunc(["Password Mismatch","Password and Confirmed Password did not match."])
            }
        }
        
    }
    
    @IBAction func sideButton(sender: AnyObject?) {
        
        self.mode = (self.mode + 1) % 2
        
        if self.clearAllFields == true {
            textFieldTop.text = ""
            textFieldMid.text = ""
            textFieldBot.text = ""
        } else if self.clearAllFields == false {
            self.clearAllFields = true
        }
        
        if self.mode == 0 {
            
            //Adjusts fields and buttons
            welcomeOutlet.hidden = false
            textFieldTop.hidden = true
            textFieldMid.placeholder = "User Name"
            textFieldMid.secureTextEntry = false
            textFieldBot.placeholder = "Password"
            
            modeLabel.text = "Not registered?"
            
            centralButtonOutlet.setTitle("Log In", forState: .Normal)
            sideButtonOutlet.setTitle("Sign Up", forState: .Normal)
            
        } else if self.mode == 1 {
            
            //Adjusts fields and buttons
            welcomeOutlet.hidden = true
            textFieldTop.hidden = false
            textFieldMid.placeholder = "Password"
            textFieldMid.secureTextEntry = true
            textFieldBot.placeholder = "Confirm Password"
            
            modeLabel.text = "Already registered?"
            
            centralButtonOutlet.setTitle("Sign Up", forState: .Normal)
            sideButtonOutlet.setTitle("Log In", forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lets text fields be controlled by delegate
        self.textFieldTop.delegate = self
        self.textFieldMid.delegate = self
        self.textFieldBot.delegate = self
        
        textFieldTop.hidden = true
        
        //Access Perm Storage
        if NSUserDefaults().objectForKey("savedArray") != nil {
            self.currentCredentials = NSUserDefaults().objectForKey("savedArray")! as! NSArray as [AnyObject] //Converting back to Array
            
            textFieldMid.text = currentCredentials[0] as? String
            
            textFieldBot.text = currentCredentials[1] as? String
            
            //print(currentCredentials)
        }
        
        /*
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            print("Object has been saved.")
        }
        */
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        /*
        if PFUser.currentUser() != nil {
            //remember to give segue the identifier "login"
            self.performSegueWithIdentifier("login", sender: self)
        }
        */

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tapping Outside the keyboard will close it:
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //Tapping "Return" will tab to next label then submit and hide keyboard:
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.textFieldTop {
            self.textFieldMid.becomeFirstResponder()
            
        } else if textField == self.textFieldMid {
            self.textFieldBot.becomeFirstResponder()
            
        } else if textField == self.textFieldBot {
            
            textField.resignFirstResponder()
            self.centralButton(nil)
        }
        
        return true
    }
}

