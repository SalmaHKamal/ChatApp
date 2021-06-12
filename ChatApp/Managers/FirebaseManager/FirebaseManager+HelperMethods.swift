//
//  FirebaseManager+HelperMethods.swift
//  ChatApp
//
//  Created by Salma Hassan on 3/16/21.
//  Copyright © 2021 salma. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Helper Methods
extension FirebaseManager {
	
	func getContacts(completion: @escaping (_ contactsInfo: [UserModel]?) -> Void) {
		guard let uid = getCurrentUserID() else {
			completion(nil)
			return
		}
		
		var contactsInfo: [UserModel]? = []
		firestore.collection(FirestoreCollections.users.rawValue)
			.whereField("uid", isNotEqualTo: uid)
			.getDocuments { (docs, error) in
				if let _ = error {
					completion(nil)
					return
				}
				
				
				docs?.documents.forEach({ (doc) in
					let dataDic: [String: Any] = doc.data()
					guard let contactInfo: UserModel = UserModel(dictionary: dataDic) else {
						completion(nil)
						return
					}
					contactsInfo?.append(contactInfo)
				})
				
				completion(contactsInfo)
		}
		
	}
	
	internal func getCurrentUserID() -> String? {
		return Auth.auth().currentUser?.uid
	}
	
	// TODO: - to be removed in useless
	func getCurrentUserProfileImage(completion: @escaping (_ profileImage: String?) -> Void) {
		guard let uid = getCurrentUserID() else {
			completion(nil)
			return
		}
		
		firestore.collection(FirestoreCollections.users.rawValue)
			.document(uid)
			.getDocument { (doc, error) in
				if let _ = error {
					completion(nil)
					return
				}
				
				let userInfo = doc?.data()
				if let photoUrl: String = userInfo?["photoUrl"] as? String {
					completion(photoUrl)
				}
				
		}
	}
	
	func getUserInfo(for uid: String, completion: @escaping (_ userModel: UserModel?) -> Void) {
		firestore.collection(FirestoreCollections.users.rawValue)
			.document(uid)
			.getDocument { (doc, error) in
				if let _ = error {
					completion(nil)
					return
				}
				
				let userInfo = doc?.data()
				let userModel: UserModel? =  UserModel(dictionary: userInfo)
				completion(userModel)
		}
	}
	
	internal func createUserModel(from authResult: AuthDataResult?) -> UserModel {
		let userModel = UserModel(uid: authResult?.user.uid,
								  displayName: authResult?.user.displayName,
								  email: authResult?.user.email,
								  phoneNumber: authResult?.user.phoneNumber,
								  photoUrl: authResult?.user.photoURL,
								  refreshToken: authResult?.user.refreshToken)
		
		return userModel
	}
	
	func getSenderInfo(_ receiverModel: UserModel, completion: @escaping ((name: String, id: String)?) -> Void){
		guard let currentUserID: String = getCurrentUserID() else {
			completion(nil)
			return
		}
		
		guard currentUserID == receiverModel.uid else {
			constructInfoTuple(for: currentUserID, completion: completion)
			return
		}
		
		guard let receiverID: String = receiverModel.uid else {
			completion(nil)
			return
		}
		
		constructInfoTuple(for: receiverID, completion: completion)
	}
	
	private func constructInfoTuple(for userID: String, completion: @escaping ((name: String, id: String)?) -> Void) {
		getUserInfo(for: userID) { (userModel) in
			guard let name = userModel?.displayName,
				let id = userModel?.uid else {
					completion(nil)
					return
			}
			
			completion((name, id))
			
		}
	}
}

