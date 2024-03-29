//
//  AddsCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var favBtn: UIButton! 
    //MARK:- Properties
    var btnFullAction: (()->())?
    var favBtnAction: (()->())?
    
    var  imageView: UIImageView!
    var  imageViewLoc: UIImageView!
    var lblTitle: UILabel!
    var lblLocs: UILabel!
    var lblPriceHori: UILabel!
    var lblBidTimer: UILabel!
    //MARK:- IBActions
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    @IBAction func favBtnAction(_ sender: Any) {
        self.favBtnAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if languageCode == "ar"
        {
            lblName.textAlignment = .right
        }
        
    }
    
}
