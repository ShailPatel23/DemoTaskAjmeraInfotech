//
//  MediaDetailView.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import UIKit
import Photos

final class MediaDetailView: UIView {

    // MARK:- IBOutlets -
    @IBOutlet private weak var lblFileName: UILabel!
    @IBOutlet private weak var lblCreationDate: UILabel!
    @IBOutlet private weak var lblFileSize: UILabel!
    
    // MARK:- Variables -
    var closeDetails: (() -> ())?
    
    // MARK:- Life cycle methods -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK:- Initialization -
extension MediaDetailView {
    
    func setDetails(asset: PHAsset) {
        
        lblFileName.text = "File Name: \(PHAssetResource.assetResources(for: asset).first?.originalFilename ?? "")"
        let sizeOnDisk: Int64 = Int64(bitPattern: PHAssetResource.assetResources(for: asset).first?.value(forKey: "fileSize") as! UInt64)
        lblFileSize.text = "File Size: \(converByteToHumanReadable(sizeOnDisk))"
        lblCreationDate.text = "Creation Date: \(asset.creationDate ?? Date())"
    }
}

// MARK:- Helper methods -
extension MediaDetailView {
 
    // For converting bytes to KB/MB
    func converByteToHumanReadable(_ bytes:Int64) -> String {
         let formatter:ByteCountFormatter = ByteCountFormatter()
         formatter.countStyle = .binary
         
         return formatter.string(fromByteCount: Int64(bytes))
     }
}

// MARK:- Action events -
extension MediaDetailView {
    
    @IBAction private func onCloseClicked(_ sender: UIButton) {
        closeDetails?()
    }
}
