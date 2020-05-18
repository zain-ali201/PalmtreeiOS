//
//  BidsCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import TextFieldEffects

class BidsCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var lblShowMsg: UILabel! {
        didSet {
            lblShowMsg.isHidden = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.groupTableViewBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}


class PostBidCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
             containerView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    @IBOutlet weak var txtBid: HoshiTextField!
    @IBOutlet weak var txtComment: HoshiTextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var oltSubmit: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltSubmit.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    
    var btnSubmit: (()->())?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.groupTableViewBackground
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK:- IBActions
   
    @IBAction func actionSubmit(_ sender: Any) {
        self.btnSubmit?()
        print("Submit Pressed")
    }
    
}



