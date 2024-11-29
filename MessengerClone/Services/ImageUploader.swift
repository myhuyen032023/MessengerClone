//
//  ImageUploader.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 3/9/24.
//

import UIKit
import FirebaseStorage

class ImageUploader {
    
    static func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return nil }
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        let _ = try await ref.putDataAsync(imageData)   //Luu vao trong database
        let url = try await ref.downloadURL()   //Download url ma firebase tu dong tao ra va lay string 
        
        return url.absoluteString
    }
}
