//
//  FollowingViewController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FollowingViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableOutlet: UITableView!
    
    var user_ls: [AnyObject] = []
    var userID_ls: [AnyObject] = []
    var isFollowing = [String:Bool]()
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        self.user_ls = []
        self.userID_ls = []
        
        //Retrieve Data on all users
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        
                        //exclude current user from list
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.user_ls.append(user.username!)
                            self.userID_ls.append(user.objectId!)
                            
                            //Check to see which user are followed
                            let query = PFQuery(className: "follower_class")
                            
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error ) -> Void in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                //print(self.isFollowing)
                                
                                //Reload data
                                if self.isFollowing.count == self.user_ls.count{
                                    self.tableOutlet.reloadData()
                                    
                                    //End Pull to refresh
                                    self.refresher.endRefreshing()
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                }
            }
            //print(self.user_ls)
            //print(self.userID_ls)
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableOutlet.addSubview(refresher)
        
        self.refresh()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return an Integer which will be the number of rows in the section of the table
        
        return user_ls.count //Gives number rows in our table equal to count of cellContent
    }
    
    /*
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let rowCounter = indexPath.row
    
        print(rowCounter)
        
        return indexPath
    }
    */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Defines the contents of each individual cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = user_ls[indexPath.row] as? String
        
        if isFollowing[userID_ls[indexPath.row] as! String]! == true {
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowCounter = indexPath.row
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        
        //check if is already following
        if isFollowing[userID_ls[rowCounter] as! String]! == false {
            
            isFollowing[userID_ls[rowCounter] as! String]! = true
            
            //Adds a checkmark to selected cell
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            //Set up Following Class in parse
            let follower_class = PFObject(className: "follower_class")
            follower_class["following"] = userID_ls[rowCounter]
            follower_class["follower"] = PFUser.currentUser()?.objectId
            
            follower_class.saveInBackground()
            
        } else {
            //if is already following then unfollow
            isFollowing[userID_ls[rowCounter] as! String]! = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //Remove from parse
            let query = PFQuery(className: "follower_class")
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
            query.whereKey("following", equalTo: userID_ls[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error ) -> Void in
                
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            })
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
