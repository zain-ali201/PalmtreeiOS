//
//  RadioColorAdCollectionViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 15/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class RadioColorAdCollectionViewCell: UICollectionViewCell {
    //MARK:- Outlets
    
    @IBOutlet weak var imgViewRadio: UIImageView!
    
    var dataArray = [AdPostValue]()
    var data : AdPostValue?
    var radioButtonCell: RadioColorAdTableViewCell!
    var indexPath = 0
    var id = ""
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectionStyle = .none
        
    }
    
    func initializeData(value: AdPostValue, radioButtonCellRef: RadioColorAdTableViewCell, index: Int) {
        data = value
        indexPath = index
        radioButtonCell = radioButtonCellRef
        // buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    
    
    func initCellItem() {
        
        let deselectedImage = UIImage(named: "empty (1)")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "radio-on-button")?.withRenderingMode(.alwaysTemplate)
        //buttonRadio.setImage(deselectedImage, for: .normal)
        //buttonRadio.setImage(selectedImage, for: .selected)
        // buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    
    //    @objc func radioButtonTapped(_ radioButton: UIButton) {
    //
    //        if (radioButtonCell.dataArray[indexPath].isSelected) {
    //            radioButton.backgroundColor = UIColor.clear //radioButton.tintColor
    //            //radioButton.layer.borderColor =  radioButton.tintColor.cgColor
    //            //  data?.isSelected = false
    //            radioButtonCell.dataArray[indexPath].isSelected = true
    //        }
    //        else {
    //            radioButton.backgroundColor = radioButton.backgroundColor
    //            radioButton.layer.borderColor  = radioButton.layer.borderColor
    //            radioButton.layer.cornerRadius = 13
    //            radioButtonCell.dataArray[indexPath].isSelected = false
    //            id = (radioButton.titleLabel?.text)!
    //        }
    //
    //        for (i, value) in radioButtonCell.dataArray.enumerated() {
    //            if i != indexPath {
    //                radioButtonCell.dataArray[i].isSelected = false
    //                radioButton.backgroundColor = UIColor.clear
    //
    //            }
    //             radioButtonCell.collectionView.reloadData()
    //        }
    //
    //    }
    
    
    func deselectOtherButton() {
        let tableView = self.superview?.superview as! UICollectionView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        let section = tappedCellIndexPath.section
        let rowCounts = tableView.numberOfItems(inSection: section)
        
        for row in 0..<rowCounts {
            if row != tappedCellIndexPath.row {
                let cell = tableView.cellForItem(at: IndexPath(row: row, section: section)) as! RadioColorCollectionViewCell
                //cell.buttonRadio.isSelected = false
            }
        }
    }
    
    
    
}
