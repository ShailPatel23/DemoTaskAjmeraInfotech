//
//  MediaCollVCell.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import UIKit

final class MediaCollVCell: UICollectionViewCell {
    
    // MARK:- IBOutlets -
    @IBOutlet weak var imgVMedia: UIImageView!
    
    // MARK:- Life cycle methods -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK:- Initialization -
extension MediaCollVCell {
    
    func setupMedia() {
        imgVMedia.contentMode = .scaleAspectFit
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        imgVMedia.addGestureRecognizer(pinchGesture)
    }
}

// MARK:- Action events -
extension MediaCollVCell {
    
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        
        if let view = gesture.view {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        }
    }
}
