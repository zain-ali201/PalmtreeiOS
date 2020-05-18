//
//  ReplyCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos

class ReplyCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var oltReply: UIButton!
    @IBOutlet weak var ratingBar: CosmosView! 
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReply: UILabel!
   
    
    //MARK:- Properties
    var btnReplyAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       selectionStyle = .none
    }

    
    //MARK:- IBActions
    
    @IBAction func actionReply(_ sender: Any) {
        self.btnReplyAction?()
    }
    
}
