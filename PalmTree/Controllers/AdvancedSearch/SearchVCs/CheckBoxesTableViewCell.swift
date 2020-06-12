//
//  CheckBoxesTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 30/01/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SwiftCheckboxDialog




class CheckBoxesTableViewCell: UITableViewCell {

    
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var btnCheckBox: UIButton!
//
//    // var dataArray = [SearchValue]()
//    var data : SearchValue?
//    var radioButtonCell: CheckBoxButtonCell!
//    var indexPath = 0
//    var tagArr = [Int]()
//    let defaults = UserDefaults.standard
//    var delegateCheckArr : checkBoxesValues?
//
//
//    var dataArray = [SearchValue]()
//    var title = ""
//
//    var checkboxDialogViewController: CheckboxDialogViewController!
//    typealias TranslationTuple = (name: String, translated: String)
//    typealias TranslationDictionary = [String : String]
//
//
//    //MARK:- View Life Cycle
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.selectionStyle = .none
//    }
//
//    func initializeData(value: SearchValue, radioButtonCellRef: CheckBoxButtonCell, index: Int) {
//        data = value
//        indexPath = index
//        radioButtonCell = radioButtonCellRef
//        btnCheckBox.tag = index
//        btnCheckBox.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
//    }
//
//    func initCellItem() {
//        let deselectedImage = UIImage(named: "uncheck")?.withRenderingMode(.alwaysTemplate)
//        let selectedImage = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
//        btnCheckBox.setImage(deselectedImage, for: .normal)
//        btnCheckBox.setImage(selectedImage, for: .selected)
//        btnCheckBox.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
//    }
//
//    @objc func radioButtonTapped(_ radioButton: UIButton) {
//
//        nokri_multiCheckBoxData()
//
//
//    }
//
//    func deselectOtherButton() {
//        let tableView = self.superview?.superview as! UITableView
//        let tappedCellIndexPath = tableView.indexPath(for: self)!
//        let section = tappedCellIndexPath.section
//        let rowCounts = tableView.numberOfRows(inSection: section)
//
//        for row in 0..<rowCounts {
//            if row != tappedCellIndexPath.row {
//                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! RadioButtonTableViewCell
//                cell.buttonRadio.isSelected = false
//            }
//        }
//  }
//
//    var checkBoxArr = [String]()
//    var arrCheckValue = [String]()
//
//    func nokri_multiCheckBoxData(){
//
//           // var tableData :[(name: String, translated: String)]?
//            var jobData = [(name: String, translated: String)]();
//            let jobSkill = self.dataArray
//
//            for itemDict in jobSkill {
//                jobData.append((name: "\(itemDict.name!)", translated: "\(itemDict.name!)"))
//
//            }
//
//            print (jobData)
//            self.checkboxDialogViewController = CheckboxDialogViewController()
//            self.checkboxDialogViewController.titleDialog = title
//            self.checkboxDialogViewController.tableData = jobData
//            self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.countries
//            self.checkboxDialogViewController.delegateDialogTableView = self
//            self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//
//           self.window?.rootViewController?.presentVC(checkboxDialogViewController)
//
//        }
//
//
//    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
//
//            var allselectedString : String = "";
//            print(values.keys)
//
//            for value in values.values {
//                print("\(value)");
//                checkBoxArr.append(value)
//            }
//        print(checkBoxArr)
//        let countedSet = NSCountedSet(array: checkBoxArr)
//        let uniques = checkBoxArr.filter { countedSet.count(for: $0) == 1 }
//        print(uniques)
//        arrCheckValue = uniques
//        delegateCheckArr?.checkBoxArrFunc(selectedText:arrCheckValue, fieldType: <#String#>)
//
//        }
    
    
    
}
