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
typealias ChatRecieverData = (id: String, name: String, imageUrl: String)

extension FirebaseManager {
	
	func loadChat(for receiver: UserModel, completion: @escaping ChatCompletion) {
		guard let currentUser = getCurrentUser(),
			  let currentUserId = currentUser.uid,
			  let receiverId = receiver.uid else {
			return
		}
		let members = [currentUser, receiver]
		
		firestore.collection(FirestoreCollections.chat.rawValue)
			.whereField("users", arrayContains: currentUserId)
			.getDocuments { (chatQuerySnap, error) in
				if error != nil {
					completion(nil, nil)
					return
				}
				
				guard let chatQuerySnap = chatQuerySnap ,
					  chatQuerySnap.documents.count > 0 else {
					
					self.createChat(members, completion: completion)
					return
				}
				
				var docRef: QueryDocumentSnapshot?
				chatQuerySnap.documents.forEach { (document) in
					if let users = document["users"] as? [String] {
						if users.contains(receiverId) {
							docRef = document
						}
					}
				}
				if let documentRef = docRef?.reference {
					self.loadMessages(docRef: documentRef, completion: completion)
				} else {
					self.createChat(members, completion: completion)
				}
				
			}
	}
	
	private func loadMessages(docRef: DocumentReference, completion: @escaping ChatCompletion) {
		docRef.collection(FirestoreCollections.messages.rawValue)
			.order(by: "created", descending: false)
			.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
				if error != nil {
					completion(nil, docRef)
					return
				}
				
				let messages = querySnapshot?.documents.compactMap { MessageModel(dictionary: $0.data()) }
				completion(messages, docRef)
				
		}
	}
	
	private func createChat(_ users: [UserModel], completion: @escaping ChatCompletion) {
		let usersDicts = users.map({ $0.dict })
		firestore.collection(FirestoreCollections.chat.rawValue)
			.addDocument(data: ["users": usersDicts]) { (error) in
				completion(nil, nil)
		}
	}
	
	func saveMessage(_ message: MessageModel, with docRef: DocumentReference?) {
		let messageDictionary: [String: Any] = message.dictionary
		docRef?.collection(FirestoreCollections.messages.rawValue).addDocument(data: messageDictionary, completion: { _ in
			updateChatHistory(using: message)
		})
	}
	
	private func updateChatHistory(using message: MessageModel) {
		firestore.collection(FirestoreCollections.chatHistory.rawValue)
			.whereField("chatRoomId", isEqualTo: message.chatRoomID ?? "")
			.getDocuments { (snapshot, error) in
				guard let snapshot = snapshot else {
					print(error)
					return
				}
				
				if snapshot.count > 0 {
					updateChatHistoryRecord(doc: snapshot.documents.first, message)
				} else {
					createChatHistoryRecord(with: message)
				}
			}
		
	}
	
	private func createChatHistoryRecord(with message: MessageModel) {
		var model = ChatHistoryModel(from: message)
		guard let chatRoomId = message.chatRoomID else {
			return
		}
		firestore.collection(FirestoreCollections.chat.rawValue)
			.document(chatRoomId).getDocument { (documentSnapshot, error) in
				guard let documentSnapshot = documentSnapshot else {
					print(error as Any)
					return
				}
				guard let data = documentSnapshot.data() else {
					return
				}
				guard let usersInChat = data["users"] as? [UserModel] else {
					return
				}
				
				model.members = usersInChat.map({ $0.uid ?? "" })
				model.membersNames = usersInChat.map({ "\($0.uid ?? "")_\($0.displayName ?? "")" })
				
				// Save ChatHistory Record
				guard let dataDict = model.dict else {
					return
				}
				firestore.collection(FirestoreCollections.chatHistory.rawValue)
					.addDocument(data: dataDict) { (error) in
						print(error as Any, "happened while trying to save new chat history record")
					}
			}
	}
	
	private func updateChatHistoryRecord(doc: QueryDocumentSnapshot?, _ message: MessageModel) {
		guard let document = doc else {
			return
		}
		let fieldsToUpdate = ["lastMessage": message.contentType == .photo ? message.photoUrl : message.content]
		document.reference.updateData(fieldsToUpdate as [AnyHashable : Any]) { (error) in
			guard let error = error else {
				return
			}
			print(error)
		}
	}
	
	func uploadPhoto(_ imageData: Data, imagePath: String, completion: @escaping (String?) -> Void) {
		let storageRef = storage.reference(withPath: imagePath)
		storageRef.putData(imageData, metadata: nil) { (metaData, error) in
			guard error == nil else {
				completion(nil)
				return
			}
			
			storageRef.downloadURL { (url, error) in
				guard error == nil else {
					completion(nil)
					return
				}
				completion(url?.absoluteString)
			}
			
		}
	}
	
}



