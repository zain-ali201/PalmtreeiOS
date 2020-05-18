//
//  AboutAppCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AboutAppCell: UITableViewCell {

    
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    
}
