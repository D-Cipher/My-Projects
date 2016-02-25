//
//  EditProfileMultipleChoice.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class EditProfileMultipleChoice: UITableViewController {
    
    var multiChoiceOptions: [String] = ["test1","test2","test3","test4","test5"]
    
    var selectedChoiceIndex:Int?
    
    var selectedChoice:String? {
        didSet {
            if let choice = selectedChoice {
                selectedChoiceIndex = multiChoiceOptions.indexOf(choice)!
            }
        }
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return multiChoiceOptions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("multipleChoiceCell", forIndexPath: indexPath)

        cell.textLabel?.text = multiChoiceOptions[indexPath.row]
        
        if indexPath.row == selectedChoiceIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedChoiceIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedChoice = multiChoiceOptions[indexPath.row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveChoiceUnwind" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedChoice = multiChoiceOptions[index]
                }
            }
        }
    }
}
