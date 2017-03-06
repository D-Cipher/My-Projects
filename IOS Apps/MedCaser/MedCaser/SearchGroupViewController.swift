//
//  SearchGroupViewController.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

struct GroupItem{
    let name:String
    let id:Int
    
}

class SearchGroupViewController: UITableViewController, UISearchResultsUpdating {
    var tableData = [GroupItem]()
    var filteredTableData = [GroupItem]()
    var resultSearchController = UISearchController()
    let indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        let binding = GroupServiceService.GroupServiceSoap11Binding()
        let request = GroupServiceService_getGroupRequest()
        request.searchString = ""  //getting all groups
        let response:GroupServiceSoap11BindingResponse = binding.getGroupUsingGetGroupRequest(request)
        var responseBodyParts = response.bodyParts
        if responseBodyParts != nil{
            if let bodyPart = responseBodyParts[0] as? GroupServiceService_getGroupResponse {
                let responseGroupList = bodyPart.respondGroup
                for respondGroup in responseGroupList {
                    if let group = respondGroup as? GroupServiceService_respondGroup{
                        self.tableData.append(GroupItem(name:group.groupName, id: group.id_.integerValue))
                        //println(group.groupName)
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please Try Again Later", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                }))
                presentViewController(alert, animated: true, completion: nil)
            }
                
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please check internet connection!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // 3
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.row].name
            
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row].name
            
            return cell
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredTableData = self.tableData.filter({( group : GroupItem) -> Bool in
            
            let stringMatch = group.name.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
            
            return (stringMatch != nil)
            
        })
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        var selectedGroupItem : GroupItem
        
        if (self.resultSearchController.active)
        {
            selectedGroupItem = self.filteredTableData[indexPath.row]
        }
        else
        {
            selectedGroupItem = self.tableData[indexPath.row]
        }

        indicator.layer.cornerRadius = 5
        indicator.opaque = false
        indicator.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.color = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0)
        view.addSubview(self.indicator)
        self.indicator.startAnimating()
        
        let addGroupAlert = UIAlertController(title: "Confirmation", message: "Do you want to add " + selectedGroupItem.name + " to My Groups?", preferredStyle: UIAlertControllerStyle.Alert);
        
        addGroupAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.performSegueWithIdentifier("addGroup", sender: [selectedGroupItem.id, selectedGroupItem.name])

        }))
        
        addGroupAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            self.indicator.stopAnimating()
        }))

        if(self.resultSearchController.active){
            resultSearchController.active = false
        }
        
        presentViewController(addGroupAlert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.indicator.stopAnimating()
        if segue.identifier == "addGroup" {
            if let myGroupsViewController:MyGroupsViewController = segue.destinationViewController as? MyGroupsViewController{
                myGroupsViewController.newGroupItem = GroupItem(name: (sender as! [AnyObject])[1] as! String, id: (sender as! [AnyObject])[0] as! Int)
            }

        }
    }
    
}
