//
//  FeedViewController.swift
//  Chefio
//
//  Created by Tingbo Chen on 5/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController {
    
    //let viewTransitionDelegate = TransitionDelegate()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refresher: UIRefreshControl!
    
    var user_ls: [AnyObject] = []
    
    var date_ls: [AnyObject] = []
    
    var title_ls: [AnyObject] = []
    
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
    
    func extractFeed(){
        
        user_ls = []
        date_ls = []
        title_ls = []
        image_ls = []
        uiImage_ls = []
        
        //Extract Followers from Parse
        //let getFollowedUsersQuery = PFQuery(className: "follower_class")
        
        self.activityIndFunc(1)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { () -> Void in
                        
            //Download all images from the user:
            let query = PFQuery(className: "Posts")
                        
            query.orderByDescending("updatedAt")
                        
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                if let objects = objects {
                    for object in objects {
                                    
                        self.date_ls.append(object["date"] as! String)
                        self.title_ls.append(object["title"] as! String)
                        self.user_ls.append(object["name"] as! String)
                        self.image_ls.append(object["imageFile"] as! PFFile)
                                    
                    }
                                
                        self.tableView.reloadData()
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make rowHeight Adjust to screen size
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 224
        
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.None //remove lines between cells
        
        //Pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refresh")
        refresher.addTarget(self, action: "extractFeed", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
            
        self.extractFeed()
        
    }
    
    @IBAction func unwindToFeedViewController(segue:UIStoryboardSegue) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return date_ls.count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let rowCounter = indexPath.row
        
        print(rowCounter)
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cellContent[indexPath.row] as? String
        
        return cell*/
        
        //Get cell content from Cell.swift
        let standard_cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Cell
        
        if date_ls.count > 0 {
            
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
            
            standard_cell.titleOutlet.text = title_ls[indexPath.row] as? String
            
            standard_cell.titleOutlet.sizeToFit()
        }
        
        return standard_cell
    }

}
