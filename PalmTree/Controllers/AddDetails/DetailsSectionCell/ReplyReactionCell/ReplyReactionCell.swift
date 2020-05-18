//
//  ReplyReactionCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/19/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Cosmos

class ReplyReactionCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.round()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var oltReply: UIButton!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var imgWow: UIImageView!
    @IBOutlet weak var imgAndry: UIImageView!
    @IBOutlet weak var lblThumb: UILabel!
    @IBOutlet weak var lblHeart: UILabel!
    @IBOutlet weak var lblWow: UILabel!
    @IBOutlet weak var lblSad: UILabel!
    
    //MARK:- Properties
    var btnReplyAction : (()->())?
    var btnThumb: (()->())?
    var btnLove: (()->())?
    var btnWow: (()->())?
    var btnSad: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    //MARK:- IBActions
    @IBAction func actionReply(_ sender: UIButton) {
        self.btnReplyAction?()
    }
    
    @IBAction func actionThumb(_ sender: UIButton) {
        btnThumb?()
    }
    
    @IBAction func actionLove(_ sender: UIButton) {
        btnLove?()
    }
    
    @IBAction func actionWow(_ sender: UIButton) {
        btnWow?()
    }
    
    @IBAction func actionSad(_ sender: UIButton) {
        btnSad?()
    }
}
