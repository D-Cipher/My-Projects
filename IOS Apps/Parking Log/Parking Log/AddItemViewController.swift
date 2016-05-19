//
//  AddItemViewController.swift
//  Parking Log
//
//  Created by Tingbo Chen on 5/11/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import CoreLocation

class AddItemViewController: UITableViewController {
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var majorIdTextField: UITextField!
    @IBOutlet weak var minorIdTextField: UITextField!
    
    var uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .CaseInsensitive)
    var nameFieldValid = false
    var UUIDFieldValid = false
    var majorFieldValid = false
    var minorFieldValid = false
    var newItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButtonItem.enabled = false
        
        nameTextField.addTarget(self, action: "nameTextFieldChanged:", forControlEvents: .EditingChanged)
        uuidTextField.addTarget(self, action: "uuidTextFieldChanged:", forControlEvents: .EditingChanged)
        majorIdTextField.addTarget(self, action: "majorTextFieldChanged:", forControlEvents: .EditingChanged)
        minorIdTextField.addTarget(self, action: "minorTextFieldChanged:", forControlEvents: .EditingChanged)
    }
    
    func nameTextFieldChanged(textField: UITextField) {
        nameFieldValid = (textField.text!.characters.count > 0)
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid && majorFieldValid && minorFieldValid)
    }
    
    func uuidTextFieldChanged(textField: UITextField) {
        let numberOfMatches = uuidRegex.numberOfMatchesInString(textField.text!, options: [], range: NSMakeRange(0, textField.text!.characters.count))
        UUIDFieldValid = (numberOfMatches > 0)
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid && majorFieldValid && minorFieldValid)
    }
    
    func majorTextFieldChanged(textField: UITextField) {
        
        if majorIdTextField.text != "" {
            let majorInt = Int(majorIdTextField.text!)
            
            if majorInt < 65535 {
                majorFieldValid = true
            } else {
                majorFieldValid = false
            }
        } else {
            majorFieldValid = false
        }
        
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid && majorFieldValid && minorFieldValid)
    }
    
    func minorTextFieldChanged(textField: UITextField) {
        
        if minorIdTextField.text != "" {
            let minorInt = Int(minorIdTextField.text!)
            
            if minorInt < 65535 {
                minorFieldValid = true
            } else {
                minorFieldValid = false
            }
        } else {
            minorFieldValid = false
        }
        
        saveBarButtonItem.enabled = (UUIDFieldValid && nameFieldValid && majorFieldValid && minorFieldValid)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveItemSegue" {
            let uuid = NSUUID(UUIDString: uuidTextField.text!)
            let major: CLBeaconMajorValue = UInt16(Int(majorIdTextField.text!)!)
            let minor: CLBeaconMinorValue = UInt16(Int(minorIdTextField.text!)!)
            
            newItem = Item(name: nameTextField.text!, uuid: uuid!, majorValue: major, minorValue: minor)
        }
    }
}