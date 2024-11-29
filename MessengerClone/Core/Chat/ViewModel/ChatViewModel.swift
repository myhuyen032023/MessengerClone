//
//  ChatViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 31/8/24.
//

import Foundation


class ChatViewModel: ObservableObject {
    @Published var messageText = ""
    @Published var messages: [Message] = []
    
    let service: ChatService
    
    init(user: User) {
        self.service = ChatService(partner: user)
        observeMessages()
    }
    
    func sendMessage() {
        service.sendMessage(messageText)
    }
    
    func observeMessages() {
        service.observeMessages { messages in
            self.messages.append(contentsOf: messages)
        }
    }
}
