//
//  AddParticipantsController.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreData

class AddGroupParticipantsController: UIViewController {

    var context: NSManagedObjectContext?
    var chat: Chat?
    var chatCreationDelegate: ChatCreationDelegate?
    
    private var searchField: UITextField!
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "ContactCell"
    
    private var displayedContacts = [Contact]()
    
    private var allContacts = [Contact]()
    
    private var selectedContacts = [Contact]()
    
    private var isSearching = false
    
    func createChat() {
        guard let chat = chat, context = context else {return}
        chat.participants = NSSet(array: selectedContacts)
        chatCreationDelegate?.created(chat: chat, inContext: context)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Participants"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "createChat")
        
        showCreateButton(false)
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        searchField = createSearchField()
        
        searchField.delegate = self
        
        tableView.tableHeaderView = searchField
        
        fillWithView(tableView)
        
        if let context = context {
            let request = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageID != nil")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending:  true)]
            
            do {
                if let result = try context.executeFetchRequest(request) as? [Contact] {
                allContacts = result
                }
            } catch {
                print("There was a problem fetching")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    private func createSearchField()->UITextField{
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        
        searchField.placeholder = "Type contact name"
        
        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        searchField.leftView = holderView
        searchField.leftViewMode = .Always
        
        let image = UIImage(named: "contact_icon")?.imageWithRenderingMode(.AlwaysTemplate)
        
        let contactImage = UIImageView(image: image)
        contactImage.tintColor = UIColor.darkGrayColor()
        
        holderView.addSubview(contactImage)
        contactImage.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
        
            contactImage.widthAnchor.constraintEqualToAnchor(holderView.widthAnchor, constant: -20),
            contactImage.heightAnchor.constraintEqualToAnchor(holderView.heightAnchor, constant: -20),
            contactImage.centerXAnchor.constraintEqualToAnchor(holderView.centerXAnchor),
            contactImage.centerYAnchor.constraintEqualToAnchor(holderView.centerYAnchor)
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        
        return searchField
    }
    
    private func showCreateButton(show: Bool) {
        
        if show == true {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            navigationItem.rightBarButtonItem?.enabled = true
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    private func endSearch() {
        displayedContacts = selectedContacts
        tableView.reloadData()
    }
    
}

extension AddGroupParticipantsController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let contact = displayedContacts[indexPath.row]
        
        cell.textLabel?.text = contact.fullName
        cell.selectionStyle = .None
        
        return cell
    }
}

extension AddGroupParticipantsController: UITableViewDelegate {
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard isSearching else {return}
        let contact = displayedContacts[indexPath.row]
        guard !selectedContacts.contains(contact) else {return}
        selectedContacts.append(contact)
        allContacts.removeAtIndex(allContacts.indexOf(contact)!)
        searchField.text = ""
        endSearch()
        showCreateButton(true)
    }
}

extension AddGroupParticipantsController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        isSearching = true
        guard let currentText = textField.text else {
            endSearch()
            return true
        }
        
        let text = NSString(string: currentText).stringByReplacingCharactersInRange(range, withString: string)
        
        if text.characters.count == 0 {
            endSearch()
            return true
        }
        
        displayedContacts = allContacts.filter {
            contact in
            
            let match = contact.fullName.rangeOfString(text) != nil
            return match
        }
        tableView.reloadData()
        return true
    }

}