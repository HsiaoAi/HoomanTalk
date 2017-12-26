//
//  FSAlbumViewCell.swift
//  Fusuma
//
//  Created by Yuta Akizuki on 2015/11/14.
//  Copyright © 2015年 ytakzk. All rights reserved.
//

import UIKit
import Photos

final class FSAlbumViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedLayer = CALayer()
    
    var image: UIImage? {
        
        didSet {
            
            self.imageView.image = image            
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.isSelected = false
        
        selectedLayer.borderColor = UIColor(red: 255 / 255, green: 94 / 255, blue: 89 / 255, alpha: 1).cgColor
        
        selectedLayer.borderWidth = 1.2
        
    }
    
    override var isSelected : Bool {
        
        didSet {

            if selectedLayer.superlayer == self.layer {

                selectedLayer.removeFromSuperlayer()
            }
            
            if isSelected {

                selectedLayer.frame = self.bounds
                self.layer.addSublayer(selectedLayer)
            }
        }
    }
    
}
