//
//  MyAdsCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown

class MyAdsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var lblAddType: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var containerViewAddType: UIView!
    @IBOutlet weak var buttonAddType: UIButton! {
        didSet {
            buttonAddType.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var imgEdit: UIImageView!{
        didSet {
            imgEdit.tintImageColor(color: UIColor.lightGray)
        }
    }
    @IBOutlet weak var buttonEdit: UIButton! {
        didSet{
            buttonEdit.layer.borderWidth = 0.5
            buttonEdit.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var imgDelete: UIImageView!{
        didSet{
            imgDelete.tintImageColor(color: UIColor.lightGray)
        }
    }
    @IBOutlet weak var buttonDelete: UIButton!{
        didSet{
            buttonDelete.layer.borderWidth = 0.5
            buttonDelete.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    //MARK:- Properties
//    var delegate : selectedPopUpValueProtocol?
    var dropDownDataArray = [String]()
    var showDropDown: (() -> ())?
    var actionEdit: (()->())?
    var actionDelete: (()->())?
    
    
    var addTypeDropDown = DropDown()
    lazy var dropDown : [DropDown] = {
        return [
            self.addTypeDropDown
        ]
    }()
    
    var defaults = UserDefaults.standard
    var settingObject = [String: Any]()
    var popUpMsg = ""
    var popUpText = ""
    var popUpCancelButton = ""
    var popUpOkButton = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK:- Custom
    
    func selectCategory()
    {
        addTypeDropDown.anchorView = buttonAddType
        addTypeDropDown.dataSource = dropDownDataArray
        
        addTypeDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonAddType.setTitle(item, for: .normal)
            //send data to main class in alert controller action
            let alert = UIAlertController(title: self.popUpMsg, message: self.popUpText, preferredStyle: .alert)
            let okAction = UIAlertAction(title: self.popUpOkButton, style: .default, handler: { (okAction) in
//                self.delegate?.addStatus(status: item)
            })
            let cancelAction = UIAlertAction(title: self.popUpCancelButton, style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.appDelegate.presentController(ShowVC: alert)
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func actionAddType(_ sender: Any) {
        showDropDown?()
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        actionEdit?()
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        actionDelete?()
    }
}




