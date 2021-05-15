//
//  UserDefaultsManager.swift
//  ChatApp
//
//  Created by Salma Hassan on 5/15/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
	case currentUser
}

struct UserDefaultsManager {
	private var manager = UserDefaults.standard
	
	init() {}
	
	init(defaultsManager: UserDefaults) {
		manager = defaultsManager
	}
	
	func set(currentUser: UserModel) throws {
		let model = try NSKeyedArchiver.archivedData(withRootObject: currentUser, requiringSecureCoding: false)
		manager.setValue(model, forKey: UserDefaultsKeys.currentUser.rawValue)
		manager.synchronize()
	}
	
	func get(with key: UserDefaultsKeys) -> Any? {
		return manager.object(forKey: key.rawValue)
	}
}
