//
//  ViewController.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import UIKit

final class PhotosListViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case main

        func columnCount(for layoutEnvironment: NSCollectionLayoutEnvironment) -> Int {
            let isCompact = layoutEnvironment.traitCollection.verticalSizeClass == .compact
            return isCompact ? Constants.compactColumnCount : Constants.defaultColumnCount
        }
    }
    
    enum Constants {
        static let cellReuseId = "photoCellId"
        static let title = "Photos"
        static let errorTitle = "Error"
        static let errorOkButtonTitle = "OK"
        static let errorRetryButtonTitle = "Retry"
        static let likeSymbol = "🖤"
        static let estimatedItemHeight: CGFloat = 350
        static let interItemSpacing: CGFloat = 12
        static let sectionInset: CGFloat = 12
        static let defaultColumnCount = 1
        static let compactColumnCount = 2
    }

    private var photoCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    private let photosViewModel: PhotosListViewModelProtocol
    
    private var refreshButton: UIBarButtonItem!
    private var loadingIndicatorItem: UIBarButtonItem!

    init(viewModel: PhotosListViewModelProtocol = PhotosListViewModel()) {
        self.photosViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupCollectionView()
        configureDataSource()
        loadData()
    }
}

// MARK: - Diffable Data Source
private extension PhotosListViewController {

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: photoCollectionView) {
            collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseId, for: indexPath)

            let configuration = CustomContentConfiguration(
                title: photo.displayDescription,
                likes: "\(Constants.likeSymbol) \(photo.likes)",
                textColor: UIColor(hex: photo.color) ?? .black,
                image: photo.urls.thumb
            )
            cell.contentConfiguration = configuration
            return cell
        }
    }

    func loadData() {
        Task {
            await photosViewModel.loadPhotos()
        }
    }
    
    @objc private func refreshTapped() {
        Task {
            await photosViewModel.refresh()
        }
    }

    func updateUI(for state: PhotosListViewModel.State) {
        switch state {
        case .idle:
            navigationItem.rightBarButtonItem = refreshButton
        case .loading:
            navigationItem.rightBarButtonItem = loadingIndicatorItem
        case .loaded(let photos):
            applySnapshot(with: photos)
            navigationItem.rightBarButtonItem = refreshButton
        case .error(let error):
            showError(error)
            navigationItem.rightBarButtonItem = refreshButton
        }
    }

    func applySnapshot(with photos: [Photo], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func delete(photo: Photo, animatingDifferences: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([photo])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: Constants.errorTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.errorOkButtonTitle, style: .default))
        alert.addAction(UIAlertAction(title: Constants.errorRetryButtonTitle, style: .default) { _ in
            self.loadData()
        })
        present(alert, animated: true)
    }
}

// MARK: - UI Setup
private extension PhotosListViewController {
    
    func setupUI() {
        navigationItem.title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.systemBackground
        
        refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshTapped)
        )
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        loadingIndicatorItem = UIBarButtonItem(customView: activityIndicator)
        
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    func setupBindings() {
        photosViewModel.onStateChanged = { [weak self] state in
            self?.updateUI(for: state)
        }
    }
    
    func setupCollectionView() {
        let layout = createLayout()
        photoCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        photoCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellReuseId)
        photoCollectionView.delegate = self
        view.addSubview(photoCollectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let columns = sectionKind.columnCount(for: layoutEnvironment)
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
                heightDimension: .estimated(Constants.estimatedItemHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(Constants.estimatedItemHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columns)
            group.interItemSpacing = .fixed(Constants.interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: Constants.sectionInset,
                leading: Constants.sectionInset,
                bottom: Constants.sectionInset,
                trailing: Constants.sectionInset
            )
            return section
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewController = PhotoDetailView(photo: photo)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        guard let photo = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"),attributes: .destructive)
            {
                [weak self] _ in
                self?.delete(photo: photo)
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}

