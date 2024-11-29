//
//  NewMessageView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 28/8/24.
//

import SwiftUI

struct NewMessageView: View {
    
    @State var searchText = ""
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = NewMesageViewModel()
    @Binding var selectedUser: User?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                TextField("To: ", text: $searchText)
                    .frame(height: 44)
                    .padding(.leading)
                    .background(Color(.systemGray5))
                
                Text("CONTACTS")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ForEach(viewModel.users) { user in
                    VStack {
                        HStack {
                            CircularProfileImage(user: user, size: .small)
                            
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Divider()
                            .padding(.leading)
                    }
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NewMessageView( selectedUser: .constant(User.MOCK_USER))
}
