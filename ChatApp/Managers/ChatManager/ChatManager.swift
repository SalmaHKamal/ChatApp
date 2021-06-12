//
//  ChatManager.swift
//  ChatApp
//
//  Created by Salma Hassan on 2/13/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

struct ChatManager {
	let firebaseManager = FirebaseManager()
	
	func loadChat(with receiverModel: UserModel, completion: @escaping ChatCompletion) {
		firebaseManager.loadChat(for: receiverModel) { messages, docRef in
			completion(messages, docRef)
		}
	}
	
	func loadChatHistory(completion: @escaping ChatHistoryCompletion) {
		firebaseManager.loadChatHistoryForCurrentUser { result in
			completion(result)
		}
	}
	
	func save(message: MessageModel, docRef: DocumentReference?) {
		firebaseManager.saveMessage(message, with: docRef)
	}
	
	func getSenderInfo(receiverModel: UserModel, completion: @escaping ((name: String, id: String)?) -> Void) {
		firebaseManager.getSenderInfo(receiverModel, completion: completion)
	}
	
	func getUserInfo(uid: String, completion: @escaping (_ user: UserModel?) -> Void) {
		firebaseManager.getUserInfo(for: uid, completion: completion)
	}
}
