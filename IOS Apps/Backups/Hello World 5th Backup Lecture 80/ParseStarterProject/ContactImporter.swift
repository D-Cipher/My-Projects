//
//  ContactImporter.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/13/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData
import Contacts

class ContactImporter: NSObject {
    
    private var context: NSManagedObjectContext
    private var lastCNNotificationTime: NSDate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func listenForChanges() {
        CNContactStore.authorizationStatusForEntityType(.Contacts)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addressBookDidChange:", name: CNContactStoreDidChangeNotification, object: nil)
        
    }
    
    func addressBookDidChange(notification: NSNotification) {
        print(notification)
        let now = NSDate()
        guard lastCNNotificationTime == nil || now.timeIntervalSinceDate(lastCNNotificationTime!) > 1 else {return}
        lastCNNotificationTime = now
        
        fetch()
    }
    
    //Formats phone numbers to 000-000-0000
    func formatPhoneNumber(number: CNPhoneNumber) -> String {
        
        let orig_str = number.stringValue
        
        let string_arr = orig_str.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        
        let stripped_number = string_arr.joinWithSeparator("")
        
        //Attempt to format
        if stripped_number.characters.count == 10 {
            let stringts: NSMutableString = NSMutableString(string: stripped_number)
            stringts.insertString("-", atIndex: 3)
            stringts.insertString("-", atIndex: 7)
            let formatted_phoneNum = String(stringts)
            return formatted_phoneNum
        } else {
            return stripped_number
        }

    }
    
    private func fetchExisting() -> (contacts: [String:Contact], phoneNumbers: [String: PhoneNumber]) {
        
        var contacts = [String : Contact]()
        var phoneNumbers = [String: PhoneNumber]()
        
        do {
            let request = NSFetchRequest(entityName: "Contact")
            request.relationshipKeyPathsForPrefetching = ["phoneNumbers"]
            
            if let contactsResult = try self.context.executeFetchRequest(request) as? [Contact] {
                for contact in contactsResult {
                    contacts[contact.contactID!] = contact
                    for phoneNumber in contact.phoneNumbers!{
                        phoneNumbers[phoneNumber.value] = phoneNumber as? PhoneNumber
                    }
                }
            }
        } catch {print("error")}
        return (contacts, phoneNumbers)
    }
    
    func fetch() {
        let store = CNContactStore()
        store.requestAccessForEntityType(.Contacts, completionHandler: {
            granted, error in
            
            self.context.performBlock {
                if granted {
                    do {
                        let (contacts, phoneNumbers) = self.fetchExisting()
                        
                        
                        let req = CNContactFetchRequest(keysToFetch: [
                            CNContactGivenNameKey,
                            CNContactFamilyNameKey,
                            CNContactPhoneNumbersKey
                            ])
                        try store.enumerateContactsWithFetchRequest(req, usingBlock: {
                            cnContact, stop in
                            //print(cnContact)
                            
                            guard let contact = contacts[cnContact.identifier] ?? NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: self.context) as? Contact else {return}
                            
                            contact.contactID = cnContact.identifier
                            contact.lastName = cnContact.familyName
                            contact.firstName = cnContact.givenName
                            
                            let first_char = contact.firstName?.characters.first
                            var first_str = ""
                            
                            if first_char != nil {
                                first_str = String(first_char!)
                            } else {
                                first_str = ""
                            }
                            
                            let alphaNameTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z])")
                            
                            let result = alphaNameTest.evaluateWithObject(first_str)
                            
                            if result == true {
                                contact.nonAlphaName = "false"
                            } else if result == false {
                                contact.nonAlphaName = "true"
                            }
                            
                            for cnVal in cnContact.phoneNumbers {
                                guard let cnPhoneNumber = cnVal.value as? CNPhoneNumber else {continue}
                                
                                guard let phoneNumber = phoneNumbers[cnPhoneNumber.stringValue] ?? NSEntityDescription.insertNewObjectForEntityForName("PhoneNumber", inManagedObjectContext: self.context) as? PhoneNumber else {continue}
                                
                                phoneNumber.kind = CNLabeledValue.localizedStringForLabel(cnVal.label)
                                phoneNumber.value = self.formatPhoneNumber(cnPhoneNumber)
                                
                                phoneNumber.contact = contact
                                
                            }
                            
                            //Adds insterted contact into favorites
                            if contact.inserted{
                                contact.favorite = true
                            }
                        })
                        
                        try self.context.save()
                        
                    } catch let error as NSError {
                        print(error)
                    } catch {
                        print("error with do catch")
                    }
                }
            }
        })
    }
    
}

