//
//  SearchTwoTextField.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

//protocol searchTextTwoDelegate {
//    func searchTextValueTwo(searchTextTwo: String, fieldType: String, indexPath: Int)
//}

class SearchTwoTextField: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var txtMinPrice: UITextField!
    @IBOutlet weak var txtmaxPrice: UITextField!
    @IBOutlet weak var lblMin: UILabel!
    
    //MARK:- Properties
    
    var fieldName = ""
    var index = 0
    //var delegate:searchTextTwoDelegate?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func txtEditingEnd(_ sender: UITextField) {
      
        var minTF = ""
        var maxTF = ""
        
        if sender.tag == 0{
            minTF = sender.text!
        }
        
        if sender.tag == 1{
            maxTF = sender.text!
        }
        let rangeTF = minTF + "-" + maxTF
        //self.delegate?.searchTextValueTwo(searchTextTwo: rangeTF, fieldType: "range_textfield", indexPath: index)
    }
    
}
