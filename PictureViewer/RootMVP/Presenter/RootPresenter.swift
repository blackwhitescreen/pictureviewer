//
//  RootPresenter.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import Foundation

// _ MARK: - Abstraction and implementation of root presenter
// All business logic connected to presenter

protocol RootPresenterProtocol: AnyObject {
    func getNumberOfItems() -> Int
    func previewDataForImage(forIndex: IndexPath) -> Data
    func rawDataForImage(forIndex: IndexPath) -> Data
    /// Pushing big image ViewController with given data
    func openBigImageVC(withData: Data)
    /// Loading images data from local store or from the internet
    func loadImagesData()
}

class RootPresenter {
    private var images = [ImagesData]()
    private let imageDownloader: ImageDownloaderProtocol
    private let imageDataStoring: ImagesDataStoringProtocol
    var router: MainModuleRouterProtocol
    weak var view: RootViewProtocol?

    init(router: MainModuleRouterProtocol, imageDownloader: ImageDownloaderProtocol, imageDataStoring: ImagesDataStoringProtocol) {
        self.router = router
        self.imageDownloader = imageDownloader
        self.imageDataStoring = imageDataStoring
    }
}

// _ MARK: - Protocol implementation

extension RootPresenter: RootPresenterProtocol {
    func getNumberOfItems() -> Int {
        return images.count
    }

    func previewDataForImage(forIndex: IndexPath) -> Data {
        return images[forIndex.row].previewImageData
    }

    func rawDataForImage(forIndex: IndexPath) -> Data {
        return images[forIndex.row].rawImageData
    }

    func openBigImageVC(withData: Data) {
        router.bigImageVC(imageData: withData)
    }

    func loadImagesData() {

        // looking for stored data on disk

        if let storedData = imageDataStoring.loadData() {
            DispatchQueue.main.async { [weak self] in
                self?.images = storedData
                self?.view?.updateCollectionView()
            }

        }
        else {

            // download data if no data on disk

            imageDownloader.getImageDataFromURL(url: "https://it-link.ru/test/images.txt") { [weak self] requestResult in
                switch requestResult {
                case .success(let imagesData):
                    self?.imageDataStoring.saveData(imagesData: imagesData)
                    self?.images = imagesData
                    self?.view?.updateCollectionView()
                case .failure(let error):
                    self?.view?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }

    }
}
