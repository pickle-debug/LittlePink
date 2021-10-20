//
//  PhotoFooter.swift
//  LittlePink
//
//  Created by 何纪栋 on 2021/10/16.
//

import UIKit

class PhotoFooter: UICollectionReusableView {
        
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addPhotoBtn.layer.borderWidth = 1
        addPhotoBtn.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
}
