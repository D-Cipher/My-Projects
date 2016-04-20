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
import Firebase

class ChatTabController: UIViewController, TableViewFetchedResultsDisplayer, ChatCreationDelegate, ContextViewController {
    
    var context: NSManagedObjectContext?

    private var fetchedResultsController: NSFetchedResultsController?
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "MessageCell"
    
    let firebaseEliot = Firebase(url: "https://eliotwhaletalk.firebaseio.com")
    
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
        
        guard let contact = chat.participants?.anyObject() as? Contact else {return}
        
        //Initiate Message View Controller
        let vc = MessageViewController()
        vc.context = context
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        vc.title = contact.fullName
        navigationController?.pushViewController(vc, animated:true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Nav Bar
        navigationController?.navigationBar.topItem?.title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "contact_book"), style: .Plain, target: self, action: "contactSegueAction") //"newChat"
        automaticallyAdjustsScrollViewInsets = false
        
        //Set up Chat Table
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.tableHeaderView = createHeader() //Add header to table
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
        
        //fakeData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
    
    private func createHeader() -> UIView {
        
        let header = UIView()
        let newGroupButton = UIButton()
        
        newGroupButton.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(newGroupButton)
        
        newGroupButton.setTitle("Group", forState: .Normal)
        newGroupButton.setTitleColor(view.tintColor, forState: .Normal)
        newGroupButton.addTarget(self, action: "pressedNewGroup", forControlEvents: .TouchUpInside)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(border)
        border.backgroundColor = UIColor.lightGrayColor()
        
        let constraints: [NSLayoutConstraint] = [
            
            newGroupButton.heightAnchor.constraintEqualToAnchor(header.heightAnchor),
            newGroupButton.trailingAnchor.constraintEqualToAnchor(header.trailingAnchor, constant: -10),
            border.heightAnchor.constraintEqualToConstant(1),
            border.leadingAnchor.constraintEqualToAnchor(header.leadingAnchor),
            border.trailingAnchor.constraintEqualToAnchor(header.trailingAnchor),
            border.bottomAnchor.constraintEqualToAnchor(header.bottomAnchor)
        
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        header.setNeedsLayout()
        header.layoutIfNeeded()
        
        let height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        
        return header
    }
    
    func pressedNewGroup() {
        //Initiates a New Group View Controller
        let vc = NewGroupViewController()
        let chatContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        chatContext.parentContext = context
        vc.context = chatContext
        vc.chatCreationDelegate = self
        vc.hidesBottomBarWhenPushed = true
        let navVC = UINavigationController(rootViewController: vc)
        presentViewController(navVC, animated: true, completion: nil)
        
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
        
        guard let contact = chat.participants?.anyObject() as? Contact else {return}
        
        //Initiate Message View Controller
        let vc = MessageViewController()
        vc.context = context
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        vc.title = contact.fullName
        navigationController?.pushViewController(vc, animated:true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}