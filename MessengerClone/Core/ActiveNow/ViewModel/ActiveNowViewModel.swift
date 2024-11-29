//
//  ActiveNowViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 2/9/24.
//

import Foundation

class ActiveNowViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        Task { try await fetchUsers() }
        print("users \(self.users)")
    }
    
    @MainActor
    func fetchUsers() async throws {
        self.users = try await UserService.shared.fetchAllUsers(limit: 10)
    }
}
