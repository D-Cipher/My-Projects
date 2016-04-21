//
//  AppDelegate.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Bolts
import Parse
import CoreData

// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var contactImporter: ContactImporter? //Contact Importer Attribute
    
    private var contactsSyncer: Syncer?
    
    private var contactsUploadSyncer: Syncer?
    
    private var firebaseSyncer: Syncer?
    
    private var firebaseStore: FirebaseStore?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //====App Skin Customization====
        let vlight_grey = UIColor(red: 0.97, green: 0.95, blue: 0.95, alpha: 1.0)
        let col_blkchalk = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = col_blkchalk
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor() //Nav bar back button to white
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent //changes the status bar showing carrier, time, battery. Remember: add "View controller-based status bar appearance" to info.plist with Bool "No"
        UITabBar.appearance().barTintColor = vlight_grey
        UITabBar.appearance().tintColor = UIColor.greenColor()
        
        
        //====Setup Main Context=====
        let root = window!.rootViewController as! LoginViewController
        let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        root.context = mainContext
        
        //fakeData(context) //fake contacts
        
        //====Setup Contacts and Firebase Context====
        let contactsContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        contactsContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        let firebaseContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        firebaseContext.persistentStoreCoordinator = CDHelper.sharedInstance.coordinator
        
        contactsSyncer = Syncer(mainContext: mainContext, backgroundContext: contactsContext)
        
        //====Setup Remote Store=====
        let firebaseStore = FirebaseStore(context: firebaseContext)
        self.firebaseStore = firebaseStore
        
        contactsUploadSyncer = Syncer(mainContext: mainContext, backgroundContext: firebaseContext)
        contactsUploadSyncer?.remoteStore = firebaseStore
        
        firebaseSyncer = Syncer(mainContext: mainContext, backgroundContext: firebaseContext)
        firebaseSyncer?.remoteStore = firebaseStore
        
        contactImporter = ContactImporter(context: contactsContext)
        //importContacts(contactsContext) //imports local contacts
        
        root.remoteStore = firebaseStore
        root.contactImporter = contactImporter
        
        //Start Syncing
        firebaseStore.startSyncing()
        contactImporter?.listenForChanges()
        
        
        //====Set up Parse=====
        Parse.enableLocalDatastore() //Enable storing and querying data from Local Datastore. Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.

        Parse.setApplicationId("pylRald7yYLGVt0Swqo9rIQBMxQIf7XnwlgCc89P",
            clientKey: "8tqC7IscC9XeOXX8JGHMMMSsMuzxJb5eTCXQKvBd")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

        PFUser.enableAutomaticUser()

        let defaultACL = PFACL();

        defaultACL.setPublicReadAccess(true) //If you would like all objects to be private by default, remove this line.

        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)

        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.

            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [UIRemoteNotificationType.Badge, UIRemoteNotificationType.Alert, UIRemoteNotificationType.Sound]
            application.registerForRemoteNotificationTypes(types)
        }
    
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    //====Parse Push Notifications=====
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded, error) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    //====Push Notification with Background App Refresh====
    //Uncomment this method if you want to use Push Notifications with Background App Refresh
    /*func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
         if application.applicationState == UIApplicationState.Inactive {
             PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
         }
    }*/
    
    
    //=====Facebook SDK Integration=====
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
    //=====Create Some Fake Contacts=====
    /*func fakeData(context: NSManagedObjectContext) {
        let dataSeeded = NSUserDefaults.standardUserDefaults().boolForKey("dataSeeded")
        guard !dataSeeded else {return}
        
        let people = [("Alice", "Dong"), ("Carmen", "Cheng"), ("Umi", "Zhou")]
        
        for person in people {
            let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: context) as! Contact
            
            contact.firstName = person.0
            contact.lastName = person.1
        }
        
        do {
            try context.save()
        } catch {
            print("Error Saving")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "dataSeeded")
        
    } */
 
    
    //=====Import Local Contacts=====
    func importContacts(context: NSManagedObjectContext) {
        let dataSeeded = NSUserDefaults.standardUserDefaults().boolForKey("dataSeeded")
        guard !dataSeeded else {return}
        
        contactImporter?.fetch()
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "dataSeeded")
    }
    
}
