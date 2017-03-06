//
//  CaseViewController.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import CoreData


class CaseViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var caseList = [Case]()
    var groupName:String = "Cases"
    
    @IBOutlet var caseListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = groupName
    }
    
    override func viewDidAppear(animated: Bool) {
        for cell in caseListTable.visibleCells as! [CustomCaseTableViewCell] {
            cell.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return caseList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCaseTableViewCell
        cell.caseNameLabel.text = caseList[indexPath.row].caseTitle
        cell.resetButton.tag = indexPath.row
        return cell
    }
    
    @IBAction func resetClicked(sender: UIButton) {
        var catList = [Int]()
        for cat in caseList[sender.tag].categories {
            if let cat = cat as? Category {
                if cat.type == "qa" {
                    catList.append(cat.id.integerValue)
                }
            }
        }
        if catList.count > 0 {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
            
            let fetchRequest = NSFetchRequest(entityName: "ChoiceRecord")
            let sortDescriptor = NSSortDescriptor(key: "categoryId", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "categoryId IN %@", catList)
            fetchRequest.predicate = predicate
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultController.delegate = self
            do{
                try fetchedResultController.performFetch()
            }
            catch{
                
            }
            for choice in fetchedResultController.fetchedObjects as! [ChoiceRecord]{
                managedObjectContext.deleteObject(choice)
            }
//            var error : NSError?
//            if(!managedObjectContext.save(&error) ) {
//                //println(error?.localizedDescription)
//            }

            
        }
        sender.setTitle("Done", forState: UIControlState.Normal)
        
    }
    

    @IBAction func clickHelp(sender: UIButton) {
        let alert = UIAlertController(title: "Help", message: "Click Reset button to reset all answer choices", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "enterCase" {
            if let categoryRevealViewController:CategoryRevealViewController = segue.destinationViewController as? CategoryRevealViewController{
                if let sender = sender as? UITableViewCell {
                    let clickedCase = caseList[caseListTable.indexPathForCell(sender)!.row]
                    if let categoryList = clickedCase.categories.allObjects as? [Category]{
                        categoryRevealViewController.caseName = clickedCase.caseTitle!
                        categoryRevealViewController.categoryList = categoryList.sort({$0.order.integerValue < $1.order.integerValue})
                    }

                }
            }
        }
    }




}
