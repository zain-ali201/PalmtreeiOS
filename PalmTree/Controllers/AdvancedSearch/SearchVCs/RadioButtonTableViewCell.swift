//
//  RadioButtonTableViewCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit



class RadioButtonTableViewCell : UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var buttonRadio: UIButton!
    
    // var dataArray = [SearchValue]()
    var data : SearchValue?
    var radioButtonCell: RadioButtonCell!
    var indexPath = 0
    var index = 0
    var radText = ""
   
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func initializeData(value: SearchValue, radioButtonCellRef: RadioButtonCell, index: Int) {
        data = value
        indexPath = index
        radioButtonCell = radioButtonCellRef
        buttonRadio.titleLabel?.text = radioButtonCell.dataArray[index].id
        buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    func initCellItem() {
        let deselectedImage = UIImage(named: "empty (1)")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "radio-on-button")?.withRenderingMode(.alwaysTemplate)
        buttonRadio.setImage(deselectedImage, for: .normal)
        buttonRadio.setImage(selectedImage, for: .selected)
        buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped(_ radioButton: UIButton) {
        if (radioButtonCell.dataArray[indexPath].isSelected) {
            buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
            //self.delegate?.radioValue(radioVal: (radioButton.titleLabel?.text)!, fieldType: "radio", indexPath: index)
            //  data?.isSelected= false
            print("Text Button is:\(radioButton.titleLabel?.text)")
            radioButtonCell.dataArray[indexPath].isSelected = false
           
            UserDefaults.standard.set(radioButton.titleLabel?.text, forKey: "rad")
            radText = (radioButton.titleLabel?.text)!
            
        }
        else {
            print("Text Button is:\(radioButton.titleLabel?.text)")
            UserDefaults.standard.set(radioButton.titleLabel?.text, forKey: "rad")
            radText = (radioButton.titleLabel?.text)!
            buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
            // data?.isSelected = true
            radioButtonCell.dataArray[indexPath].isSelected = true
        }
        
        for (i, value) in radioButtonCell.dataArray.enumerated() {
            if i != indexPath {
                radioButtonCell.dataArray[i].isSelected = false
            }
        }
        radioButtonCell.tableView.reloadData()
    }
    
    func deselectOtherButton() {
        let tableView = self.superview?.superview as! UITableView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        let section = tappedCellIndexPath.section
        let rowCounts = tableView.numberOfRows(inSection: section)
        
        for row in 0..<rowCounts {
            if row != tappedCellIndexPath.row {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! RadioButtonTableViewCell
                cell.buttonRadio.isSelected = false
            }
        }
    }
}
