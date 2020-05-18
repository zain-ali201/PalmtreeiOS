//
//  FavouriteCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FavouriteCollectionCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblAddType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    
    //MARK:- Properties
    
    var crossAction: (()->())?
    
    //MARK:- IBOutlets
    @IBAction func actionCancel(_ sender: Any) {
        crossAction?()
    }
}
