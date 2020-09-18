//
//  FavouriteCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SearchAlertTableCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAlertType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblProcess: UILabel!
    @IBOutlet weak var lblPromotion: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var promoteBtn: UIButton!
    
    var crossAction: (()->())?
    var locationAction: (()->())?
    var favouriteAction: (()->())?
    var editAdAction: (()->())?
    var promoteAdAction: (()->())?
    
    override func awakeFromNib()
    {

    }
    
    @IBAction func actionCancel(_ sender: Any)
    {
        crossAction?()
    }
    
    @IBAction func locationBtnAction(_ sender: Any)
    {
        locationAction?()
    }
    
    @IBAction func favnBtnAction(_ sender: Any)
    {
        favouriteAction?()
    }
    
    @IBAction func editBtnAction(_ sender: Any)
    {
        editAdAction?()
    }
    
    @IBAction func promoteBtnAction(_ sender: Any)
    {
        promoteAdAction?()
    }
}
