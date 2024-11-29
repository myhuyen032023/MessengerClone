//
//  RegistrationViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 29/8/24.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    
    func createUser(){
        Task { try await AuthService.shared.createUser(email: email, password: password, fullname: fullname) }
    }
}
