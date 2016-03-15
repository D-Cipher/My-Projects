//
//  EditProfileAge.swift
//  Hello World
//
//  Created by Tingbo Chen on 3/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class EditProfileAge: UIViewController, UITextViewDelegate {
    
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
        
        self.addMessageField.delegate = self
        
        addMessageField.text = ""
        customAgeLabel.hidden = true
        addMessageField.hidden = true
        
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

}
