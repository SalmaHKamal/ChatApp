//
//  ChatHistoryModel.swift
//  ChatApp
//
//  Created by Salma Hassan on 23/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

enum ChatType: String {
	case privateChat = "private"
	case groupChat = "group"
}

struct ChatHistoryModel: Codable {
	var chatRoomId: String?
	var date: Date?
	var senderAvatar: String?
	var senderName: String?
	var lastMessage: String?
	var unSeenMessageCount: Int = 0
	var type: String = ChatType.privateChat.rawValue
	var senderID: String?
	var members: [String]?
	var chatHistoryId: String?
	
	init() {}
	
	init?(dictionary: [String: Any]?) {
		guard let dictionary = dictionary else {
			return
		}
		
		guard let chatRoomId = dictionary["chatRoomId"] as? String,
			  let timestamp = dictionary["date"] as? Timestamp,
			  let senderName = dictionary["senderName"] as? String,
			  let lastMessage = dictionary["lastMessage"] as? String,
			  let unSeenMessageCount = dictionary["unSeenMessageCount"] as? Int,
			  let chatType = dictionary["type"] as? String,
			  let senderID = dictionary["senderID"] as? String,
			  let members = dictionary["members"] as? [String],
			  let chatHistoryId = dictionary["chatHistoryId"] as? String else {
			return
		}
		
		self.chatRoomId = chatRoomId
		self.date = timestamp.dateValue()
		self.senderAvatar = dictionary["senderAvatar"] as? String
		self.senderName = senderName
		self.lastMessage = lastMessage
		self.unSeenMessageCount = unSeenMessageCount
		self.type = chatType
		self.senderID = senderID
		self.members = members
		self.chatHistoryId = chatHistoryId
	}
}
