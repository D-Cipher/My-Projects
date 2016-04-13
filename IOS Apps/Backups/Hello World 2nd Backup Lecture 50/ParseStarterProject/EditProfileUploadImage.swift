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
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var fromSegue: String = ""
    
    var currentImage_str: String = ""
    
    var imageView: UIImageView!
    
    var scrollView: UIScrollView!
    
    var navBar_adjust = Float()
    
    var deleteButton_var = UIBarButtonItem!()
    
    var changeButton_var = UIBarButtonItem!()
    
    var addChangeBtn_status = "Change "
    
    func saveNewImage() {
        
        if imageView.image != nil && self.imageView.image != UIImage(named: "placeholder-camera-green.png") {
            
            //Turn ON Spinner
            self.activityIndFunc(1, warningMsg: "Saving...")
            
            if let imageData = UIImagePNGRepresentation(self.imageView.image!){
                self.userProfileImages[currentImage_str] = imageData
                NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
                print("saved New Image")
            }
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                //Upload Image To Parse
                let query = PFQuery(className: "_User")
                
                let imageData = UIImagePNGRepresentation(self.imageView.image!)
                
                let imageFile = PFFile(name: "image.png", data: imageData!)
                
                query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!, block: { (object, error) -> Void in
                    if error != nil {
                        print(error)
                        
                        self.activityIndFunc(0) //Turn OFF Spinner (Failed)
                        
                    } else if let object = object {
                        //Save and Update Parse data
                        
                        PFUser.currentUser()?[self.currentImage_str] = imageFile
                        
                        PFUser.currentUser()?.save()
                        
                        self.activityIndFunc(0) //Turn OFF Spinner (Success)
                        
                        
                    }
                })
            })
            
        } else if self.imageView.image == UIImage(named: "placeholder-camera-green.png") {
            
            self.userProfileImages[currentImage_str] = nil
            
            NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
            
            //print("deleted")
            
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
                        
                    }
                })
            })
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        //print("image selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.imageView.image = image
        
        self.saveNewImage()
        
        self.changeButton_var.title = "Change "
    }
    
    //Toolbar and buttons
    func initiateToolbar(sender: Int = 1) {
        
        self.navBar_adjust = Float(self.navigationController!.navigationBar.frame.size.height) + Float(self.navigationController!.navigationBar.frame.size.height)/2.2
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44.0 - CGFloat(self.navBar_adjust), self.view.frame.size.width, 44.0)
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = true
        
        self.deleteButton_var = UIBarButtonItem(title: " Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteButton")
        self.changeButton_var = UIBarButtonItem(title: self.addChangeBtn_status, style: UIBarButtonItemStyle.Plain, target: self, action: "changeButton")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([deleteButton_var, flexibleSpace, changeButton_var], animated: false)
        toolbar.userInteractionEnabled = true
        toolbar.backgroundColor = UIColor.blackColor()
        toolbar.barTintColor = UIColor.blackColor()
        
        
        if sender == 0 {
            self.deleteButton_var.enabled = false
            self.view.addSubview(toolbar)
        
        } else if sender == 1 {
            self.deleteButton_var.enabled = true
            self.view.addSubview(toolbar)
        
        } else if sender == 2 {
            
        }
    }
    
    func deleteButton(){
        //print("test")
        if self.changeButton_var.title != "Add " {
            let alertMsg = ["Caution", "You are about to delete this picture."]
            
            let alert = UIAlertController(title: alertMsg[0], message: alertMsg[1], preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                print("OK")
                
                self.imageView.image = UIImage(named: "placeholder-camera-green.png")
                self.saveNewImage()
                
                self.changeButton_var.title = "Add "
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    func changeButton(){
        //print("test")
        
        //Pick Image from Phone --- Later replace with from FB
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            
            if self.userProfileImages[currentImage_str] != nil{
                self.imageView = UIImageView(image: UIImage(data: (self.userProfileImages[currentImage_str] as? NSData)!))
                
                self.addChangeBtn_status = "Change "
                
            } else {
                self.imageView = UIImageView(image: UIImage(named: "placeholder-camera-green"))
                
                self.addChangeBtn_status = "Add "
                
            }
            
        }
        
        
        self.setUpScrollView()
        
        self.recenterImage()
        
        if fromSegue == "UploadImageSegue" {
            if currentImage_str == "image_0" {
                self.initiateToolbar(0)
            } else {
                self.initiateToolbar(1)
            }
        } else if fromSegue == "UserMagnifierSegue" {
            self.initiateToolbar(2)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setZoomScaleFor(scrollView.bounds.size)
        
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        
        recenterImage()
    }
    
    // MARK: - Set up scroll view
    
    private func setUpScrollView() {
        
        self.navBar_adjust = Float(self.navigationController!.navigationBar.frame.size.height) + Float(self.navigationController!.navigationBar.frame.size.height)/2.2
        
        scrollView = UIScrollView(frame: CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y - CGFloat(self.navBar_adjust) + 34, width: view.bounds.width, height: view.bounds.height))
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        
        setZoomScaleFor(scrollView.bounds.size)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    private func setZoomScaleFor(scrollViewSize: CGSize) {
        let imageSize = imageView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minimumScale = min(widthScale, heightScale)
        
        // set up zooming properties for the scroll view
        scrollView.minimumZoomScale = minimumScale
        scrollView.maximumZoomScale = 3.0
    }
    
    private func recenterImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
    
}

extension EditProfileUploadImage : UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    /*
    func scrollViewDidZoom(scrollView: UIScrollView) {
    self.recenterImage()
    }
    */

}
