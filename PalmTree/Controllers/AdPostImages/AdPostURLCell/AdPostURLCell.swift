//
//  AdPostURLCell.swift
//  PalmTree
//
//  Created by SprintSols on 8/28/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AdPostURLCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var txtUrl: UITextField!
    
    
    //MARK:- Properties
    var fieldName = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
