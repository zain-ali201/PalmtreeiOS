//
//  AddsStatusCell.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddsStatusCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblSoldAds: UILabel!
    
    @IBOutlet weak var lblAllAds: UILabel!
    @IBOutlet weak var lblInactiveAds: UILabel!
    
    @IBOutlet weak var lblExpireAds: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
