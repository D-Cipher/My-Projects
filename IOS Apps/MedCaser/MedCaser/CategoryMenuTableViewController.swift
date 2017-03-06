//
//  CategoryMenuTableViewController.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class CategoryMenuTableViewController: UITableViewController {

    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let categoryRevealViewController = self.revealViewController() as? CategoryRevealViewController{
            categoryList = categoryRevealViewController.categoryList
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.textAlignment = NSTextAlignment.Right
        cell.textLabel?.text = categoryList[indexPath.row].title
        if let frontController = self.revealViewController().frontViewController as? CategoryViewController{
            if frontController.currentCategory == indexPath.row {
                cell.backgroundColor = UIColor.grayColor()
            }
            else {
                cell.backgroundColor = UIColor.clearColor()
            }
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let frontController = self.revealViewController().frontViewController as? CategoryViewController{
                frontController.categoryUpdate(indexPath.row)
        }
        self.revealViewController().revealToggleAnimated(true)
    }


}
