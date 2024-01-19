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

enum ImageType {
    
    case Jpg
    case Jpeg
    case Heic
    case all
    
    func getImageType() -> String {
        
        switch self {
            
        case .Jpg:
            return "jpg"
        case .Jpeg:
            return "jpeg"
        case .Heic:
            return "HEIC"
        case .all:
            return ""
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
    
    func populatePhotos(type: MediaType, imageType: ImageType = .all) {
        
        // For requesting authorization of photo library
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            guard let self = self else { return }
            
            if status == .authorized {
                
                let options = PHFetchOptions()
                options.predicate = NSPredicate(format: "mediaType = %d", type.getMediaType().rawValue)
                
                let fetchResult = PHAsset.fetchAssets(with: options)
                
                self.arrMedia.removeAll()
                self.selectedMediaType = type
                if fetchResult.count == 0 {
                    self.updateData?()
                }
                fetchResult.enumerateObjects { (asset, _, _) in
                    let resources = PHAssetResource.assetResources(for: asset)
                    
                    for resource in resources {
                        // Get the file format of the asset
                        if let fileExtension = resource.originalFilename.split(separator: ".").last {
                            let format = String(fileExtension)

                            // Check if the file format matches the desired format
                            switch imageType {
                            case .Jpg, .Jpeg, .Heic:
                                if format == imageType.getImageType() {
                                    self.arrMedia.append(asset)
                                }
                            case .all:
                                self.arrMedia.append(asset)
                            }
                            self.updateData?()
                        }
                    }
                }
            } else if status == .denied || status == .restricted {
                
                CGCDMainThread.async {
                    
                    self.accessDenied?()
                }
            }
        }
    }
}
