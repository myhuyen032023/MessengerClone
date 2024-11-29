//
//  InboxRowView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 27/8/24.
//

import SwiftUI

struct InboxRowView: View {
    
    let message: Message
    let viewModel: InboxViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImage(user: message.user, size: .medium)
            
            VStack(alignment: .leading) {
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message.messageText)
                    .frame(maxWidth: UIScreen.main.bounds.width - 180, alignment: .leading)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text(message.timestampString)
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        .swipeActions {
            Button {
                Task { await viewModel.removeConversation(message) }
            } label: {
                Image(systemName: "trash")
            }
            .tint(Color(.systemRed))
        }
    }
}

//#Preview {
//    InboxRowView()
//}
