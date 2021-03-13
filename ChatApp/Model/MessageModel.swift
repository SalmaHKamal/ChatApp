//
//  File.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation

struct MessageModel: Codable {
	var id: String?
    var content: String?
    var created: String?
    var senderID: String?
    var senderName: String?
	
	init() {}
	
	init?(dictionary: [String: Any]?) {
		guard let dictionary = dictionary else {
			return
		}
		
		guard let uid: String = dictionary["id"] as? String,
			let content: String = dictionary["content"] as? String,
			let created: String = dictionary["created"] as? String,
			let senderID: String = dictionary["senderID"] as? String,
			let senderName: String = dictionary["senderName"] as? String else {
				return
		}
		
		self.id = uid
		self.content = content
		self.created = created
		self.senderID = senderID
		self.senderName = senderName
	}
}
