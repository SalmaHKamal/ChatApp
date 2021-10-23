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
	
	func set(currentUser: UserModel) {
		do {
			let model = try JSONEncoder().encode(currentUser)
			manager.setValue(model, forKey: UserDefaultsKeys.currentUser.rawValue)
			manager.synchronize()
		} catch {
			fatalError("Couldn't persist user model from user default")
		}
	}
	
	func get(with key: UserDefaultsKeys) -> Any?  {
		do {
			guard let data = manager.object(forKey: key.rawValue) as? Data else {
				return FirebaseManager().getCurrentUser()
			}
			let model = try JSONDecoder().decode(UserModel.self, from: data)
			return model
		} catch {
			fatalError("Couldn't get user model from user default")
		}
	}
}
