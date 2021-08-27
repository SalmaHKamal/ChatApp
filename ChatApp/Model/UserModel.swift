//
//  UserModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 1/22/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

class UserModel: Codable {
	var uid: String?
	var displayName: String?
	var email: String?
	var phoneNumber: String?
	var photoUrl: URL?
	var refreshToken: String?
	
	
	
	// MARK: - Inits
	init(uid: String?, displayName: String?, email: String?, phoneNumber: String?, photoUrl: URL?, refreshToken: String?) {
		self.uid = uid
		self.displayName = displayName
		self.email = email
		self.phoneNumber = phoneNumber
		self.photoUrl = photoUrl
		self.refreshToken = refreshToken
	}
	
	init?(dictionary: [String: Any]?) {
		guard let dictionary = dictionary else {
			return
		}
		
		guard let uid = dictionary["uid"] as? String,
			let name: String = dictionary["name"] as? String,
			let email: String = dictionary["email"] as? String else {
				return
		}
		
		self.uid = uid
		self.displayName = name
		self.email = email
		
		if let phoneNumber: String = dictionary["phoneNumber"] as? String {
			self.phoneNumber = phoneNumber
		}
		
		if let refreshToken: String = dictionary["refreshToken"] as? String {
			self.refreshToken = refreshToken
		}
		
		if let photoUrl: String = dictionary["photoUrl"] as? String {
			self.photoUrl = URL(string: photoUrl)
		}
	}
	
	init?(from userModel: User?) {
		guard let userModel = userModel else {
			return
		}
		
		let uid = userModel.uid
		
		
		guard let name: String = userModel.displayName,
			let email: String = userModel.email else {
				return
		}
		
		self.uid = uid
		self.displayName = name
		self.email = email
		
		if let phoneNumber: String = userModel.phoneNumber {
			self.phoneNumber = phoneNumber
		}
		
		if let refreshToken: String = userModel.refreshToken{
			self.refreshToken = refreshToken
		}
		
		if let photoUrl: URL = userModel.photoURL {
			self.photoUrl = photoUrl
		}
		
	}
}


