//
//  ActiveNowView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 27/8/24.
//

import SwiftUI

struct ActiveNowView: View {
    @StateObject var viewModel = ActiveNowViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(viewModel.users) { user in
                    NavigationLink {
                        ChatView(user: user)
                    } label: {
                        UserActiveView(user: user)
                    }

                }
            }
            .padding()
        }
        .frame(height: 106)
    }
}

#Preview {
    ActiveNowView()
}
