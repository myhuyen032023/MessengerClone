//
//  LoginViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 29/8/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login(){
        Task { try await AuthService.shared.login(email: email, password: password) }
    }
}
