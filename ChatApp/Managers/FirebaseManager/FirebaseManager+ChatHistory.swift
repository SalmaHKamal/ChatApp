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
		
		firestore.collection(FirestoreCollections.chatHistory.rawValue)
			.document()
			.setData(dictionary) { (error) in
				guard let error = error else {
					print("data saved successfully".uppercased())
					return
				}
				print("an error occured => ".uppercased(), error)
			}
	}
	
	func saveChatHistory(dictionary: [String: Any]) {
		firestore.collection(FirestoreCollections.chatHistory.rawValue)
			.document()
			.setData(dictionary) { (error) in
				guard let error = error else {
					print("data saved successfully".uppercased())
					return
				}
				print("an error occured => ".uppercased(), error)
			}
	}
	
	
	// MARK: - Helper Methods
	fileprivate func constructModels(_ snapshot: QuerySnapshot, _ models: inout [ChatHistoryModel]) {
		// sort
		var sortedDocuments = snapshot.documents
		sortedDocuments.sort { (doc1, doc2) -> Bool in
			let data1 = doc1.data()
			let data2 = doc2.data()
			return data1["unSeenMessageCount"] as! Int > data2["unSeenMessageCount"] as! Int
		}
		// map
		sortedDocuments.forEach { (docs) in
			if let model = ChatHistoryModel(dictionary: docs.data()) {
				models.append(model)
			}
		}
	}
}
