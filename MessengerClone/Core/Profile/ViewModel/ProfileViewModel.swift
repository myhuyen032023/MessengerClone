//
//  ProfileViewModel.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 28/8/24.
//

import SwiftUI
import PhotosUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task{ try await loadImage() } }
    }
    
    @Published var profileImage: Image?
    
    func loadImage() async throws {
        guard let selectedItem else { return }
        guard let imageData = try await selectedItem.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
        
        guard let imageUrl = try await ImageUploader.uploadImage(uiImage) else { return }
        try await UserService.shared.updateProfileImage(imageUrl)
    }
}
