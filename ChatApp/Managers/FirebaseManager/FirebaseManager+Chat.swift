//
//  FirebaseManager+Chat.swift
//  ChatApp
//
//  Created by Salma Hassan on 3/16/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Chat Collection
typealias ChatCompletion = (_ messages: [MessageModel]?, _ docRef: DocumentReference?) -> Void
typealias ChatHistoryCompletion = (_ messagesDic: [String: (receiver: UserModel, messages: [MessageModel])]) -> Void

extension FirebaseManager {
	
	func loadChat(for receiverModel: UserModel, completion: @escaping ChatCompletion) {
		guard let currentUserID = getCurrentUserID(),
			let receiverID = receiverModel.uid else {
				return
		}
		let users = [currentUserID, receiverID]
		
		firestore.collection(FirestoreCollections.chat.rawValue)
			.whereField("users", arrayContains: currentUserID)
			.getDocuments { (chatQuerySnap, error) in
				if error != nil {
					completion(nil, nil)
					return
				}
				
				guard let chatQuerySnap = chatQuerySnap ,
					chatQuerySnap.documents.count > 0 else {
						
						self.createChat(users, completion: completion)
						return
				}
				
				var docRef: QueryDocumentSnapshot?
				chatQuerySnap.documents.forEach { (document) in
					if let users = document["users"] as? [String] {
						if users.contains(receiverID) {
							docRef = document
						}
					}
				}
				
				if let documentRef = docRef?.reference {
					self.loadMessages(docRef: documentRef, completion: completion)
				} else {
					self.createChat(users, completion: completion)
				}
				
		}
	}
	
	private func loadMessages(docRef: DocumentReference, completion: @escaping ChatCompletion) {
		docRef.collection(FirestoreCollections.messages.rawValue)
			.order(by: "id", descending: false)
			.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
				if error != nil {
					completion(nil, docRef)
					return
				}
				
				let messages = querySnapshot?.documents.compactMap { MessageModel(dictionary: $0.data()) }
				completion(messages, docRef)
				
		}
	}
	
	private func createChat(_ users: [String], completion: @escaping ChatCompletion) {
		firestore.collection(FirestoreCollections.chat.rawValue)
			.addDocument(data: ["users": users]) { (error) in
				completion(nil, nil)
		}
	}
	
	func loadChatHistoryForCurrentUser(completion: @escaping ChatHistoryCompletion) {
		guard let currentUserID = getCurrentUserID() else {
			return
		}
		
		var result: [String: (receiver: UserModel, messages: [MessageModel])] = [:]
		
		firestore.collection(FirestoreCollections.chat.rawValue)
			.whereField("users", arrayContains: currentUserID)
			.getDocuments { (chatQuerySnap, error) in
				
				chatQuerySnap?.documents.forEach({ (doc) in
					if let users: [String] = doc["users"] as? [String] {
						
						
						let IDs = users.filter({ $0 != currentUserID })
						
						if IDs.count == 1,
							let userID = IDs.first {
							
							self.loadMessages(docRef: doc.reference) { (messages, _) in
								let messagesArray = messages
								
								self.getUserInfo(for: userID) { (userModel) in
									let userModelGlobal = userModel
									
									if userModelGlobal != nil, messagesArray != nil {
										result.updateValue((userModelGlobal! , messagesArray!), forKey: userID)
									}
									
									if result.count == (chatQuerySnap?.documents.count)! {
										completion(result)
									}
								}
								
								
							}
						}
					}

				})
				
		}
	}
	
	func saveMessage(_ message: MessageModel, with docRef: DocumentReference?) {
		guard let messageDictionry: [String: Any] = message.dict else {
			return
		}
		
		docRef?.collection(FirestoreCollections.messages.rawValue).addDocument(data: messageDictionry, completion: nil)
	}
	
}



