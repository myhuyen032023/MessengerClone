//
//  UserActiveView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 27/8/24.
//

import SwiftUI

struct UserActiveView: View {
    let user: User
    var body: some View {
        VStack{
            ZStack(alignment: .bottomTrailing) {
                CircularProfileImage(user: user, size: .medium)
                
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 18, height: 18)
                    
                    Circle()
                        .fill(Color(.systemGreen))
                        .frame(width: 12, height: 12)
                }
            }
            
            Text(user.firstname)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    UserActiveView(user: User.MOCK_USER)
}
