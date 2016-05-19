//
//  ViewController.swift
//  Parking Log
//
//  Created by Tingbo Chen on 5/10/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    var settingsDict = Dictionary<String,AnyObject>()
    
    var currentLocationAcc = "Low"
    
    @IBOutlet var locationAccLabel: UILabel!

    @IBOutlet var silentSwitch: UISwitch!
    
    @IBOutlet var bluetoothSwitch: UISwitch!
    
    @IBAction func silentSwitchAction(sender: AnyObject) {
        
        if silentSwitch.on == true {
            settingsDict["silentSwitch"] = true
            
        } else if silentSwitch.on == false {
            settingsDict["silentSwitch"] = false
        }
        
        NSUserDefaults.standardUserDefaults().setObject(self.settingsDict, forKey: "settingsDict")
        
    }
    
    @IBAction func bluetoothSwitchAction(sender: AnyObject) {
        
        if bluetoothSwitch.on == true {
            settingsDict["bluetoothSwitch"] = true
            
        } else if bluetoothSwitch.on == false {
            settingsDict["bluetoothSwitch"] = false
        }
        
        NSUserDefaults.standardUserDefaults().setObject(self.settingsDict, forKey: "settingsDict")
        
    }
    
    
    private func updateUserSettings() {
        
        if NSUserDefaults().objectForKey("settingsDict") != nil {
            self.settingsDict = NSUserDefaults().objectForKey("settingsDict")! as! NSDictionary as! Dictionary<String,AnyObject>
        }
        
        if self.settingsDict["locationAcc"] as? String != nil {
            currentLocationAcc = settingsDict["locationAcc"] as! String
            
            locationAccLabel.text = currentLocationAcc
        } else {
            locationAccLabel.text = currentLocationAcc
        }
        
        if self.settingsDict["silentSwitch"] as? Bool == true {
            
            silentSwitch.on = true
            
        } else {
            silentSwitch.on = false
        }
        
        if self.settingsDict["bluetoothSwitch"] as? Bool == false {
            
            bluetoothSwitch.on = false
            
        } else {
            bluetoothSwitch.on = true
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserSettings()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUserSettings()
    }
    
     override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            performSegueWithIdentifier("ExistingBeaconsSegue", sender: self)
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            
            performSegueWithIdentifier("MultipleChoiceSegue", sender: ["High","Medium","Low"])
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
            let alertMsg = ["Caution", "You are about to clear your recent location logs."]
            
            let alert = UIAlertController(title: alertMsg[0], message: alertMsg[1], preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "savedArray")
                
                tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        return indexPath
    }
    
    @IBAction func unwindToSettingsController(segue:UIStoryboardSegue) {
        
        if let LocationAccMultipleChoice = segue.sourceViewController as? LocationAccMultipleChoice,
            selectedChoice = LocationAccMultipleChoice.selectedChoice {
            
            currentLocationAcc = selectedChoice
            
            settingsDict["locationAcc"] = currentLocationAcc
            
        }
        
        //Save to phone storage
        NSUserDefaults.standardUserDefaults().setObject(self.settingsDict, forKey: "settingsDict")
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MultipleChoiceSegue" {
            if let LocationAccMultipleChoice = segue.destinationViewController as? LocationAccMultipleChoice {
                LocationAccMultipleChoice.multiChoiceOptions = (sender as? [String])!
                LocationAccMultipleChoice.selectedChoice = currentLocationAcc
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
