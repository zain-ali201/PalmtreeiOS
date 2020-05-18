//
//  AdRatingCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos
import TextFieldEffects
import NVActivityIndicatorView
import UITextField_Shake

class AdRatingCell: UITableViewCell, NVActivityIndicatorViewable {

    //MARK:- Outlets
    
    @IBOutlet weak var lblSectionTagline: UILabel!
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ratingBar: CosmosView! {
        didSet {
            ratingBar.settings.updateOnTouch = true
            ratingBar.settings.fillMode = .full
            ratingBar.didTouchCosmos = didTouchCosmos
            ratingBar.didFinishTouchingCosmos = didFinishTouchingCosmos
            ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
        }
    }
    @IBOutlet weak var txtComment: HoshiTextField! {
        didSet{
            if let mainColor = defaults.string(forKey: "mainColor") {
                txtComment.borderActiveColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblNotEdit: UILabel!
    @IBOutlet weak var oltSubmitRating: UIButton!{
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltSubmitRating.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblPostComment: UILabel!
    
    //MARK:- Properties
    
    var btnSubmitAction: (()->())?
    var rating: Double = 0
    var adID = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.setupView()
    }
    
    //MARK:- Custom
    
    func setupView() {
        if defaults.bool(forKey: "isRtl") {
            txtComment.textAlignment = .right
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionSubmitRating(_ sender: Any) {
        self.btnSubmitAction?()
    }
    
    private func didTouchCosmos(_ rating: Double) {
        print("Start \(rating)")
        self.rating = rating
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        print("End \(rating)")
        self.rating = rating
    }
}
