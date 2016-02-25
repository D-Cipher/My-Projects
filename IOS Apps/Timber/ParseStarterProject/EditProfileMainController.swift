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
    
    var multipleChoiceVar:String? = "Chess" {
        didSet {
            relationshipStatusDetail.text? = multipleChoiceVar!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init PlayerDetailsViewController")
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit PlayerDetailsViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Unwind Multiple Choice Segue
    @IBAction func unwindFromEditProfileMultipleChoice(segue:UIStoryboardSegue) {
        
        if let EditProfileMultipleChoice = segue.sourceViewController as? EditProfileMultipleChoice,
            selectedChoice = EditProfileMultipleChoice.selectedChoice {
                multipleChoiceVar = selectedChoice
        }
        
    }
}
