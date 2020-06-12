//
//  AdpostradioInnerTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 12/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class AdpostradioInnerTableViewCell : UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var buttonRadio: UIButton!
    
    // var dataArray = [SearchValue]()
    var data : AdPostValue?
    var radioButtonCell: AdpostRadioTableViewCell!
    var indexPath = 0
    var seletedRadio = ""
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeData(value: AdPostValue, radioButtonCellRef: AdpostRadioTableViewCell, index: Int) {
        data = value
        indexPath = index
        radioButtonCell = radioButtonCellRef
        buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    func initCellItem() {
        let deselectedImage = UIImage(named: "uncheck")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
        buttonRadio.setImage(deselectedImage, for: .normal)
        buttonRadio.setImage(selectedImage, for: .selected)
        buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped(_ radioButton: UIButton) {
        
        if (radioButtonCell.dataArray[indexPath].isChecked) {
            buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
            //  data?.isSelected = false
            radioButtonCell.dataArray[indexPath].isChecked = false
            seletedRadio = (radioButton.titleLabel?.text)!
        }
        else {
            seletedRadio = (radioButton.titleLabel?.text!)!
            buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
            // data?.isSelected = true
            radioButtonCell.dataArray[indexPath].isChecked = true
        }
        
        for (i, value) in radioButtonCell.dataArray.enumerated() {
            if i != indexPath {
                radioButtonCell.dataArray[i].isChecked = false
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
