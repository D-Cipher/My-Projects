//
//  ChatTabController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import Foundation
import CoreData

class ChatTabController: UIViewController, TableViewFetchedResultsDisplayer, ChatCreationDelegate {
    
    var context: NSManagedObjectContext?

    private var fetchedResultsController: NSFetchedResultsController?
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "MessageCell"
    
    func fakeData(){ //For testing
        guard let context = context else {return}
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as? Chat
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let cell = cell as! ChatCell
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else {return}
        
        guard let contact = chat.participants?.anyObject() as? Contact else {return}
        
        guard let lastMessage = chat.lastMessage, timestamp = lastMessage.timestamp, text = lastMessage.text else {return}
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        cell.nameLabel.text = contact.fullName
        cell.dateLabel.text = formatter.stringFromDate(timestamp)
        cell.messageLabel.text = text
    }
    
    func contactSegueAction() {
        self.performSegueWithIdentifier("contactSegue", sender: self)
    }
    
    /*func newChat() {
        let vc = ContactsViewController()
        
        //vc.context = context //Replaced with Child Context

        //Add Child Context
        let chatContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        chatContext.parentContext = context
        vc.context = chatContext
        
        vc.chatCreationDelegate = self
        let navVC = UINavigationController(rootViewController: vc)
        
        presentViewController(navVC, animated: true, completion: nil)
    }*/
    
    func created(chat chat: Chat, inContext context: NSManagedObjectContext) {
        
        //Initiate Message View Controller
        let vc = MessageViewController()
        vc.context = context
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated:true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Nav Bar
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "contact_book"), style: .Plain, target: self, action: "contactSegueAction") //"newChat"
        automaticallyAdjustsScrollViewInsets = false
        
        //Set up Chat Table
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        tableView.delegate = self
        
        fillWithView(tableView)
        
        //Set up Core Data Fetching Context
        if let context = context {
            let request = NSFetchRequest(entityName: "Chat")
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            //Setup the FetchedResultsDelegate with the TableViewFetchedResultsDelegate
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("error fetching")
            }
        }
        
        fakeData() //For testing
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        /*
        if segue.identifier == "MsgSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let msgVC = nav.topViewController as! MessageViewController
            msgVC.context = context
            
        }
        */

        if segue.identifier == "contactSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let contactsVC = nav.topViewController as! ContactsViewController
            
            //Add Child Context
            let chatContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            chatContext.parentContext = context
            contactsVC.context = chatContext
            
            contactsVC.chatCreationDelegate = self
        }

    }
}

extension ChatTabController: UITableViewDataSource {
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
}

extension ChatTabController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let chat = fetchedResultsController?.objectAtIndexPath(indexPath) as? Chat else {return}
        
        //Initiate Message View Controller
        let vc = MessageViewController()
        vc.context = context
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated:true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}