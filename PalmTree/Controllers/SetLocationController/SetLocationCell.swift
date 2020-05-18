//
//  SetLocationCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/16/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class SetLocationCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    
    //MARK:- life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .default
    }
}
