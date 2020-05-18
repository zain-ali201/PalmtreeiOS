//
//  RejectedAdsCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class RejectedAdsCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var oltEdit: UIButton!
    
    //MARK:- Properties
    var btnEdit: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    //MARK:- IBActions
    @IBAction func actionEdit(_ sender: UIButton) {
        btnEdit?()
    }
}
