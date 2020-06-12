//
//  BidOnOffCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/30/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown

class BidOnOffCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var oltPopup: UIButton!
    
    
    //MARK:- Properties
    var btnPopUpAction : (()->())?
   
    let bidOnOffDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.bidOnOffDropDown
        ]
    }()
    
    var dropDownDataArray = [String]()
    var selectedValue = ""
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    //MARK:- SetUp Drop Down
    func bidOnOff() {
        bidOnOffDropDown.anchorView = oltPopup
        bidOnOffDropDown.dataSource = dropDownDataArray
        bidOnOffDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.oltPopup.setTitle(item, for: .normal)
            self.selectedValue = item
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionPopup(_ sender: Any) {
        bidOnOffDropDown.show()
        self.btnPopUpAction?()
    }
}
