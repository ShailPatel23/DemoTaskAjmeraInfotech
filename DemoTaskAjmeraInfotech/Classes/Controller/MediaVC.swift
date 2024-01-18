//
//  MediaVC.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import UIKit
import Photos

final class MediaVC: UIViewController, PHPhotoLibraryChangeObserver {
    
    // MARK:- IBOutlets -
    @IBOutlet private weak var collVMedia: UICollectionView!
    @IBOutlet private weak var lblPermission: UILabel!
    
    // MARK:- Variable -
    var mediaVM = MediaVM.shared
    lazy private var dataSource = UICollectionViewDiffableDataSource<Int, PHAsset>(collectionView: collVMedia) { (collectionView, index, item) -> UICollectionViewCell? in
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollVCell.identifier, for: index) as? MediaCollVCell {
            
            let manager = PHImageManager.default()
            
            manager.requestImage(for: item, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: nil) { image, _ in
                                
                cell.imgVMedia.image = image
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    private let refreshControl = UIRefreshControl()

    // MARK:- Life cycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collVMedia.collectionViewLayout = createCompositionalLayout()
        createSnapshot(items: mediaVM.arrMedia)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        mediaVM.populatePhotos(type: mediaVM.selectedMediaType)
    }
}

// MARK:- Initialization -
extension MediaVC {
    
    private func initialization() {
            
        setupNavigation()
        PHPhotoLibrary.shared().register(self)
        mediaVM.populatePhotos(type: .Photo)
        collVMedia.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadMedia), for: .valueChanged)
        collVMedia.delegate = self
        collVMedia.register(MediaCollVCell.nib, forCellWithReuseIdentifier: MediaCollVCell.identifier)
        collVMedia.collectionViewLayout = createCompositionalLayout()
        mediaVM.updateData = { [weak self] in
            
            guard let self = self else { return }
            CGCDMainThread.async {
                
                self.lblPermission.isHidden = true
                self.collVMedia.isHidden = false
                self.createSnapshot(items: self.mediaVM.arrMedia)
                self.refreshControl.endRefreshing()
            }
        }
        mediaVM.accessDenied = { [weak self] in
            
            guard let self = self else { return }
            
            CGCDMainThread.async {
                self.collVMedia.isHidden = true
                self.lblPermission.isHidden = false
            }
        }
    }
    
    private func setupNavigation() {
        
        let segmentedControl = UISegmentedControl(items: ["Photo", "Video"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        navigationItem.titleView = segmentedControl
    }
    
    private func createSnapshot(items: [PHAsset]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, PHAsset>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let inset: CGFloat = 4
        
        var itemWidth: NSCollectionLayoutDimension = .fractionalWidth(0.5)
        if IS_iPad {
            itemWidth = .fractionalWidth(0.2)
        } else {
            if CCurrentDevice.orientation.isPortrait {
                itemWidth = .fractionalWidth(0.5)
            } else {
                itemWidth = .fractionalWidth(0.2)
            }
        }
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemWidth)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemWidth)
        var itemCount = 2
        if IS_iPad {
            itemCount = 5
        } else {
            if CCurrentDevice.orientation.isPortrait {
                itemCount = 2
            } else {
                itemCount = 5
            }
        }
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: itemCount)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK:- UICollectionView Delegate methods -
extension MediaVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let mediaPreviewVC = MediaPreviewVC.instantiateFrom(appStoryboard: .Main) {
            mediaPreviewVC.selectedIndex = indexPath.row
            self.navigationController?.pushViewController(mediaPreviewVC, animated: true)
        }
    }
}

// MARK:- Action events -
extension MediaVC {
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            mediaVM.populatePhotos(type: .Photo)
        } else {
            mediaVM.populatePhotos(type: .Video)
        }
    }
    
    @objc func reloadMedia() {
        mediaVM.populatePhotos(type: mediaVM.selectedMediaType)
    }
}
