//
//  SearchTextField.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


protocol searchTextDelegate {
    func searchTextValue(searchText: String, fieldType: String, indexPath: Int,fieldTypeName:String)
}


class SearchTextField: UITableViewCell,UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var txtType: UITextField!
    
    var fieldName = ""
    var index = 0
    var delegate:searchTextDelegate?
    var fieldTypeNam = ""
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtType.textAlignment = .right
        } else {
            txtType.textAlignment = .left
        }
    
       
    }
    
    @IBAction func textEnd(_ sender: UITextField) {
        self.delegate?.searchTextValue(searchText: sender.text!, fieldType: "textfield", indexPath: index,fieldTypeName:fieldTypeNam)
    }
  
    
}
