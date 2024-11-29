//
//  Message.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 31/8/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var messageID: String?
    let fromId: String
    let toId: String
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?

    var id: String {
        return messageID ?? UUID().uuidString
    }
    
    var partnerId: String {
        return Auth.auth().currentUser?.uid == fromId ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == fromId
    }
    
    var timestampString: String {
        return timestamp.dateValue().timestampString()
    }
}
