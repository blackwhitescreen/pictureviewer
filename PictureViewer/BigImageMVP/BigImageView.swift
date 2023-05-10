//
//  BigImageView.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// _ MARK: - Implementation of big image view

class BigImageView: UIView {

    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private var presenter: BigImagePresenterProtocol?

    // _ MARK: - Init

    init(frame: CGRect, presenter: BigImagePresenterProtocol?) {
        super.init(frame: frame)
        self.presenter = presenter
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // _ MARK: - Private functions

    private func setupView() {

        backgroundColor = UIColor(named: "backgroundColorBigImageVC")

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0

        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        if let data = presenter?.imageData {
            imageView.image = UIImage(data: data)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        setupNavBarStateChanger()
    }

    private func setupNavBarStateChanger() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeNavBarState))
        addGestureRecognizer(tapGesture)
    }

    @objc private func changeNavBarState() {
        presenter?.changeNavBarState()
    }
}

// _ MARK: - Implementation of zooming fuction

extension BigImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

