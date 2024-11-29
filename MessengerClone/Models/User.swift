//
//  User.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 28/8/24.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Equatable {
    //Minh muon luu id nay giong voi documentId trong firestore
    //Mac du muc dich cua id nay chi dung de cho no tuan theo Identifiable
    @DocumentID var uid: String?
    
    var fullname: String
    var email: String
    var profileImageUrl: String?
    
    var id: String {
        return uid ?? UUID().uuidString
    }
    
    var firstname: String {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: fullname)
        return components?.givenName ?? fullname
    }
}

extension User {
    static let MOCK_USER = User(fullname: "ABCD", email: "myhuyen123@gmail.com")
}
