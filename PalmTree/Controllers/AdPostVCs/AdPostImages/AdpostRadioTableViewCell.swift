//
//  AdpostRadioTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 12/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


protocol radioDelegateAdpost {
    func radVal(rVal: String, fieldType: String, indexPath: Int,isSelected: Bool,fieldNam:String)
}

class AdpostRadioTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    var seletedRad = ""
    var fieldName = ""
    
    
    //MARK:- Properties
    var dataArray = [AdPostValue]()
    var index = 0
    var section = 0
    var delegate : radioDelegateAdpost?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AdpostradioInnerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdpostradioInnerTableViewCell", for: indexPath) as! AdpostradioInnerTableViewCell
        let objData = dataArray[indexPath.row]
        if let title = objData.name {
            cell.lblName.text = title
            cell.buttonRadio.titleLabel?.text = title
        }
        //print(objData.isSelected, indexPath.row)
        
        if objData.isChecked {
            cell.buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
            cell.buttonRadio.isSelected = true
            delegate?.radVal(rVal: seletedRad, fieldType: "radio", indexPath: index, isSelected: objData.isChecked,fieldNam:fieldName)
        }else {
            cell.buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
        }
        seletedRad = cell.seletedRadio
        cell.initializeData(value: objData, radioButtonCellRef: self, index: indexPath.row)
        
        return cell
    }
}
