//
//  EditProfileUploadImage.swift
//  MM
//
//  Created by Tingbo Chen on 2/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class EditProfileUploadImage: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var currentImage_str: String = ""

    @IBOutlet var imageOutlet: UIImageView!
    
    @IBOutlet var deleteButtonOutlet: UIBarButtonItem!
    
    @IBAction func deleteButton(sender: AnyObject) {
        self.imageOutlet.image = UIImage(named: "placeholder-camera-green.png")
        self.saveNewImage()
        
    }
    
    
    @IBAction func chooseImageButton(sender: AnyObject) {
        
        //Pick Image from Phone --- Later replace with from FB
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
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
    
    func saveNewImage() {
        if imageOutlet.image != nil && self.imageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            //Turn on Spinner
            //self.activityIndFunc(1)
            
            if let imageData = UIImagePNGRepresentation(self.imageOutlet.image!){
                self.userProfileImages[currentImage_str] = imageData
                NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
                print("saved New Image")
            }
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                //Upload Image To Parse
                let query = PFQuery(className: "_User")
                
                let imageData = UIImagePNGRepresentation(self.imageOutlet.image!)
                
                let imageFile = PFFile(name: "image.png", data: imageData!)
                
                query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                    if error != nil {
                        print(error)
                    } else if let object = object {
                        //Save and Update Parse data
                        
                        PFUser.currentUser()?[self.currentImage_str] = imageFile
                        
                        PFUser.currentUser()?.save()
                        
                        //Turn off Spinner
                        //self.activityIndFunc(0)
                        
                    }
                })
            })
            
        } else if self.imageOutlet.image == UIImage(named: "placeholder-camera-green.png") {
            
            self.userProfileImages[currentImage_str] = nil
            
            NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
            
            print("deleted")
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                //Upload Image To Parse
                let query = PFQuery(className: "_User")
                
                query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                    if error != nil {
                        print(error)
                    } else if let object = object {
                        //Save and Update Parse data
                        
                        PFUser.currentUser()?.removeObjectForKey(self.currentImage_str)
                        
                        //PFUser.currentUser()?[self.currentImage_str]?.removeObject(anObject: AnyObject)
                        
                        PFUser.currentUser()?.save()
                        
                        //Turn off Spinner
                        //self.activityIndFunc(0)
                        
                    }
                })
            })
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //print("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.imageOutlet.image = image
        
        self.saveNewImage()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentImage_str == "image_0" {
            self.deleteButtonOutlet.enabled = false
        } else {
            self.deleteButtonOutlet.enabled = true
        }
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            if self.userProfileImages[currentImage_str] != nil{
                self.imageOutlet.image = UIImage(data: (self.userProfileImages[currentImage_str] as? NSData)!)
            } else {
                self.imageOutlet.image = UIImage(named: "placeholder-camera-green.png")
            }
            
        }

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            
        }
    }

}
