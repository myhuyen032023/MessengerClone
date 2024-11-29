//
//  InboxService.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 1/9/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class InboxService {
    @Published var documentChanges: [DocumentChange] = []
    
    private let messagesCollection = Firestore.firestore().collection("messages")
    
    func observeRecentMessage() {
        //Lay recent-messages cua current user
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let query = messagesCollection.document(currentUserId).collection("recent-messages")
        
        //Cho no lang nghe thay doi real-time
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added || $0.type == .modified }) else { return }
            self.documentChanges = changes
        }
    }
    
    func removeConversation(_ message: Message) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let partnerId = message.partnerId
        
        let snapshot = try await messagesCollection.document(uid).collection(partnerId).getDocuments()
        
        for doc in snapshot.documents {
            try await messagesCollection.document(uid).collection(partnerId).document(doc.documentID).delete()
        }
        
        try await messagesCollection.document(uid).collection("recent-messages").document(message.id).delete()
    }
}
