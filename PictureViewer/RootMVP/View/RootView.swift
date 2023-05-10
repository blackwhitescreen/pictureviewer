//
//  RootView.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

// _ MARK: - Abstraction and implementation of root view

protocol RootViewProtocol: AnyObject {
    func updateCollectionView()
    func showErrorAlert(message: String)
}

class RootView: UIView {

    // _ MARK: - Properties

    private var presenter: RootPresenterProtocol?
    private weak var parentView: RootVC?

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let label = UILabel()
    private let refreshControl = UIRefreshControl()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: Int(UIScreen.main.bounds.width) / 3 - 4, height: Int(UIScreen.main.bounds.width) / 3 - 6)
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)

        return layout
    }()

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }

    init(frame: CGRect, presenter: RootPresenterProtocol?, parentView: RootVC) {
        super.init(frame: frame)
        self.presenter = presenter
        self.parentView = parentView
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // _ MARK: - Private functions

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray5
        collectionView.register(RootGridImageCell.self, forCellWithReuseIdentifier: "gridImageCollectionViewCell")

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.addSubview(activityIndicator)
        collectionView.addSubview(label)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        setActivityIndicator(isActive: true)
        label.text = NSLocalizedString("Loading data...", comment: "")
        label.textAlignment = .center

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),

            label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])

        presenter?.loadImagesData()
    }

    private func setActivityIndicator(isActive: Bool) {
        isActive ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        activityIndicator.isHidden = !isActive
        label.isHidden = !isActive
    }

    @objc private func pullToRefresh() {
        presenter?.loadImagesData()
    }

}

// _ MARK: - Protocol implementation

extension RootView: RootViewProtocol {

    func updateCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.setActivityIndicator(isActive: false)
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }

    func showErrorAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { [weak self] _ in
                self?.setActivityIndicator(isActive: false)
            }
            alert.addAction(action)
            self?.parentView?.present(alert, animated: true)
        }
    }
}

// _ MARK: - CollectionView Delegate and DataSource

extension RootView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RootGridImageCell.identifier,
            for: indexPath) as? RootGridImageCell else { return UICollectionViewCell() }

        cell.setupCell(imageData: presenter?.previewDataForImage(forIndex: indexPath) ?? Data())

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.openBigImageVC(withData: presenter?.rawDataForImage(forIndex: indexPath) ?? Data())
    }

}
