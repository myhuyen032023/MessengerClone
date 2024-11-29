//
//  NewMesageViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 31/8/24.
//

import Foundation

@MainActor
class NewMesageViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init () {
        Task { try await fetchAllUsers() }
    }
    
    func fetchAllUsers() async throws {
        self.users = try await UserService.shared.fetchAllUsers()
    }
}
