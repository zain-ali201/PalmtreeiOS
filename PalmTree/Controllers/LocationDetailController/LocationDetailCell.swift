//
//  LocationDetailCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class LocationDetailCell: UICollectionViewCell {
   
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var smallView: UIView!{
        didSet{
            smallView.addShadowToView()
        }
    }
    @IBOutlet weak var imgContainer: UIView!{
        didSet {
            imgContainer.addShadowToView()
            imgContainer.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAds: UILabel!
    
    
}
