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

    @IBOutlet var imageOutlet: UIImageView!
    
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //print("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageOutlet.image = image
        
        if imageOutlet.image != nil && self.imageOutlet.image != UIImage(named: "placeholder-camera-green.png") {
            //Turn on Spinner
            //self.activityIndFunc(1)
            
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
                        
                        PFUser.currentUser()?["image_0"] = imageFile
                        
                        PFUser.currentUser()?.save()
                        
                        //Turn off Spinner
                        //self.activityIndFunc(0)
                        
                    }
                })
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            self.imageOutlet.image = UIImage(data: (self.userProfileImages["image_0"] as? NSData)!)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
