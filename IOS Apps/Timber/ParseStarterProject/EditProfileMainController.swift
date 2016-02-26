//
//  EditProfileMainController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class EditProfileMainController: UITableViewController {
    

    @IBOutlet var relationshipStatusDetail: UILabel!
    
    @IBOutlet var interestedInDetail: UILabel!
    
    var currentSelectedChoice:String? = "N/A"
    
    var relationshipStatusVar:String? = "N/A" {
        didSet {
            
            relationshipStatusDetail.text? = relationshipStatusVar!
        
        }
    }
    
    var interestedInVar:String? = "Women" {
        didSet {
            
            interestedInDetail.text? = interestedInVar!
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        //print("init PlayerDetailsViewController")
        super.init(coder: aDecoder)
    }
    
    deinit {
        //print("deinit PlayerDetailsViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            //print("relationship_status")
            
            currentSelectedChoice = relationshipStatusVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Single","In Relationship","N/A"])
            
        } else if indexPath.section == 2 && indexPath.row == 1 {
            //print("interested_in")
            
            currentSelectedChoice = interestedInVar
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["Men","Women","Both","N/A"])
        }
        
        return indexPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Unwind Multiple Choice Segue
    @IBAction func unwindFromEditProfileMultipleChoice(segue:UIStoryboardSegue) {
        
        if let EditProfileMultipleChoice = segue.sourceViewController as? EditProfileMultipleChoice,
            selectedChoice = EditProfileMultipleChoice.selectedChoice {
                
                if EditProfileMultipleChoice.headerTitle.title == "Relationship Status" {
                    relationshipStatusVar = selectedChoice
                } else if EditProfileMultipleChoice.headerTitle.title == "Interested In" {
                    interestedInVar = selectedChoice
                }
                
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MultipleChoiceSegue" {
            if let EditProfileMultipleChoice = segue.destinationViewController as? EditProfileMultipleChoice {
                EditProfileMultipleChoice.multiChoiceOptions = (sender as? [String])!
                EditProfileMultipleChoice.selectedChoice = currentSelectedChoice
                
            }

        }
    }

}
