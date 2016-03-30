//
//  DetailedFeedController.swift
//  Seed Share
//
//  Created by Tingbo Chen on 6/18/15.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class DetailedFeedController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate {

    var imageToDisplay: UIImage?
    
    var cellContent: [AnyObject] = []
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    @IBOutlet var postButtonOutlet: UIButton!
    
    @IBOutlet var commentTableView: UITableView!
    
    @IBOutlet var addMessageField: UITextView!
    
    @IBOutlet var detailedImageOutlet: UIImageView!

    @IBAction func dismissDetailedView(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            //FeedViewController().viewDidLoad()
            //print("test")
        })
        
    }
    
    @IBAction func commentPost(sender: AnyObject) {
        if self.addMessageField.text != "" && self.addMessageField.text != "Add comment" {
            
            let commentMsg = "@" + (self.userProfileData["name"] as? String)! + ": " + self.addMessageField.text
            
            if self.cellContent.count > 0 {
                self.cellContent.insert(commentMsg, atIndex: 0)
            } else {
                self.cellContent.append(commentMsg)
            }
            
            self.addMessageField.text = ""
            self.textBoxSpecs(0)
            
            self.commentTableView.reloadData()
            
            self.view.endEditing(true)
            
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
            self.addMessageField.text = "Add comment"
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
            
        }
        
        //Swipe Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //Messsage Setup
        self.addMessageField.text = ""
        
        self.textBoxSpecs(0)
        
        self.addMessageField.delegate = self
        
        if let image = imageToDisplay {
            detailedImageOutlet.image = image
        }
        
        self.commentTableView.reloadData()
        
        
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                //print("Swiped Right")
                
                dismissViewControllerAnimated(true, completion: { () -> Void in
                    //FeedViewController().viewDidLoad()
                    //print("test")
                })
                
            default:
                break
                
            }
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Defines the contents of each individual cell
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath)
        
        cell.textLabel!.font = UIFont(name:"Avenir", size:14)
        
        cell.textLabel?.text = cellContent[indexPath.row] as? String
        
        return cell
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
