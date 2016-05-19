//
//  LocationAccMultipleChoice.swift
//  Parking Log
//
//  Created by Tingbo Chen on 5/16/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class LocationAccMultipleChoice: UITableViewController {
    
    var multiChoiceOptions: [String] = ["placeholder"]
    
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "locationAccUnwind" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedChoice = multiChoiceOptions[index]
                }
            }
        }
    }
}
