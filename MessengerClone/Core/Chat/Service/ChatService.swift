//
//  ChatService.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 1/9/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChatService {
    //Tao collection "messages"
    private let messagesCollection = Firestore.firestore().collection("messages")
    
    let partner: User
    
    init(partner: User) {
        self.partner = partner
    }
    
    func sendMessage(_ messageText: String) {
        
        //--------------------------Store all messages-----------------//
        //Lay id cua nguoi gui va nguoi nhan
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let partnerId = partner.id
        
        //Tao documentPath currentUserId va tao collectionPath partnerId de lien ket currentUserId voi partnerId
        let currentUserRef = messagesCollection.document(currentUserId).collection(partnerId).document()    //O day minh tao mot document rong, de no tu dong tao id cho minh, minh se dung id nay de set du lieu cho ca 2 path nay
        
        //Tao documentPath partnerId va tao collectionPath currentUserId de lien ket partnerId voi currentUserId
        let partnerRef = messagesCollection.document(partnerId).collection(currentUserId)
        
        //Tao message object
        let messageId = currentUserRef.documentID
        
        //WARNING: Tai sao phải khởi tạo messageID vậy???????? Lát test thử xem
        //Test rồi không cần gán nó vẫn ổn nha
        let message = Message(fromId: currentUserId, toId: partnerId, messageText: messageText, timestamp: Timestamp())
        
        //Ma hoa message do
        guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
        
        //Set data cho ca 2 document tren la message da ma hoa
        currentUserRef.setData(encodedMessage)
        partnerRef.document(messageId).setData(encodedMessage)
        
        
        //-------------------Store recent messages-----------------//
        let recentUserRef = messagesCollection.document(currentUserId).collection("recent-messages").document(partnerId)
        let recentPartnerRef = messagesCollection.document(partnerId).collection("recent-messages").document(currentUserId)
        recentUserRef.setData(encodedMessage)
        recentPartnerRef.setData(encodedMessage)
    }
    
    func observeMessages(completion: @escaping([Message]) -> Void) {
        //Lay messages cua current user va partner
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let partnerId = partner.id
        
        let query = messagesCollection
            .document(currentUserId)
            .collection(partnerId)
            .order(by: "timestamp", descending: false)
        
        //Cho query lang nghe su thay doi real-time voi database
        query.addSnapshotListener { snapshot, _ in
            //Fileter nhung document duoc them vao
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            print("changes \(changes)")
            
            //Giai ma du lieu
            var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})
            
            //Gan user cho cac tin nhan cua partner (Can dung no trong ChatView)
            for (index, message) in messages.enumerated() where message.fromId != currentUserId {
                messages[index].user = self.partner
            }
            
            //Goi completion handler
            completion(messages)
        }
    }
}
