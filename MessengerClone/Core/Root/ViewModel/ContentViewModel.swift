//
//  ContentViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 29/8/24.
//

import SwiftUI
import Combine
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        //Lay gia tri binding cua userSession o ben AuthService ra roi gan cho userSession ben nay
        AuthService.shared.$userSession.sink { [weak self] userFromAuthService in
            guard let self else { return }
            self.userSession = userFromAuthService
        }.store(in: &cancellables)

    }
}
