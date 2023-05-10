//
//  Errors.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import Foundation

// Custom errors to handle additional problems in network calls

enum ImageDownloadErrors: Error {
    case convertingError(String)
    case requestError(String)
}
