//
//  CustomHeader.swift
//  PalmTree
//
//  Created by SprintSols on 11/22/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown

protocol CustomHeaderParameterDelegate {
    func paramData(param: NSDictionary)
}


class CustomHeader: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTotalAds: UILabel!
    @IBOutlet weak var oltOrder: UIButton!{
        didSet {
            oltOrder.contentHorizontalAlignment = .right
        }
    }
    @IBOutlet weak var imgIcon: UIImageView!
    
    //MARK:- Properties
    var delegate: CustomHeaderParameterDelegate?
    var btnSort: (()->())?
    var orderArray = [String]()
    var orderKeysArray = [String]()
    var arrangeDropDown = DropDown()
    lazy var dropDown : [DropDown] = {
        return [
            self.arrangeDropDown
        ]
    }()
    
    var categoryID = 0
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    //MARK:- Custom
    func orderDropDown() {
        arrangeDropDown.anchorView = imgIcon
        arrangeDropDown.dataSource = orderArray
        print(orderArray)
        arrangeDropDown.selectionAction = { [unowned self] (index, item) in
            self.oltOrder.setTitle(item, for: .normal)
            let sortKey = self.orderKeysArray[index]
            let param: [String: Any] = ["ad_cats1" : self.categoryID, "page_number": 1, "sort": sortKey]
            print(param)
            self.delegate?.paramData(param: param as NSDictionary)
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionOrder(_ sender: UIButton) {
        self.btnSort?()
    }
}
