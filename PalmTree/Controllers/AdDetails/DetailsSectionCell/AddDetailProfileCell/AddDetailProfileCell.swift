//
//  AddDetailProfileCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos

class AddDetailProfileCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblLastLogin: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var oltCoverButton: UIButton!
    @IBOutlet weak var oltBlockButton: UIButton!
    
    
    //MARK:- Properties
    var btnCoverAction : (()->())?
    var btnBlock: (()->())?
    var btnUserProfileAction: (()->())?
    let defaults = UserDefaults.standard
    
    //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Custom
    func setupView() {
        if defaults.bool(forKey: "isRtl") {
            lblLastLogin.textAlignment = .right
        }
    }
    
    
    //MARK:- IBActions
    @IBAction func coverButtonAction(_ sender: Any) {
        self.btnCoverAction?()
    }
    
    @IBAction func actionDelete(_ sender: UIButton) {
        self.btnBlock?()
    }
    @IBAction func actionUserRating(_ sender: Any) {
        self.btnUserProfileAction?()
    }
    
    
    
}
