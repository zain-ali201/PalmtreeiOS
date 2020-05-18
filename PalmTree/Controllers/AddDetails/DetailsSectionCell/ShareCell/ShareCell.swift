//
//  ShareCell.swift
//  PalmTree
//
//  Created by SprintSols on 3/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ShareCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var containerViewBell: UIView!{
        didSet{
            containerViewBell.layer.borderWidth = 0.5
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                containerViewBell.layer.borderColor = Constants.hexStringToUIColor(hex: mainColor).cgColor
            }
        }
    }
    @IBOutlet weak var imgBell: UIImageView! {
        didSet{
            imgBell.isHidden = true
        }
    }
    
    @IBOutlet weak var lblType: UILabel! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblType.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var imgLookAdd: UIImageView!
    @IBOutlet weak var lblLookAdd: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var containerViewButton: UIView!
    
    @IBOutlet weak var lblShareOrig: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblReport: UILabel!
    @IBOutlet weak var buttonShare: UIButton!{
        didSet{
            buttonShare.layer.borderWidth = 0.5
            buttonShare.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var buttonFavourite: UIButton! {
        didSet {
            buttonFavourite.titleLabel?.minimumScaleFactor = 0.5
            buttonFavourite.titleLabel?.numberOfLines = 0
            buttonFavourite.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonFavourite.layer.borderWidth = 0.5
            buttonFavourite.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var buttonReport: UIButton! {
        didSet{
            buttonReport.layer.borderWidth = 0.5
            buttonReport.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var containerViewEdit: UIView! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                containerViewEdit.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
            containerViewEdit.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var oltEdit: UIButton!
    
    @IBOutlet weak var imgEdit: UIImageView! {
        didSet {
            imgEdit.tintImageColor(color: UIColor.white)
        }
    }
    
    
    //MARK:- Properties
    var btnFavouriteAdd: (()->())?
    var btnReport: (()->())?
    var btnShare: (()->())?
    var btnEdit: (()->())?
    
    //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblShare.textAlignment = .right
            lblReport.textAlignment = .right
            lblShareOrig.textAlignment = .right
        }else{
            lblShare.textAlignment = .left
            lblReport.textAlignment = .left
            lblShareOrig.textAlignment = .left
        }
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        self.btnShare?()
    }
    
    @IBAction func actionFavourite(_ sender: UIButton) {
        self.btnFavouriteAdd?()
    }
    
    @IBAction func actionReport(_ sender: UIButton) {
        self.btnReport?()
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        self.btnEdit?()
    }
    
    
}
