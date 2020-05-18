//
//  RadioColorAdTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 15/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

protocol ColorRadioDelegateAdpost {
    func colorVal(colorCode: String, fieldType: String, indexPath: Int,isSelected: Bool, fieldNam:String)
}


class RadioColorAdTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Outlets

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Properties
    var dataArray = [AdPostValue]()
    var title = ""
    var id = ""
    var fieldName = ""
    //var delegate: ColorRadioDelegate?
    //var delegate:RangeNumberDelegate?
    var index = 0
    var selectedColor = ""
    var isselected = false
    var delegate : ColorRadioDelegateAdpost?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: RadioColorAdCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioColorAdCollectionViewCell", for: indexPath) as! RadioColorAdCollectionViewCell
    
        let objData = dataArray[indexPath.row]
        if objData.isChecked == true{
            cell.imgViewRadio.image = UIImage(named: "radio-on-button")
            cell.imgViewRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)

        }
        cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
        cell.imgViewRadio.tintColor = UIColor(hex: objData.id)
        cell.dataArray = dataArray
        id = cell.id
        print(objData.id)
        cell.reloadInputViews()
        cell.initializeData(value: objData, radioButtonCellRef: self, index: indexPath.row)
        
        return cell
        
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RadioColorAdCollectionViewCell
            print(dataArray[indexPath.row].id!)
            cell.imgViewRadio.image = UIImage(named: "radio-on-button")
            cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
            cell.imgViewRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)
            id = dataArray[indexPath.row].id
            selectedColor = dataArray[indexPath.row].id
            isselected = true
            self.delegate?.colorVal(colorCode: selectedColor, fieldType: "radio_color", indexPath: index, isSelected: true,fieldNam: fieldName)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(dataArray[indexPath.row].id!)
        let cell = collectionView.cellForItem(at: indexPath) as! RadioColorAdCollectionViewCell
        cell.imgViewRadio.image = UIImage(named: "empty (1)")
        cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
        cell.imgViewRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)
        id = dataArray[indexPath.row].id
    }

}

