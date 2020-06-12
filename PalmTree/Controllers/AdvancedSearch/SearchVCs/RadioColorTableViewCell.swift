//
//  RadioColorTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 31/01/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

protocol ColorRadioDelegate {
    func colorValue(colorCode: String, fieldType: String, indexPath: Int, fieldTypeNam: String)
}


class RadioColorTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    var dataArray = [SearchValue]()
    var title = ""
    var id = ""
    var fieldName = ""
    var delegate: ColorRadioDelegate?
    //var delegate:RangeNumberDelegate?
    var index = 0
    var fieldTypeName = ""
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: RadioColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioColorCollectionViewCell", for: indexPath) as! RadioColorCollectionViewCell
        
        let objData = dataArray[indexPath.row]
        cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
        cell.imgViewRadio.tintColor = UIColor(hex: objData.id!)

        cell.dataArray = dataArray
        id = cell.id
        
        print(objData.id)
        cell.reloadInputViews()
        cell.initializeData(value: objData, radioButtonCellRef: self, index: indexPath.row)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RadioColorCollectionViewCell
        
       let objData = dataArray[indexPath.row]
       //cell.imgViewRadio.backgroundColor = UIColor(hex: objData.id)
       cell.imgViewRadio.image = UIImage(named: "radio-on-button")
       cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
       cell.imgViewRadio.tintColor = UIColor(hex: objData.id!)
       id = objData.id
        self.delegate?.colorValue(colorCode: objData.id, fieldType: "radio_color", indexPath: index,fieldTypeNam : fieldTypeName)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as!
        RadioColorCollectionViewCell
        let objData = dataArray[indexPath.row]
        cell.imgViewRadio.image = UIImage(named: "empty (1)")
        cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
        cell.imgViewRadio.tintColor = UIColor(hex: objData.id!)
    }
}

