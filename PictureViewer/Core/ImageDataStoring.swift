//
//  FileManagerDataStoring.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import Foundation

// _ MARK: - Abstraction and implementation of data storage
// Very simple implementation of data storing just for example

protocol ImagesDataStoringProtocol {
    // we can use associated type to make generic protocol if we plan to use different data types for image data

    /// Saving data to local store
    func saveData(imagesData: [ImagesData])
    /// Loading data from local store
    func loadData() -> [ImagesData]?
}

// In this example i use FileManager to store data, but we can use anything - CoreData, Realm, etc by implementing protocol

class FileManagerImageDataStoring: ImagesDataStoringProtocol {

    let imagesDataFileName = "imagesData"

    func saveData(imagesData: [ImagesData]) {
        guard let documentDirUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imagesFilePath = (documentDirUrl.appendingPathComponent(imagesDataFileName).appendingPathExtension("json"))
        let data = try? JSONEncoder().encode(imagesData)
        do {
            try data?.write(to: imagesFilePath)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadData() -> [ImagesData]? {
        guard let documentDirUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let imagesFilePath = documentDirUrl.appendingPathComponent(imagesDataFileName).appendingPathExtension("json")

        do {
            let data = try Data(contentsOf: imagesFilePath)
            do {
                let imagesData = try JSONDecoder().decode([ImagesData].self, from: data)
                return imagesData
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
