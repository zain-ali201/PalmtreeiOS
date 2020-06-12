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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAlertType: UILabel!
    @IBOutlet weak var alertIcon: UIImageView!
}
