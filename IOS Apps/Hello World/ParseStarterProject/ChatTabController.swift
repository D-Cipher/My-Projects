//
//  ChatTabController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import Foundation
import CoreData

class ChatTabController: UIViewController {
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user Profile Preferences from Parse
        //if user exists in parse then save userprofiledata to perm data
        //if perm data is not empty then
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MsgSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let msgVC = nav.topViewController as! MessageViewController
            msgVC.context = context
        }
        
        
    }
    

}
