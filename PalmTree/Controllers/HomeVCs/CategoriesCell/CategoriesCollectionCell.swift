//
//  CategoriesCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgContainer: UIView!
    var btnFullAction: (()->())?
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
