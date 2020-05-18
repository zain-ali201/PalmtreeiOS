//
//  FeaturedAddsCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FeaturedAddsCell : UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblAddType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
}
