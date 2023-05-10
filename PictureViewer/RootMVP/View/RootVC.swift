//
//  ViewController.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// Root ViewController with custom view

class RootVC: UIViewController {

    var customView: UIView?

    override func loadView() {
        super.loadView()
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Pictures grid", comment: "")
    }

}

