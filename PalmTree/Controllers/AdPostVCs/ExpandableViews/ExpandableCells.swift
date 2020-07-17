//
//  ExpandableCells.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 7..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit
import ExpandableCell

class ExpandableCell2: ExpandableCell {
    static let ID = "ExpandableCell"
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgView: UIImageView!
}

class ExpandedCell: UITableViewCell {
    static let ID = "ExpandedCell"
    
    var catID = 0
    var adCategory = ""
    var subcatID = 0
    @IBOutlet var lblName: UILabel!
}

