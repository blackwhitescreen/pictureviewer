//
//  MainModuleRouter.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// _ MARK: - Abstraction and router class for navigation

protocol MainModuleRouterProtocol: AnyObject {
    /// Adding root View Controller to NC stack
    func rootVC()
    /// Pushing big image View Controller from current VC
    func bigImageVC(imageData: Data)
    /// Hiding or showing navigation bar when tapping on the screen
    func setNavBarState(isHidden: Bool)
}

class MainModuleRouter: MainModuleRouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: MainModuleAssemblyProtocol?

    init(navigationController: UINavigationController?, assemblyBuilder: MainModuleAssemblyProtocol?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func rootVC() {
        if let navigationController = navigationController {
            guard let rootVC = assemblyBuilder?.createRootVC(router: self) else { return }
            navigationController.viewControllers = [rootVC]
        }
    }

    func bigImageVC(imageData: Data) {
        if let navigationController = navigationController {
            guard let bigImageVC = assemblyBuilder?.createBigImageVC(router: self, imageData: imageData) else { return }
            navigationController.pushViewController(bigImageVC, animated: true)
        }
    }

    func setNavBarState(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }

}
