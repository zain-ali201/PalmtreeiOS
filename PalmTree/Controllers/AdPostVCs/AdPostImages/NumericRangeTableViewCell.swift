//
//  NumericRangeTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 15/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class NumericRangeTableViewCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMinPrice: UITextField!
    
    //MARK:- Properties
    //var delegate: RangeNumberDelegate?
    var index = 0
    var minimumValue = ""
    var fieldName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 30.0, width: txtMinPrice.frame.size.width + 28, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        txtMinPrice.layer.addSublayer(bottomBorder)
        
    }

}
