//
//  FeedViewController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 6/9/15.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController {
    
    @IBOutlet var tableViewOutlet: UITableView!

    let viewTransitionDelegate = TransitionDelegate()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refresher: UIRefreshControl!
    
    var user_ls: [AnyObject] = []
    
    var userID_dict = [String:String]()
    
    var date_ls: [AnyObject] = []
    
    var message_ls: [AnyObject] = []
    
    var image_ls: [PFFile] = []
    
    var uiImage_ls: [UIImage] = []
    
    var selectedPath = 0
    
    func activityIndFunc(status: Int = 0) {
        
        if status == 1 {
            //Show Activity Indicator
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        } else if status == 0 {
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        
    }
    
    func createUserDict() {
        
        let query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        
                        self.userID_dict[user.objectId!] = user.username!
                    }
                }
                
                
            }
        })
        
    }
    
    func extractFeed(){
        
        user_ls = []
        userID_dict = [String:String]()
        date_ls = []
        message_ls = []
        image_ls = []
        uiImage_ls = []
        
        //creates dictionary of users
        self.createUserDict()
        
        //Extract Followers from Parse
        let getFollowedUsersQuery = PFQuery(className: "follower_class")
        
        self.activityIndFunc(1)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
            
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if let objects = objects {
                    
                    for object in objects {
                        let followedUser = object["following"] as! String
                        
                        //Download all images from the user:
                        let query = PFQuery(className: "Posts")
                        
                        query.whereKey("userID", equalTo: followedUser)
                        
                        query.orderByDescending("updatedAt")
                        
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                            if let objects = objects {
                                for object in objects {
                                    
                                    self.date_ls.append(object["date"] as! String)
                                    self.message_ls.append(object["message"] as! String)
                                    self.user_ls.append(self.userID_dict[object["userID"] as! String]!)
                                    self.image_ls.append(object["imageFile"] as! PFFile)
                                    
                                }
                                
                                self.tableViewOutlet.reloadData()
                                self.refresher.endRefreshing()
                                
                                self.activityIndFunc(0)
                                
                                //print(self.user_ls)
                                //print(self.date_ls)
                                //print(self.NSDate_ls)
                                //print(self.image_ls)
                                //print(self.uiImage_ls)
                                
                            } else {
                                print(error)
                                self.refresher.endRefreshing()
                                self.activityIndFunc(0)
                            }
                            
                        })
                        
                    }
                    
                }
            }
        }
        
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Make rowHeight Adjust to screen size
        if tableViewOutlet != nil {
            tableViewOutlet.rowHeight = UITableViewAutomaticDimension
            tableViewOutlet.estimatedRowHeight = 224
            
            //Pull to refresh
            refresher = UIRefreshControl()
            refresher.attributedTitle = NSAttributedString(string: "Refresh")
            refresher.addTarget(self, action: "extractFeed", forControlEvents: UIControlEvents.ValueChanged)
            self.tableViewOutlet.addSubview(refresher)
            
            self.extractFeed()
        
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return date_ls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Get cell content from Cell.swift
        let standard_cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        if image_ls.count > 0 {
            
            for (index, _) in image_ls.enumerate() {
                self.uiImage_ls.append(UIImage())
            }
            
            image_ls[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    standard_cell.postedImage.image = downloadedImage
                    
                    self.uiImage_ls[indexPath.row] = downloadedImage
                    
                }
                
            }
            
            //standard_cell.postedImage.image = UIImage(named: "placeholder-camera-green.png") //For testing
            
            //standard_cell.postedImage.image = uiImage_ls[indexPath.row] as UIImage
            
            standard_cell.headerOutlet.text = (date_ls[indexPath.row] as? String)!
            
            standard_cell.subheaderOutlet.text = (user_ls[indexPath.row] as? String)!
            
            standard_cell.messageOutlet.text = message_ls[indexPath.row] as? String
            
            standard_cell.messageOutlet.sizeToFit()
        }
        
        return standard_cell
    }
    
    
    //Track User's selected row
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        //let current_cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        //self.currentImage = current_cell.postedImage.image!
        
        
        //currentImage = user_ls[indexPath.row]
        
        self.tableViewOutlet.cellForRowAtIndexPath(indexPath)
        
        //print(current_cell.headerOutlet.text)
        
        self.selectedPath = indexPath.row
        
        return indexPath
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //self.activityIndFunc(1)
        //overlay = UIView(frame: view.frame)
        //overlay!.backgroundColor = UIColor.blackColor()
        //overlay!.alpha = 0.8
            
        //view.addSubview(overlay!)
        
        
        let destinationViewController = segue.destinationViewController as! DetailedFeedController
        destinationViewController.imageToDisplay = self.uiImage_ls[(self.tableViewOutlet.indexPathForSelectedRow?.row)!]
        destinationViewController.transitioningDelegate = viewTransitionDelegate
        destinationViewController.modalPresentationStyle = .Custom
 
        
        //if segue.identifier == "feedCellSegue" {
            

        //}
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
