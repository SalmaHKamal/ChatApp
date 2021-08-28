//
//  File.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

struct MessageModel: Codable {
	var id: String?
    var content: String?
    var created: Date?
    var senderID: String?
    var senderName: String?
	var isRead: Bool = false
	
	var dictionary: [String: Any] {
		return ["id": id as Any,
				"content": content as Any,
				"created": created?.timestamp as Any,
				"senderID": senderID as Any,
				"senderName": senderName as Any,
				"isRead": isRead as Any]
	}
	
	init() {}
	
	init?(dictionary: [String: Any]?) {
		guard let dictionary = dictionary else {
			return
		}
		
		guard let uid: String = dictionary["id"] as? String,
			  let content: String = dictionary["content"] as? String,
			  let created: Timestamp = dictionary["created"] as? Timestamp,
			  let senderID: String = dictionary["senderID"] as? String,
			  let senderName: String = dictionary["senderName"] as? String,
			  let isRead: Bool = dictionary["isRead"] as? Bool else {
			assertionFailure("Failed to map message model")
			return
		}
		
		self.id = uid
		self.content = content
		self.created = created.dateValue()
		self.senderID = senderID
		self.senderName = senderName
		self.isRead = isRead
	}
}
