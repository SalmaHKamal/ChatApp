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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		launchFirstScreen()
		
		return true
	}



	// MARK: - Helper Methods
	private func launchFirstScreen() {
		
		let navigationController = UINavigationController(rootViewController: firstScreen)
		navigationController.navigationBar.isHidden = true
		window = UIWindow()
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
	
	var firstScreen: UIViewController {
		if Auth.auth().currentUser?.uid != nil {
			return HomeViewController(with: HomeViewModel())
		} else {
			return LoginViewController()
		}
	}
}

