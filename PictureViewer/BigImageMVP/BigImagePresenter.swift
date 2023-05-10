//
//  BigImagePresenter.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import Foundation

// _ MARK: - Abstraction and implementation of big image presenter

protocol BigImagePresenterProtocol: AnyObject {
    var imageData: Data? { get set }
    /// Hiding or showing navigation bar when tapping on the screen
    func changeNavBarState()
}

class BigImagePresenter {

    init(imageData: Data?, router: MainModuleRouterProtocol) {
        self.imageData = imageData
        self.router = router
    }

    var router: MainModuleRouterProtocol?
    private var isNavBarHidden = false
    var imageData: Data?

    private func changeState(state: Bool) {
        if state {
            router?.setNavBarState(isHidden: false)
            isNavBarHidden = !isNavBarHidden
        } else {
            router?.setNavBarState(isHidden: true)
            isNavBarHidden = !isNavBarHidden
        }
    }
}

// _ MARK: - Protocol implementation

extension BigImagePresenter: BigImagePresenterProtocol {

    func changeNavBarState() {
        isNavBarHidden ? changeState(state: true) : changeState(state: false)
    }

}
