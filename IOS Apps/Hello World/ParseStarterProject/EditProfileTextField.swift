//
//  EditProfileTextField.swift
//  Hello World
//
//  Created by Tingbo Chen on 3/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class EditProfileTextField: UIViewController, UITextViewDelegate {
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    @IBOutlet var addMessageField: UITextView!
    
    func textBoxSpecs(status: Int = 0) {
        
        let boarderGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.3)
        let textGrey = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.4)
        self.addMessageField.textContainerInset =
            UIEdgeInsetsMake(5,2,2,2)
        self.addMessageField.layer.borderWidth = 2.0
        self.addMessageField.layer.borderColor = boarderGray.CGColor
        self.addMessageField.layer.cornerRadius = 5.0
        
        if status == 0 && self.addMessageField.text.isEmpty {
            self.addMessageField.text = "Add Message"
            self.addMessageField.textColor = textGrey
        } else if status == 1 && addMessageField.textColor == textGrey {
            self.addMessageField.text = nil
            self.addMessageField.textColor = UIColor.blackColor()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addMessageField.delegate = self
        self.textBoxSpecs(0)

        // Do any additional setup after loading the view.
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
