//
//  CategoriesCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgContainer: UIView! {
        didSet {
            imgContainer.layer.borderWidth = 0.5
            imgContainer.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    var btnFullAction: (()->())?
    
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
