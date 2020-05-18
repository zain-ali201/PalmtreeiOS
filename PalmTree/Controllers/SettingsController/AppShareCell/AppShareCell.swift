//
//  AppShareCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AppShareCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
