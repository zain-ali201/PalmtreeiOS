//
//  AddsCollectionViewCell.swift
//  PalmTree
//
//  Created by SprintSols on 5/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblName.textAlignment = .right
        } else {
            lblName.textAlignment = .left
        }
        
    }
    
}
