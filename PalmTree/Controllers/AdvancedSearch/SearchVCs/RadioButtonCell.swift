//
//  RadioButtonCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit



protocol radioDelegate {
    func radioValue(radioVal: String, fieldType: String, indexPath: Int,fieldName:String)
}

class RadioButtonCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    //MARK:- Properties
    var dataArray = [SearchValue]()
    var fieldNam = ""
    var delegate : radioDelegate?
    var index = 0
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadioButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonTableViewCell", for: indexPath) as! RadioButtonTableViewCell
        let objData = dataArray[indexPath.row]
        if let title = objData.name {
            cell.lblName.text = title
        }
        print(objData.isSelected, indexPath.row)
        //cell.delegate = self
        if objData.isSelected {
            cell.buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
        }else {
            cell.buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
        }
         delegate?.radioValue(radioVal:cell.radText , fieldType: "radio", indexPath: index,fieldName: fieldNam)
        cell.initializeData(value: objData, radioButtonCellRef: self, index: indexPath.row)
        //cell.initCellItem()
        return cell
    }
}
