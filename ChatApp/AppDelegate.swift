//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/1/21.
//  Copyright © 2021 salma. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window:UIWindow?
	var coordinator: MainCoordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		launchFirstScreen()
		
		// test jenkins
		// test jenkins 2
		
		return true
	}



	// MARK: - Helper Methods
	private func launchFirstScreen() {
		let navigationController = UINavigationController()
		
		coordinator = MainCoordinator(navigationController)
		coordinator?.start()
		
		window = UIWindow()
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}

