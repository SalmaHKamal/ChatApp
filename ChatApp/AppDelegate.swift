//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/1/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window:UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		launchFirstScreen()
		
		return true
	}



	// MARK: - Helper Methods
	private func launchFirstScreen() {
		let viewController = LoginViewController()
		window = UIWindow()
		window?.rootViewController = viewController
		window?.makeKeyAndVisible()
	}
}

