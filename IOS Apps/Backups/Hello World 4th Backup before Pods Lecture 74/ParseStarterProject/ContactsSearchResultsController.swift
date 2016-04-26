//
//  ContactsSearchResultsController.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreData

/*/====Extension====//
 Name: Contacts Search Bar
 File: ContactsSearchResultsController.swift
 File Addon: ContactSelector.swift
 
 ===Description===
 Extension that adds a search bar to a table view of
 contacts, allows the user to search for the name 
 of a contact.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

/*/===How to Use===//
 To setup the Contacts Search Bar:
 
 1) Conform to the ContactSelector protocal:
 Add "ContactSelector" to class, example:
 """
 class ContactsTabController: UIViewController, ContextViewController, TableViewFetchedResultsDisplayer, ContactSelector {
 """
 
 2) Specify what you want to happen when searched contact is selected
 """
 func selectedContact(contact: Contact) {
 //What you want to happen when searched contact is selected
 }
 """
 
 3) Add a search controller varaible to your view controller:
 """
 private var searchController: UISearchController? //Search Controller
 """
 
 4) Implement the Search bar in your viewDidLoad method:
 """
 //Implement the Search Controller
 let resultsVC = ContactsSearchResultsController()
 resultsVC.contacts = fetchedResultsController?.fetchedObjects as! [Contact]
 
 resultsVC.contactSelector = self //Recieve Callbacks from ContactSelector.swift
 
 searchController = UISearchController(searchResultsController: resultsVC)
 searchController?.searchResultsUpdater = resultsVC
 definesPresentationContext = true
 
 tableView.tableHeaderView = searchController?.searchBar
 """
 
 */

class ContactsSearchResultsController: UITableViewController {
    
    private var filteredContacts = [Contact]()
    
    private let cellIdentifier = "ContactsSearchCell"
    
    var contactSelector: ContactSelector? //ContactSelector Protocal
    
    var contacts = [Contact]() {
        didSet {
            filteredContacts = contacts
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return filteredContacts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let contact = filteredContacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let contact = filteredContacts[indexPath.row]
        
        contactSelector?.selectedContact(contact)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ContactsSearchResultsController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        
        if searchText.characters.count > 0 {
            filteredContacts = contacts.filter {
                $0.fullName.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil }
        } else {
            filteredContacts = contacts
        }
        tableView.reloadData()
    }
}
