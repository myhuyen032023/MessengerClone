//
//  InboxView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 27/8/24.
//

import SwiftUI

struct InboxView: View {
    
    @State var isShowNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State var showChat = false
    
    private var user: User! {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //ActiveView
                ActiveNowView()
                
                List {
                    ForEach(viewModel.recentMessages) { message in
                        ZStack {
                            NavigationLink {
                                if let user = message.user {
                                    ChatView(user: user)
                                }
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)

                            InboxRowView(message: message, viewModel: viewModel)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 120)
                
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedUser, {
                showChat = selectedUser != nil
            })
            .navigationDestination(isPresented: $showChat, destination: {
                if let selectedUser {
                    ChatView(user: selectedUser)
                }
            })
            .fullScreenCover(isPresented: $isShowNewMessageView) {
                NewMessageView(selectedUser: $selectedUser)
            }
            //toolbar cho thang scrollview chu khong phai stack nha
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        NavigationLink(destination: ProfileView(user: user)) {
                            CircularProfileImage(user: user, size: .xSmall)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowNewMessageView = true
                        selectedUser = nil
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    }
                }
            }
        }
        
    }
}


