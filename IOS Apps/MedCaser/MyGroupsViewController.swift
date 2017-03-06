//
//  MyGroupsViewController.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import CoreData

class MyGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    var newGroupItem: GroupItem? = nil
    
    @IBOutlet weak var myGroupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 133.0/255.0, blue: 40.0/255.0, alpha: 1)
        
        self.navigationController?.viewControllers = [self]
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
        }
        catch{
            
        }
        
        if newGroupItem != nil{
            saveNewItem(newGroupItem!.id, groupName: newGroupItem!.name, cases: [])
            newGroupItem = nil
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getGroupData:", forControlEvents: .ValueChanged)
        myGroupsTableView.addSubview(refreshControl)
    }
    
    func getGroupData(refreshControl: UIRefreshControl) {
        
        for myGroups:MyGroups in fetchedResultController.fetchedObjects as! [MyGroups]{

            getGroupDataSoapCall(myGroups)
        }
        
        
        refreshControl.endRefreshing()
    }
    
    func getGroupDataSoapCall(myGroups:MyGroups){
        //soap
        let request = GroupServiceService_getCaseByGroupIdRequest()
        request.groupId = myGroups.id
        let responseBodyParts = GroupServiceService.GroupServiceSoap11Binding().getCaseByGroupIdUsingGetCaseByGroupIdRequest(request).bodyParts
        if responseBodyParts != nil {
            if let bodyPart = responseBodyParts[0] as? GroupServiceService_getCaseByGroupIdResponse{
                
                //remove all cases for group first for now so no duplicate implement less expensive way in the future
                for theCase in myGroups.cases{
                    managedObjectContext.deleteObject(theCase as! NSManagedObject)
                }
                
                let respondCases = bodyPart.respondCase
                for respondCase in respondCases{
                    if let respondCase = respondCase as? GroupServiceService_respondCase{
                        //create coredata case
                        var tempCase = Case.createInManagedObjectContext(self.managedObjectContext, id: respondCase.id_, caseTitle: respondCase.caseName, group: myGroups, categories: [])
                        for respondCategory in respondCase.respondCategory{
                            if let respondCategory = respondCategory as? GroupServiceService_respondCategory{
                                //create coredata category
                                var tempCategory = Category.createInManagedObjectContext(self.managedObjectContext, id: respondCategory.id_, type: respondCategory.type
                                    , title: respondCategory.title, text: respondCategory.text, explanation: respondCategory.explanation
                                    , order: respondCategory.order, theCase: tempCase, answerChoices: [])
                                if respondCategory.type == "qa"{
                                    for respondAnswerChoice in respondCategory.respondAnswerChoices{
                                        if let respondAnswerChoice = respondAnswerChoice as? GroupServiceService_respondAnswerChoices{
                                            //create answerchoice
                                            if respondAnswerChoice.correctAnswer.boolValue {
                                                var tempAnswerChoice = AnswerChoice.createInManagedObjectContext(self.managedObjectContext, id: respondAnswerChoice.id_, choiceText: respondAnswerChoice.choicesText, correctAnswer: true, category: tempCategory)
                                            }
                                            else{
                                                var tempAnswerChoice = AnswerChoice.createInManagedObjectContext(self.managedObjectContext, id: respondAnswerChoice.id_, choiceText: respondAnswerChoice.choicesText, correctAnswer: false, category: tempCategory)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            save()
        }
        else {
            var alert = UIAlertController(title: "Error", message: "Please check internet connection!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: myGroupsFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func myGroupsFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "MyGroups")
        let sortDescriptor = NSSortDescriptor(key: "groupName", ascending: true, selector: "caseInsensitiveCompare:")
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = fetchedResultController.sections{
            return s[section].numberOfObjects
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyGroupsCell")
        let myGroups = fetchedResultController.objectAtIndexPath(indexPath) as? MyGroups
        cell!.textLabel?.text = myGroups?.groupName
        return cell!
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
     //  myGroupsTableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       _ = fetchedResultController.objectAtIndexPath(indexPath) as? MyGroups
        //println("\(myGroups?.id) \(myGroups?.groupName)")
        //println(myGroups?.cases.count)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            
            let managedObject:NSManagedObject = (fetchedResultController.objectAtIndexPath(indexPath) as? NSManagedObject)!
            managedObjectContext.deleteObject(managedObject)
            save()
            myGroupsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

        }
    }
    
    func saveNewItem(groupId: Int, groupName : String, cases:NSSet) {
        // Create the new  log item
        let groupIdArray:[NSNumber] = (fetchedResultController.fetchedObjects as! [MyGroups]).map({$0.id})
        if groupIdArray.indexOf(groupId) == nil{
            let newMyGroupsItem = MyGroups.createInManagedObjectContext(self.managedObjectContext, id: groupId, groupName: groupName, cases: [])
            save()
            let newItemIndexArray = fetchedResultController.fetchedObjects as! [MyGroups]
            if let newItemIndex = newItemIndexArray.indexOf(newMyGroupsItem){
                let newMyGroupsItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
                myGroupsTableView.insertRowsAtIndexPaths([ newMyGroupsItemIndexPath ], withRowAnimation: .Automatic)
            }
            getGroupDataSoapCall(newMyGroupsItem)
        }
        
    }
    
    @IBAction func clickHelp(sender: UIButton) {
        let alert = UIAlertController(title: "Help", message: "Swipe table down to refresh\nSwipe row left to delete", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func save() {
//        var error : NSError?
//        if(!managedObjectContext.save(&error) ) {
//            //println(error?.localizedDescription)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "getCases" {
            if let caseViewController:CaseViewController = segue.destinationViewController as? CaseViewController{
                if let sender = sender as? UITableViewCell {
                    if let clickedGroup = fetchedResultController.objectAtIndexPath(myGroupsTableView.indexPathForCell(sender)!) as? MyGroups{
                        if let caseList = clickedGroup.cases.allObjects as? [Case]{
                            caseViewController.caseList = caseList.sort({$0.caseTitle!.lowercaseString < $1.caseTitle!.lowercaseString})
                            caseViewController.groupName = clickedGroup.groupName
                        }
                        
                    }

                }
            }
            
        }
    }
    

}
