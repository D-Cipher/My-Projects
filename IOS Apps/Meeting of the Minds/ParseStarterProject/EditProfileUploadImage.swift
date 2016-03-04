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
    
    var imageView: UIImageView!
    
    var scrollView: UIScrollView! // scroll view
    
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
        
        if imageView.image != nil && self.imageView.image != UIImage(named: "placeholder-camera-green.png") {
            //Turn on Spinner
            //self.activityIndFunc(1)
            
            if let imageData = UIImagePNGRepresentation(self.imageView.image!){
                self.userProfileImages[currentImage_str] = imageData
                NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
                print("saved New Image")
            }
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                //Upload Image To Parse
                let query = PFQuery(className: "_User")
                
                let imageData = UIImagePNGRepresentation(self.imageView.image!)
                
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
            
        } else if self.imageView.image == UIImage(named: "placeholder-camera-green.png") {
            
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
        
        self.imageView.image = image
        
        self.saveNewImage()
    }
    
    func initiateImageScrollView() {
        setUpScrollView()
        
        scrollView.delegate = self
        
        setZoomScaleFor(scrollView.bounds.size)
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        recenterImage()
    }
    
    //Toolbar and buttons
    func initiateToolbar(sender: Int = 1) {
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = true
        
        let deleteButton_var = UIBarButtonItem(title: " Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteButton")
        let changeButton_var = UIBarButtonItem(title: "Change ", style: UIBarButtonItemStyle.Plain, target: self, action: "changeButton")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        if sender == 0 {
            deleteButton_var.enabled = false
        } else if sender == 1 {
            deleteButton_var.enabled = true
        }
        
        toolbar.setItems([deleteButton_var, flexibleSpace, changeButton_var], animated: false)
        toolbar.userInteractionEnabled = true
        toolbar.backgroundColor = UIColor.blackColor()
        toolbar.barTintColor = UIColor.blackColor()
        self.view.addSubview(toolbar)
    }
    
    func deleteButton(){
        print("test")
        
        self.imageView.image = UIImage(named: "placeholder-camera-green.png")
        self.saveNewImage()
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
                
            } else {
                self.imageView = UIImageView(image: UIImage(named: "placeholder-camera-green"))
            }
            
        }
        
        self.initiateImageScrollView()
        
        if currentImage_str == "image_0" {
            self.initiateToolbar(0)
        } else {
            self.initiateToolbar(1)
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
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
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
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2.0 : 0
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2.0 : 0
        
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
