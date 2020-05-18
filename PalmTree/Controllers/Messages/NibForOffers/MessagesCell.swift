//
//  MessagesCell.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
           containerView.addShadowToView()        
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgBell: UIImageView! {
        didSet {
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
