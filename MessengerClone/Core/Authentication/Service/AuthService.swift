//
//  AuthService.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 29/8/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    static let shared = AuthService()
    
    init() {
        //Minh van phai gan currentUser cho userSession cho lan dau goi (luc moi launch app)
        self.userSession = Auth.auth().currentUser
        
        //Sau do neu van co user dang nhap thi se load du lieu (tinh trong truong hop nguoi dung da dang nhap truoc do ma chua logout va gio
        // mo lai app)
        loadUserData()
        
        
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            //Sau khi login se lay du lieu ve
            loadUserData()
        } catch {
            print("DEBUG: catched error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            //Minh luu thong tin khac vao dung userId ma FirebaseAth da cap
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
            
            //Sau khi dang ky thanh cong se lay du lieu ve
            loadUserData()
        } catch {
            print("DEBUG: catched error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("DEBUG: catched error: \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, profileImageUrl: nil)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    func loadUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
}
