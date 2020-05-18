//
//  LeftMenuCell.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
