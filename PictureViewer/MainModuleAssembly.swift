//
//  MainModuleAssembly.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// _ MARK: - Abstraction and builder class for making ViewControllers and dependency injections

protocol MainModuleAssemblyProtocol {
    /// Building RootViewController
    func createRootVC(router: MainModuleRouterProtocol) -> UIViewController
    /// Building BigImageViewController
    func createBigImageVC(router: MainModuleRouterProtocol, imageData: Data) -> UIViewController
}

class MainModuleAssembly: MainModuleAssemblyProtocol {

    func createRootVC(router: MainModuleRouterProtocol) -> UIViewController {
        let rootVC = RootVC()
        let imageDownloader = ImageDownloader()
        let imageDataStoring = FileManagerImageDataStoring()
        let rootPresenter = RootPresenter(router: router, imageDownloader: imageDownloader, imageDataStoring: imageDataStoring)
        let rootView = RootView(frame: .zero, presenter: rootPresenter, parentView: rootVC)
        rootVC.customView = rootView
        rootPresenter.view = rootView

        return rootVC
    }

    func createBigImageVC(router: MainModuleRouterProtocol, imageData: Data) -> UIViewController {
        let bigImageVC = BigImageVC()
        let bigImagePresenter = BigImagePresenter(imageData: imageData, router: router)
        let bigImageView = BigImageView(frame: .zero, presenter: bigImagePresenter)
        bigImageVC.customView = bigImageView

        return bigImageVC
    }

}
