//
//  FeedViewController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/9/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


class FeedViewController: UIViewController {
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    var user_ls: [AnyObject] = []
    
    var userID_dict = [String:String]()
    
    var date_ls: [AnyObject] = []
    
    var message_ls: [AnyObject] = []
    
    var image_ls: [PFFile] = []
    
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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates dictionary of users
        self.createUserDict()
        
        //Extract Followers from Parse
        let getFollowedUsersQuery = PFQuery(className: "follower_class")
        
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects {
                
                for object in objects {
                    let followedUser = object["following"] as! String
                    
                    //Download all images from the user:
                    let query = PFQuery(className: "Posts")
                    
                    query.whereKey("userID", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if let objects = objects {
                            for object in objects {
                                
                                self.date_ls.append(object["date"] as! String)
                                self.message_ls.append(object["message"] as! String)
                                self.image_ls.append(object["imageFile"] as! PFFile)
                                
                                self.user_ls.append(self.userID_dict[object["userID"] as! String]!)
                                
                                self.tableViewOutlet.reloadData()
                            }
                            
                            print(self.user_ls)
                            print(self.date_ls)
                        }
                        
                    })
                }
                
            }
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
        
        image_ls[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                standard_cell.postedImage.image = downloadedImage
            }
            
        }
        
        //standard_cell.postedImage.image = UIImage(named: "placeholder-camera-green.png") //For testing
        standard_cell.headerOutlet.text = (date_ls[indexPath.row] as? String)! + ": " + (user_ls[indexPath.row] as? String)!
        standard_cell.messageOutlet.text = message_ls[indexPath.row] as? String
        
        //standard_cell.textLabel?.text = cellContent[indexPath.row] as? String
        
        return standard_cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
