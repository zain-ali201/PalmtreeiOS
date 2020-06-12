//
//  CategoryCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                self.lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var lblFeature: UILabel!
    
}
