//
//  UserService.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 30/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    
    @Published var currentUser: User?
    static let shared = UserService()
    private let usersCollection = Firestore.firestore().collection("users")
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await usersCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    func fetchAllUsers(limit: Int? = nil) async throws -> [User] {
        let query = usersCollection
        if let limit {
            query.limit(to: limit)
        }
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap{ try? $0.data(as: User.self) }
    }
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        usersCollection.document(uid).getDocument{ snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
    
    func updateProfileImage(_ imageUrl: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await usersCollection.document(uid).updateData([
            "profileImageUrl": imageUrl
        ])
        currentUser?.profileImageUrl = imageUrl
    }
    
}

