//
//  RenameViewController.swift
//  Where Is My Car
//
//  Created by Tingbo Chen on 2/11/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class RenameViewController: UIViewController, UITextFieldDelegate {
    
    var tempBmArray: [AnyObject] = []
    
    var bookmarkedArray: [AnyObject] = []
    
    var newname_dict = Dictionary<String,String>()

    @IBOutlet var inputFieldOutlet: UITextField!
    
    func textSpecs(status: Int = 0) {
        
        let textGrey = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.6)
        
        if status == 0 && self.inputFieldOutlet.text!.isEmpty {
            if self.tempBmArray.count > 0 {
                self.inputFieldOutlet.text = self.tempBmArray[0]["name"] as? String
            }
            
            self.inputFieldOutlet.textColor = textGrey
        } else if status == 1 && self.inputFieldOutlet.textColor == textGrey {
            self.inputFieldOutlet.text = nil
            self.inputFieldOutlet.textColor = UIColor.blackColor()
        }
    }
    
    
    func alertFunc(alertMsg: [AnyObject], status: Int = 1) {
        
        //Alerts
        let alert = UIAlertController(title: alertMsg[0] as? String, message: alertMsg[1] as? String, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            if status == 1 {
                //self.navigationController?.popViewControllerAnimated(true) //to go back to previous segue
                self.performSegueWithIdentifier("unwindToBookmarkedController", sender: self)
                
            }

        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButtonAction(sender: AnyObject?) {
        
        if self.tempBmArray.count > 0 && inputFieldOutlet.text != "" {
            
            self.newname_dict = ["name":self.inputFieldOutlet.text!,"lat":(self.tempBmArray[0]["lat"] as? String)!,"long":(self.tempBmArray[0]["long"] as? String)!,"address":(self.tempBmArray[0]["address"] as? String)!]
            
            self.bookmarkedArray.insert(self.newname_dict, atIndex: 0)
            
            NSUserDefaults.standardUserDefaults().setObject(self.bookmarkedArray, forKey: "bookmarkedArray")
            
            //print(self.bookmarkedArray) //for testing
            
            self.alertFunc(["Successfully Bookmarked", "Your location has been bookmarked."], status: 1)
            
        } else if self.tempBmArray.count > 0 && inputFieldOutlet.text == "" {
            
            self.alertFunc(["Please name bookmark", "Bookmarked location name cannot be blank."], status: 0)
            
        } else {
            //self.navigationController?.popViewControllerAnimated(true)
            
            self.performSegueWithIdentifier("unwindToBookmarkedController", sender: self)
        }

    }
    
    
    func getPermData2() {
        
        //Gets the tempBm Data
        if NSUserDefaults().objectForKey("tempBmArray") != nil {
            self.tempBmArray = NSUserDefaults().objectForKey("tempBmArray")! as! NSArray as [AnyObject] //Converting back to Array
            
        }
        
        //Gets the Bookmarked Data
        if NSUserDefaults().objectForKey("bookmarkedArray") != nil {
            self.bookmarkedArray = NSUserDefaults().objectForKey("bookmarkedArray")! as! NSArray as [AnyObject] //Converting back to Array
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputFieldOutlet.delegate = self
        
        self.getPermData2()
        
        self.textSpecs(0)
        
        //if self.tempBmArray.count > 0 {
        //    self.inputFieldOutlet.text = self.tempBmArray[0]["name"] as? String
        //}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.textSpecs(1)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.textSpecs(0)
    }
    
    //Tapping Outside the keyboard will close it:
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //Tapping "Return" will close the keyboard:
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.submitButtonAction(nil)
        
        return true
    }
    
}
