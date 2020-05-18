//
//  PublicProfileCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PublicProfileCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    
    
    
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                self.lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
}
