//
//  PublicProfileController.swift
//  Hello World
//
//  Created by Tingbo Chen on 3/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PublicProfileController: UIViewController, UIScrollViewDelegate {

    var pictureScroll: UIScrollView!
    
    var pageControl: UIPageControl!
    
    var secondaryScroll: UIScrollView!
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var image_order: [String] = []
    
    var currentImg_str: String = "image_0"
    
    var pageImages_str: [String] = []
    
    var pageImages: [UIImage] = []
    
    var pageViews: [UIImageView?] = []
    
    var navBar_adjust = Float()
    
    func flexibleLabelHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func magnifierButton(sender:UIButton!) {
        //print("Button tapped")
        
        self.performSegueWithIdentifier("UserMagnifierSegue", sender: self.currentImg_str)
        
    }
    
    func barButtonItem(sender:UIButton!) {
        //print("Button tapped")
        
        ///dismissViewControllerAnimated(false, completion: nil)
        self.performSegueWithIdentifier("GearSegue", sender: self)
        
    }
    
    func initiateBarButtonItem(){
        let btnName = UIButton()
        
        let origImage = UIImage(named: "Settings30x30.png")
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        btnName.setImage(tintedImage, forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: "barButtonItem:", forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController!.navigationBar.translucent = true
        //self.navigationController!.navigationBar.barTintColor = UIColor.redColor() // for testing
        
        //Load Perm Storage Data
        if NSUserDefaults().objectForKey("userProfileImages") == nil {
            
            self.userProfileImages = ["image_0":NSData(),"image_1":NSData(),"image_2":NSData(),"image_3":NSData(),"image_4":NSData()]
            
            self.userProfileImages["image_0"] = nil
            self.userProfileImages["image_1"] = nil
            self.userProfileImages["image_2"] = nil
            self.userProfileImages["image_3"] = nil
            self.userProfileImages["image_4"] = nil
            
            NSUserDefaults.standardUserDefaults().setObject(self.userProfileImages, forKey: "userProfileImages")
            
        } else if NSUserDefaults().objectForKey("userProfileImages") != nil {
            
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
        }
        
        //Set up pageImages
        var image_str: [String] = ["image_0"]
        
        self.image_order = self.userProfileImages["image_order"] as! Array
        
        for image_n in self.image_order {
            image_str.append(image_n)
        }
        
        for img_name in image_str {
            
            if (self.userProfileImages[img_name] != nil) {
                
                self.pageImages.append(UIImage(data: (self.userProfileImages[img_name] as? NSData)!)!)
                self.pageImages_str.append(img_name)
            }
            
        }
        
        self.setUpScrollView()
        
        self.initiateImageScroll()
        
        self.initiateBarButtonItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpScrollView() {
        
        self.navBar_adjust = Float(self.navigationController!.navigationBar.frame.size.height) + Float(self.navigationController!.navigationBar.frame.size.height)/2.2
        
        //====Set up Picture Scroll View
        
        let picScr_x = CGFloat(0)
        let picScr_y = CGFloat(0)
        let picScr_w = self.view.frame.size.width
        let picScr_h = self.view.frame.size.width
        
        pictureScroll = UIScrollView(frame: CGRectMake(picScr_x, picScr_y,picScr_w,picScr_h))
        
        pictureScroll.bounds = pictureScroll.frame
        
        pictureScroll.backgroundColor = UIColor.whiteColor()
        
        pictureScroll.pagingEnabled = true
        
        view.addSubview(pictureScroll)
        pictureScroll.delegate = self //Set scroll view delegate to view delegate
        
        //====Adds Page Control to subview
        let pgCont_x = self.pictureScroll.frame.size.width * 0.25
        let pgCont_y = self.pictureScroll.frame.size.height - self.pictureScroll.frame.size.height*0.1
        let pgCont_w = self.pictureScroll.frame.size.width * 0.5
        let pgCont_h = CGFloat(37)
        
        self.pageControl = UIPageControl(frame: CGRectMake(pgCont_x,pgCont_y,pgCont_w,pgCont_h))
        
        /*
        //Not working...
        let salmon_color = UIColor(red: 255.0, green: 102.0, blue: 102.0, alpha: 1.0)
        let spring_color = UIColor(red: 102.0, green: 255.0, blue: 204.0, alpha: 1.0)
        
        self.pageControl.tintColor = UIColor.blackColor()
        self.pageControl.currentPageIndicatorTintColor = salmon_color
        */
        
        if pageImages_str.count > 1 {
            view.addSubview(pageControl)
        }
        
        //====Adds Magnifier Button
        let magBtn_x = picScr_w - picScr_w * 0.1
        let magBtn_y = picScr_h - (picScr_h * 0.08)
        let magBtn_w = CGFloat(20)
        let magBtn_h = CGFloat(20)
        
        let origImage = UIImage(named: "Magnifier30x30.png")
        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let magButton = UIButton(frame: CGRectMake(magBtn_x, magBtn_y, magBtn_w, magBtn_h))
        magButton.setImage(tintedImage, forState: .Normal)
        magButton.tintColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        magButton.addTarget(self, action: "magnifierButton:", forControlEvents: .TouchUpInside)
        
        view.addSubview(magButton)
        
        
        //print(self.pictureScroll.frame.height)
        //print(CGFloat(self.navBar_adjust) + self.pictureScroll.frame.height)
        
        //====Adds Secondary Scroll view
        let secScr_x = CGFloat(0)
        let secScr_y = self.pictureScroll.frame.height
        let secScr_w = self.view.frame.size.width
        let secScr_h = self.view.frame.size.height - CGFloat(self.navBar_adjust) - self.pictureScroll.frame.height
        
        secondaryScroll = UIScrollView(frame: CGRectMake(secScr_x,secScr_y,secScr_w,secScr_h))
        
        secondaryScroll.bounds = secondaryScroll.frame
        
        //secondaryScroll.autoresizingMask = [.None, .FlexibleHeight]
        
        secondaryScroll.backgroundColor = UIColor.whiteColor()
        
        //secondaryScroll.layer.borderColor = UIColor.redColor().CGColor //for testing
        //secondaryScroll.layer.borderWidth = 3.0 //for testing
        
        //====Adds Name Label
        let font_ratio = self.view.frame.size.width / 375.0
        let col_tungsten = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        let col_steel = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        
        let nmLab_x = CGFloat(0) + self.view.frame.size.width * 0.05
        let nmLab_y = CGFloat(0)
        let nmLab_w = self.view.frame.size.width - self.view.frame.size.width * 0.1
        let nmLab_h = (self.view.frame.size.height - CGFloat(self.navBar_adjust) - self.pictureScroll.frame.height) * 0.25
        
        let nameLabel = UILabel(frame: CGRectMake(nmLab_x, nmLab_y, nmLab_w, nmLab_h))
        //nameLabel.layer.borderColor = UIColor.blackColor().CGColor //for testing
        //nameLabel.layer.borderWidth = 1.0 //for testing
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "HelveticaNeue", size: 27 * font_ratio)
        nameLabel.textColor = col_tungsten
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = "Alison"
        secondaryScroll.addSubview(nameLabel)
        
        //====Adds Sub-description label
        let subDesc_x = nmLab_x
        let subDesc_y = nmLab_y + nmLab_h * 0.75
        let subDesc_w = nmLab_w
        let subDesc_h = secScr_h * 0.10
        
        let subDescription = UILabel(frame: CGRectMake(subDesc_x, subDesc_y, subDesc_w, subDesc_h))
        //subDescription.layer.borderColor = UIColor.blackColor().CGColor //for testing
        //subDescription.layer.borderWidth = 1.0 //for testing
        subDescription.numberOfLines = 1
        subDescription.font = UIFont(name: "HelveticaNeue", size: 13 * font_ratio)
        subDescription.textColor = col_steel
        subDescription.adjustsFontSizeToFitWidth = true
        subDescription.textAlignment = NSTextAlignment.Center
        subDescription.text = "7 miles away, 55 mutual friends"
        secondaryScroll.addSubview(subDescription)
        
        //====Adds Hello World label
        let helwo_x = subDesc_x
        let helwo_y = subDesc_y + subDesc_h
        let helwo_w = subDesc_w
        let helwo_h = secScr_h * 0.22
        
        let helwoLabel = UILabel(frame: CGRectMake(helwo_x, helwo_y, helwo_w, helwo_h))
        //helwoLabel.layer.borderColor = UIColor.blackColor().CGColor //for testing
        //helwoLabel.layer.borderWidth = 1.0 //for testing
        helwoLabel.numberOfLines = 1
        helwoLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16 * font_ratio)
        helwoLabel.textColor = col_tungsten
        helwoLabel.adjustsFontSizeToFitWidth = true
        helwoLabel.textAlignment = NSTextAlignment.Left
        helwoLabel.text = "Hello World,"
        secondaryScroll.addSubview(helwoLabel)
        
        //====Adds About Message label
        let fontInput = UIFont(name: "HelveticaNeue", size: 16 * font_ratio)
        let textInput = "Our relationship should be like like Nintendo 64--classic, fun to spend hours with, and innocent, non-suggestive, platonic, childhood fun. No blowing or shoving anything."
        
        let about_x = helwo_x
        let about_y = helwo_y + helwo_h * 0.75
        let about_w = helwo_w
        let about_h = flexibleLabelHeight(textInput, font: fontInput!, width: about_w)
        
        let aboutMess = UILabel(frame: CGRectMake(about_x, about_y, about_w, about_h))
        //aboutMess.layer.borderColor = UIColor.blackColor().CGColor //for testing
        //aboutMess.layer.borderWidth = 1.0 //for testing
        aboutMess.numberOfLines = 0
        aboutMess.font = fontInput
        aboutMess.textColor = col_steel
        
        aboutMess.lineBreakMode = NSLineBreakMode.ByWordWrapping
        aboutMess.textAlignment = NSTextAlignment.Left
        aboutMess.text = textInput
        aboutMess.sizeToFit()
        
        secondaryScroll.addSubview(aboutMess)
        
        //====Adds Bottom Padding
        let botpad_x = about_x
        let botpad_y = about_y + about_h
        let botpad_w = about_w
        let botpad_h = helwo_h * 0.4
        
        let bottomPadding = UILabel(frame: CGRectMake(botpad_x, botpad_y, botpad_w, botpad_h))
        //bottomPadding.layer.borderColor = UIColor.blackColor().CGColor //for testing
        //bottomPadding.layer.borderWidth = 1.0 //for testing
        secondaryScroll.addSubview(bottomPadding)
        
        //print(nmLab_h + subDesc_h + helwo_h + about_h)
        
        //Adds secondary scroll content to view
        secondaryScroll.contentSize = CGSizeMake(0, nmLab_h + subDesc_h + helwo_h + about_h + botpad_h)
        view.addSubview(secondaryScroll)
        secondaryScroll.delegate = self
        
    }
    
    func initiateImageScroll() {
        
        let pageCount = self.pageImages.count
        self.pageControl.numberOfPages = pageCount
        
        //Appends to Page Views Number of Pages
        for i in 0..<pageCount {
            self.pageViews.append(nil)
        }
        
        let pagesScrollViewSize = pictureScroll.frame.size
        
        pictureScroll.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: 0)
        
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        //print(pictureScroll.bounds)
        //print(pictureScroll.frame)
        
        if let pageView = pageViews[page]{
            
        } else {
            
            var boundsVar = pictureScroll.bounds
            
            boundsVar.origin.x = boundsVar.size.width * CGFloat(page)
            //boundsVar.origin.y = 64
            
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleToFill
            newPageView.frame = boundsVar
            
            pictureScroll.addSubview(newPageView)
            
            pageViews[page] = newPageView
            
        }
        
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            return
        }
        
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        
        let pageWidth = pictureScroll.frame.size.width
        let page = Int(floor((pictureScroll.contentOffset.x*2.0 + pageWidth) / (pageWidth*2.0)))
        
        //Lock y-Bounds:
        pictureScroll.bounds.origin.y = CGFloat(self.navBar_adjust)
        
        pageControl.currentPage = page
        
        self.currentImg_str = self.pageImages_str[page]
        //print(self.currentImg_str)
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        for index in 0.stride(to: firstPage, by: 1) {
            //converted from C-style loop: "for var index = 0; index < firstPage; index += 1 {"
            purgePage(index)
        }
        
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        for index in (lastPage + 1).stride(to: pageImages.count, by: -1) {
            //converted from C-style loop: "for var index = lastPage + 1; index < pageImages.count; index += 1 {"
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        self.loadVisiblePages()
    }
    
    /*
    //Segue From EditProfileUploadImage
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getPermStorage()
        
        self.pageImages[pageControl.currentPage] = UIImage(data: (self.userProfileImages[self.currentImg_str] as? NSData)!)!
        
        self.setUpScrollView()
        
        self.initiateImageScroll()
        
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print("test")
        
        if segue.identifier == "UserMagnifierSegue" {
            if let EditProfileUploadImage = segue.destinationViewController as? EditProfileUploadImage {
                EditProfileUploadImage.fromSegue = segue.identifier!
                EditProfileUploadImage.currentImage_str = (sender as? String)!
                
            }
            
        }
        
        
    }
}
