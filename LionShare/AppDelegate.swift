//
//  AppDelegate.swift
//  LionShare
//
//  Created by David Hovey on 06/02/2017.
//  Copyright © 2017 14lox. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		UIApplication.shared.statusBarStyle = .lightContent
		
		return true
	}
}

