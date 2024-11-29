//
//  ProfileView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 28/8/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    var user: User?
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.selectedItem) {
                if let profileImage = viewModel.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        
                } else {
                    CircularProfileImage(user: user, size: .xLarge)
                }
            }
            
            Text(user?.fullname ?? "")
                .font(.title2)
                .fontWeight(.semibold)
        }
        
        List {
            Section {
                ForEach(SettingOptionViewModel.allCases) { option in
                    HStack {
                        Image(systemName: option.imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(option.foregroundColor)
                        Text(option.title)
                            .font(.subheadline)
                    }
                }
            }
            
            Section {
                Button("Log Out") {
                    AuthService.shared.signOut()
                }
                
                Button("Delete Account") {
                    
                }
            }
            .foregroundColor(.red)
        }
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
