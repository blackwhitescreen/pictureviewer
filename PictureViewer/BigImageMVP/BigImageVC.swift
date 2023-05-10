//
//  BigImageVC.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// Big Image ViewController with custom view

class BigImageVC: UIViewController {
    var customView: UIView?

    override func loadView() {
        super.loadView()
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Pinch to zoom", comment: "")
    }
}
