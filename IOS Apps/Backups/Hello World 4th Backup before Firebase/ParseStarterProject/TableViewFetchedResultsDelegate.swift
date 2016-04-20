//
//  TableViewFetchedResultsDelegate.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreData

/*/====Extension====//
 Name: TableView Fetched Results Delegate
 File: TableViewFetchedResultsDelegate.swift
 Used in: ChatTabController, ContactsViewController
 
 ===Description===
 Class delegate that configures the 
 NSFetchedResultsControllerDelegate to
 control a cells and sections in a TableView.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

/*/===How to Use===//
 To setup the FetchedResultsDelegate with the TableViewFetchedResultsDelegate,
 instead of setting "fetchedResultsController?.delegate = self", add:
 
 1) Conform the controller to the TableViewFetchedResultsDisplayer.
 Example:
 """
 class ChatTabController: UIViewController, TableViewFetchedResultsDisplayer {
 """
 
 2) Add a function "configureCell" to conform to the delegate protocol.
 """
 func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
 """
 
 3) A new fetchedResultsDelegate variable
 """
 private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
 """
 
 4) Set the fetchedResultsDelegate variable to the extension and set
 the fetchedResultsController?.delegate to the fetchedResultsDelegate variable.
 """
 fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
 fetchedResultsController?.delegate = fetchedResultsDelegate
 """"
*/

class TableViewFetchedResultsDelegate: NSObject, NSFetchedResultsControllerDelegate {
    
    private var tableView: UITableView!
    private var displayer: TableViewFetchedResultsDisplayer!
    
    init (tableView: UITableView, displayer: TableViewFetchedResultsDisplayer) {
        self.tableView = tableView
        self.displayer = displayer
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert: tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete: tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
            
        case .Insert: tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            displayer.configureCell(cell!, atIndexPath: indexPath!)
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}
