//
//  FirebaseManager+ChatHistory.swift
//  ChatApp
//
//  Created by Salma Hassan on 23/07/2021.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseManager {
	
	// MARK: - Load
	func loadChatHistory(completion: @escaping ([ChatHistoryModel]) -> Void) {
		guard let currentUser = userDefaultsManager.get(with: .currentUser) as? UserModel,
			  let currentUserID = currentUser.uid else {
			completion([])
			return
		}
		firestore.collection(FirestoreCollections.chatHistory.rawValue)
			.whereField("senderID", isNotEqualTo: currentUserID)
			.addSnapshotListener { (snapshot, error) in
				guard let snapshot = snapshot else {
					print("No snapshot and maybe error => ".uppercased(), error as Any)
					return
				}
				var models: [ChatHistoryModel] = []
				
				if !snapshot.isEmpty {
					constructModels(snapshot, &models)
				}
				completion(models)
			}
	}
	
	// MARK: - Save
	func saveChatHistory(model: ChatHistoryModel) {
		guard let dictionary = model.dict else {
			return
		}
		saveChatHistory(dictionary: dictionary)
	}
	
	func saveChatHistory(dictionary: [String: Any]) {
		let firestoreRef = firestore.collection(FirestoreCollections.chatHistory.rawValue)
			.document()
		let chatHistoryDocumentID = firestoreRef.documentID
		var mutableDictionary = dictionary
		mutableDictionary.updateValue(chatHistoryDocumentID, forKey: "chatHistoryId")
		
		firestoreRef.setData(mutableDictionary) { (error) in
				guard let error = error else {
					print("data saved successfully".uppercased())
					return
				}
				print("an error occured => ".uppercased(), error)
			}
	}
	
	// MARK: - Delete
	func deleteChatHistory(with id: String) {
		firestore.collection(FirestoreCollections.chatHistory.rawValue)
			.document(id)
			.delete { (error) in
				guard let error = error else {
					print("Record deleted successfully".uppercased())
					return
				}
				print("Couldn't delete chat history with id \(id) because of error \(error)".uppercased())
			}
	}
	
	// MARK: - Helper Methods
	fileprivate func constructModels(_ snapshot: QuerySnapshot, _ models: inout [ChatHistoryModel]) {
		// map
		snapshot.documents.forEach { (docs) in
			if let model = ChatHistoryModel(dictionary: docs.data()) {
				// filter only chat that I'm member on
				if let members = model.members, members.contains(getCurrentUserID() ?? "") {
					models.append(model)
				}
			}
		}
		
		// sort
		models.sort(by: { $0.unSeenMessageCount > $1.unSeenMessageCount })
	}
}
