//
//  ChatView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 28/8/24.
//

import SwiftUI

struct ChatView: View {
    
    let user: User
    @StateObject var viewModel: ChatViewModel
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                //header
                VStack {
                    CircularProfileImage(user: user, size: .xLarge)
                    
                    VStack(spacing: 4) {
                        Text(user.fullname)
                            .font(.title3)
                            .fontWeight(.semibold)
                            
                        Text("Message")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                //messages
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        ChatMessageCell(message: message)
                    }
                }
                
            }
            //message input field
            Spacer()
            
            ZStack(alignment: .trailing) {
                TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    
                    
                Button {
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
