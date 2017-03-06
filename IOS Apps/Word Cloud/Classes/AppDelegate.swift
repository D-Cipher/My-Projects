//
//  AppDelegate.swift
//  Word Cloud
//
//  Created by Tingbo Chen on 5/10/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Properties

	var window: UIWindow? = {
		let window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window.backgroundColor = UIColor.whiteColor()
		window.rootViewController = UINavigationController(rootViewController: RootViewController())
		return window
	}()


	// MARK: - UIApplicationDelegate
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
		window?.makeKeyAndVisible()
		return true
	}
}
