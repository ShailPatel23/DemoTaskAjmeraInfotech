//
//  MediaVM.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import Foundation
import Photos

enum MediaType {
    
    case Photo
    case Video
    
    func getMediaType() -> PHAssetMediaType {
        
        switch self {
            
        case .Photo:
            return PHAssetMediaType.image
        case .Video :
            return PHAssetMediaType.video
        }
    }
}

final class MediaVM {
    
    static let shared = MediaVM()
    
    var arrMedia = [PHAsset]()
    var updateData: (() -> ())?
    var accessDenied: (() -> ())?
    var selectedMediaType: MediaType = .Photo
}

extension MediaVM {
    
    func populatePhotos(type: MediaType) {
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            guard let self = self else { return }
            
            if status == .authorized {
                
                let assets = PHAsset.fetchAssets(with: type.getMediaType(), options: nil)
                
                self.arrMedia.removeAll()
                self.selectedMediaType = type
                if assets.count == 0 {
                    self.updateData?()
                }
                assets.enumerateObjects { [weak self] object, _, _ in
                    
                    guard let self = self else { return }
                    
                    self.arrMedia.append(object)
                    self.updateData?()
                }
            } else if status == .denied || status == .restricted {
                CGCDMainThread.async {
                    
                    self.accessDenied?()
                }
            }
        }
    }
}
