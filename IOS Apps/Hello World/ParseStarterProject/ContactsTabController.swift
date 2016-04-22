//
//  ContactsTabController.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI


class ContactsTabController: UIViewController, ContextViewController, TableViewFetchedResultsDisplayer, ContactSelector {
    
    var context: NSManagedObjectContext?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "ContactCell"
    
    private var fetchedResultsController: NSFetchedResultsController?
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private var searchController: UISearchController? //Search Controller
    
    func newContact() {
        let vc = CNContactViewController(forNewContact: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        cell.textLabel?.text = contact.fullName
    }
    
    func selectedContact(contact: Contact) {
        //What you want to happen when searched contact is selected
        guard let id = contact.contactID else {return}
        let store = CNContactStore()
        let cncontact: CNContact
        
        do {
            cncontact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            return
        }
        
        let vc = CNContactViewController(forContact: cncontact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        searchController?.active = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "All Contacts"
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: "newContact")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "newContact")
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        
        fillWithView(tableView)
        
        //Set up context
        if let context = context {
            /* //Detete Entity From Core Data
            let fetchRequest = NSFetchRequest(entityName: "Contact")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.executeRequest(deleteRequest)
                try context.save()
            } catch let error as NSError {
            }*/
            
            let request = NSFetchRequest(entityName: "Contact")
            
            request.predicate = NSPredicate(format: "storageID != nil") //constrains to only those in firebase
            
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending:  true), NSSortDescriptor(key: "firstName", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: nil)
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("there was a problem fetching.")
            }
        }
        
        
        //Implement the Search Controller
        let resultsVC = ContactsSearchResultsController()
        
        resultsVC.contacts = fetchedResultsController?.fetchedObjects as! [Contact]
        
        resultsVC.contactSelector = self //Recieve Callbacks from ContactSelector.swift
        
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController?.searchResultsUpdater = resultsVC
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController?.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

}

extension ContactsTabController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
}

extension ContactsTabController: CNContactViewControllerDelegate {
    
    func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
        if contact == nil {
            navigationController?.popViewControllerAnimated(true)
            return
        }
    }
    
}
