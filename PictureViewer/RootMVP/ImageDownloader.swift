//
//  ImageDownloader.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import Foundation

// _ MARK: - Abstraction and implementation of Imagedownloader

protocol ImageDownloaderProtocol {
    /// Receiving all images data for given url
    func getImageDataFromURL(url: String, completion: @escaping (Result<[ImagesData], Error>) -> ())
}

class ImageDownloader {

    /// Downloading and async returning all images for given array of URLs
    private func downloadAllImageData(urls: [URL], completion: @escaping ([ImagesData]) -> ()) {
        let group = DispatchGroup()
        var imagesData: [ImagesData] = []

        for url in urls {

            group.enter()

            getDataForImageUrl(url: url) { [weak self] data in
                guard let strongSelf = self else { return }
                if let myData = data {
                    if ImageHelper.checkData(data: myData) {

                        // saving to disk should be here, not adding to an array

                        imagesData.append(strongSelf.addImageData(data: myData))
                    }
                    group.leave()
                } else {
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(imagesData)
        }

    }

    /// Returns images model for for given data
    private func addImageData(data: Data) -> ImagesData {
        return ImagesData(
            previewImageData: compressImage(data: data, maxQuality: 1.0, prefMaxBytes: 150000),
            rawImageData: data)
    }

    /// Compress image size for given data with preferred max size
    private func compressImage(data: Data, maxQuality: CGFloat, prefMaxBytes: Int) -> Data {
        let minQuality: CGFloat = 0.0

        if maxQuality <= 0.005 {

            // In case of the big image from backend that weight >5mb AFTER compression process. CANNOT BE CONVERTED to lower weight. Returning placeholder instead of original image to prevent fps drop

            if data.count > 5000000 {
                return ImageHelper.overLimitImagePlaceholder()
            }
            return data
        }

        let quality = (maxQuality + minQuality) / 2
        guard let newData = ImageHelper.compressImage(data: data, compressQuality: quality) else { return Data() }

        if newData.count <= prefMaxBytes && newData.count < data.count {
            return newData
        } else {
            return compressImage(data: data, maxQuality: quality, prefMaxBytes: prefMaxBytes)
        }
    }

    /// Returning data async for given url
    private func getDataForImageUrl(url: URL, completion: @escaping (Data?)->()) {

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        })

        task.resume()
    }
}

// _ MARK: - Protocol implementation

extension ImageDownloader: ImageDownloaderProtocol {


    /// Receiving all images data for given url
    func getImageDataFromURL(url: String, completion: @escaping (Result<[ImagesData], Error>) -> ()) {
        guard let requestUrl = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: requestUrl) {  [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // in production project we have to check for response code aswell

            if let data = data {

                guard let stringData = String(data: data, encoding: .utf8)
                else {
                    completion(.failure(ImageDownloadErrors.convertingError(NSLocalizedString("Failed with converting strings from data",
                                                                                              comment: "")))) ;
                    return
                }

                // creating array of images URLs

                let lineByLineStrings = stringData.components(separatedBy: .newlines)
                var urlsList: [URL] = []

                lineByLineStrings.forEach { string in
                    if let newUrl = URL(string: string) {
                        urlsList.append(newUrl)
                    }
                }

                // downloading all images by their URLs

                self?.downloadAllImageData(urls: urlsList) { imagesData in
                    if imagesData.count > 0 {
                        completion(.success(imagesData))
                    } else {
                        completion(.failure(ImageDownloadErrors.requestError(NSLocalizedString("Not images data for current url. Try again later",
                                                                                               comment: ""))))
                        return
                    }
                }

            } else {
                completion(.failure(ImageDownloadErrors.requestError(NSLocalizedString("Failed to get data from the url. Try again later",
                                                                                       comment: ""))))
                return
            }

        }.resume()
    }
}
