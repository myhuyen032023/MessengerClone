//
//  InboxViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 30/8/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
class InboxViewModel: ObservableObject {
    
    @Published var currentUser: User?
    @Published var recentMessages: [Message] = []
    private var cancellables = Set<AnyCancellable>()
    let service = InboxService()
    var didCompleteInitialLoad = false
    
    
    init() {
        setupSubscribers()
        service.observeRecentMessage()
        
    }
    
    func removeConversation(_ message: Message) async {
        do {
            recentMessages.removeAll(where: { $0.id == message.id })
            try await service.removeConversation(message)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            guard let self else { return }
            self.currentUser = user
            
        }.store(in: &cancellables)
        
        service.$documentChanges.sink { [weak self] changes in
            guard let self else { return }

            if didCompleteInitialLoad {
                updateMessages(changes: changes)
            } else {
                loadingInitialMessages(changes: changes)
            }
            
        }.store(in: &cancellables)
    }
    
    private func loadingInitialMessages(changes: [DocumentChange]) {
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})

        for (index, message) in messages.enumerated() {
//            recentMessages.removeAll{ $0.partnerId == message.partnerId }
            //Day la cach minh fix, nhung no chua hieu qua (no load lai toan bo view) va nhieu vong lap long nhau nua
            
            UserService.shared.fetchUser(withUid: message.partnerId) { [weak self] user in
                messages[index].user = user
                self?.recentMessages.insert(messages[index], at: 0)
                if index == messages.count - 1 {
                    self?.didCompleteInitialLoad = true
                }
            }
        }
    }
    
    private func updateMessages(changes: [DocumentChange]) {
        for change in changes {
            if change.type == .added {
                createNewConversation(change: change)
            } else if change.type == .modified {
                updateExistingConversation(change: change)
            }
        }
    }
    
    private func createNewConversation(change: DocumentChange) {
        guard var message = try? change.document.data(as: Message.self) else { return }
        
        UserService.shared.fetchUser(withUid: message.partnerId) { [weak self] user in
            message.user = user
            self?.recentMessages.insert(message, at: 0)
        }
    }
    
    private func updateExistingConversation(change: DocumentChange) {
        guard var message = try? change.document.data(as: Message.self) else { return }
        guard let index = recentMessages.firstIndex(where: { $0.user?.id == message.partnerId }) else { return }
        
        message.user = recentMessages[index].user
        recentMessages.remove(at: index)
        recentMessages.insert(message, at: 0)
    }
}
