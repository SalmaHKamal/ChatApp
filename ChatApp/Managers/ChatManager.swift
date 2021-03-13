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
	
	func loadChat(with receiverModel: UserModel, completion: @escaping ChatCompletion) {
		FirebaseManager().loadChat(for: receiverModel) { messages, docRef in
			completion(messages, docRef)
		}
	}
	
	func loadChatHistory(completion: @escaping ChatHistoryCompletion) {
		FirebaseManager().loadChatHistoryForCurrentUser { result in
			completion(result)
		}
	}
	
	func save(message: MessageModel, docRef: DocumentReference?) {
		FirebaseManager().saveMessage(message, with: docRef)
	}
	
	func getSenderInfo(receiverModel: UserModel, completion: @escaping ((name: String, id: String)?) -> Void) {
		FirebaseManager().getSenderInfo(receiverModel, completion: completion)
	}
}
