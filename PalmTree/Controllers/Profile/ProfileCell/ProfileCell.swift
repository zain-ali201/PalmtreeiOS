//
//  ProfileCell.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos

class ProfileCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var btnGoogle: UIButton!
    
    @IBOutlet weak var btnLinkedIn: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblLastlogin: UILabel!
    @IBOutlet weak var containerViewEditProfile: UIView!
    @IBOutlet weak var buttonEditProfile: UIButton! {
        didSet {
            buttonEditProfile.contentHorizontalAlignment = .left
            
        }
    }
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var lblAvgRating: UILabel!
    
    //MARK:- Properties
    var actionEdit: (()->())?
    var ratingCosmos : (() -> ())?
    var dataArraySocial  = [SellersSocialIcon]()
    var btnUrlvalue = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionEditProfile(_ sender: Any) {
        actionEdit?()
    }
    func didTouchCosmos(_ rating: Double) {
        ratingCosmos?()
        print("Rating Clicked")
    }
    
    func didFinishTouchingCosmos(_ rating: Double) {
        
        print("Rating Clicked is That")
    }
    
    
}
