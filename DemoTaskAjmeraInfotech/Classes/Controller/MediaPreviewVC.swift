//
//  MediaPreviewVC.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import UIKit
import Photos
import AVKit

final class MediaPreviewVC: UIViewController {
    
    // MARK:- IBOutlets -
    @IBOutlet private weak var collVMedia: UICollectionView!
    
    // MARK:- Variables -
    var mediaVM = MediaVM.shared
    var selectedIndex = 0
    lazy private var dataSource = UICollectionViewDiffableDataSource<Int, PHAsset>(collectionView: collVMedia) { (collectionView, index, item) -> UICollectionViewCell? in
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollVCell.identifier, for: index) as? MediaCollVCell {
            
            let manager = PHImageManager.default()
            
            manager.requestImage(for: item, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: nil) { image, _ in
                                
                cell.imgVMedia.image = image
                cell.setupMedia()
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }

    // MARK:- Life cycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
}

// MARK:- Initialization -
extension MediaPreviewVC {
    
    private func initialization() {
        
        if mediaVM.selectedMediaType == .Video {
            
            // For getting AVAsset from PHAsset
            PHCachingImageManager().requestAVAsset(forVideo: mediaVM.arrMedia[selectedIndex], options: nil) { video, _, _ in
                
                let asset = video as! AVURLAsset
                let player = AVPlayer(url: asset.url)
                
                CGCDMainThread.async { [weak self] in
                        
                    guard let self = self else { return }
                    
                    // For playing the video
                    let avPlayerController = AVPlayerViewController()
                    avPlayerController.player = player
                    
                    avPlayerController.view.frame = self.view.frame
                    
                    self.addChild(avPlayerController)
                    self.view.addSubview(avPlayerController.view)
                    avPlayerController.player?.play()
                }
            }
        } else {
            
            setupNavigation()
            collVMedia.register(MediaCollVCell.nib, forCellWithReuseIdentifier: MediaCollVCell.identifier)
            collVMedia.collectionViewLayout = createCompositionalLayout()
            createSnapshot(items: mediaVM.arrMedia)
            CGCDMainThread.async { [weak self] in
                
                guard let self = self else { return }
                self.collVMedia.scrollToItem(at: IndexPath(item: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private func setupNavigation() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(onDetailsClicked))
    }
    
    private func createSnapshot(items: [PHAsset]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, PHAsset>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let inset: CGFloat = 0
                
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        
        return layout
    }
}

// MARK:- Action events -
extension MediaPreviewVC {
    
    @objc private func onDetailsClicked() {
        
        // For opening and closing details view with animation
        if let mediaDetailView = Bundle.main.loadNibNamed("MediaDetailView", owner: nil, options: nil)?.last as? MediaDetailView {
            
            let visibleRect = CGRect(origin: collVMedia.contentOffset, size: collVMedia.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = collVMedia.indexPathForItem(at: visiblePoint)
            let popupHeight = CGFloat(CScreenHeight - 88)
            mediaDetailView.removeFromSuperview()
            mediaDetailView.frame = CGRect(x: 0, y: self.view.frame.maxY + 100, width: CScreenWidth, height: popupHeight)
            self.view.addSubview(mediaDetailView)
            mediaDetailView.setDetails(asset: mediaVM.arrMedia[visibleIndexPath?.row ?? 0])
            UIView.animate(withDuration: 0.3, animations: {
                mediaDetailView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: popupHeight)
            }) { (completion) in
            }
            
            mediaDetailView.closeDetails = {
                
                UIView.animate(withDuration: 0.3, animations: {
                    mediaDetailView.frame = CGRect(x: 0, y: self.view.frame.maxY + 100, width: CScreenWidth, height: popupHeight)
                }) { (completion) in
                    mediaDetailView.removeFromSuperview()
                }
            }
        }
    }
}
