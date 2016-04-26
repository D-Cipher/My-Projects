//
//  PhoneVarificationController.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreData

class PhoneVarificationController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet var countryTextOutlet: UITextField!
    @IBOutlet var mobileTextOutlet: UITextField!
    @IBOutlet var submitButtonOutlet: UIButton!
    
    var facebookID = ""
    
    var context: NSManagedObjectContext? //Core Data Context
    
    var contactImporter: ContactImporter? //Contact Importer
    
    var remoteStore: RemoteStore? //Remote Store
    
    @IBAction func submitButtonAction(sender: AnyObject) {
        
        guard phoneValidate(mobileTextOutlet.text!) == true else {
            okAlert("Invalid Phone", message: "Please your mobile phone number.")
            return
        }
        
        let alertMsg = ["Phone Number Varification", "We will send a varification code to the following number: " + countryTextOutlet.text! + " " + mobileTextOutlet.text!]
        
        let continueAlert = UIAlertController(title: alertMsg[0], message: alertMsg[1], preferredStyle: UIAlertControllerStyle.Alert)
        
        continueAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.remoteStore?.signUp(phoneNumber: self.mobileTextOutlet.text!, facebookID: self.facebookID, success: {
                
                }, error: {
                    errorString in
            })
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        continueAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
        }))
        
        presentViewController(continueAlert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func countryTextAction(sender: AnyObject) {
        
        let first_char = countryTextOutlet.text![(countryTextOutlet.text?.startIndex)!]
        
        if first_char != "+" {
            countryTextOutlet.text = "+" + countryTextOutlet.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "Varification"
        
        mobileTextOutlet.delegate = self
        countryTextOutlet.delegate = self
        submitButtonOutlet.layer.cornerRadius = 4
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == mobileTextOutlet
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
            
            let decimalString = components as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }
    
    //Tapping Outside the keyboard will close it:
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //Tapping "Return" will tab to next label then submit and hide keyboard:
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == countryTextOutlet {
            mobileTextOutlet.becomeFirstResponder()
            
        } else if textField == mobileTextOutlet {
            countryTextOutlet.resignFirstResponder()

        }
        
        return true
    }
    
    
}
