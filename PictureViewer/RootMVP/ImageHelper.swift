//
//  ImageHelper.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// Extracting UIKit from business logic from ImageDownloader

class ImageHelper {

    /// Compressing image with given data and returning data with compression
    static func compressImage(data: Data, compressQuality: CGFloat) -> Data? {
        return UIImage(data: data)?.jpegData(compressionQuality: compressQuality) ?? nil
    }

    /// Check data if it possible to convert it to image or not
    static func checkData(data: Data) -> Bool {
        if let _ = UIImage(data: data) {
            return true
        } else {
            return false
        }
    }

    /// Returning placeholder image data in case of size limit for downloaded image
    static func overLimitImagePlaceholder() -> Data {
        guard let data = UIImage(named: "overLimitImagePlaceholder")?.jpegData(compressionQuality: 1.0) else { return Data() }
        return data
    }
    
}
