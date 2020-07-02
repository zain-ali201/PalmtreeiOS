//
//  AdPostCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import TextFieldEffects
import DropDown
import NVActivityIndicatorView

protocol textFieldValueDelegate {
    func changeText(value: String, fieldTitle: String)
}

protocol PopupValueChangeDelegate {
    func changePopupValue(selectedKey: String, fieldTitle: String, selectedText : String, isBidSelected:Bool,IsPaySelected:Bool,isImageSelected:Bool,isShow:Bool)
}

class AdPostCell: UITableViewCell , UITextFieldDelegate {

    @IBOutlet weak var Hoshisample: HoshiTextField!{
        didSet {
            Hoshisample.delegate = self

            if let mainColor = defaults.string(forKey: "mainColor") {
//                txtType.borderActiveColor = Constants.hexStringToUIColor(hex: mainColor)
                
            }
        }
    }
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtType: UITextField! {
        didSet {
            txtType.delegate = self

            if let mainColor = defaults.string(forKey: "mainColor") {
//                txtType.borderActiveColor = Constants.hexStringToUIColor(hex: mainColor)
            
            }
        }
    }
    
     //MARK:- Properties
    var fieldName = ""
    var dataArray = [AdPostField]()
    var data = [AdPostField]()
    var currentIndex = 0
    var delegateText : textFieldValueDelegate?
    let defaults = UserDefaults.standard
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK:- Custom
    func setupView() {
        if defaults.bool(forKey: "isRtl") {
            txtType.textAlignment = .right
        }
    }
    
    //MARK:- IBActions
    @IBAction func textChange(_ sender: HoshiTextField) {
        if let text = sender.text {
            delegateText?.changeText(value: text, fieldTitle: fieldName)
        }
    }
     
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // get the current text, or use an empty string if that failed
       let currentText = textField.text ?? ""

       // attempt to read the range they are trying to change, or exit if we can't
       guard let stringRange = Range(range, in: currentText) else { return false }

       // add their new text to the existing text
       let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

       // make sure the result is under 16 characters
       return updatedText.count <= 100
   }
    
}

class AdPostPopupCell : UITableViewCell, NVActivityIndicatorViewable, SubCategoryDelegate {
 

    //MARK:- Outlets
    @IBOutlet weak var ViewCategories: UIView!
    @IBOutlet weak var oltPopup: UIButton! {
        didSet {
            oltPopup.setTitleColor(UIColor.darkGray, for: .normal)
//            ViewCategories.layer.cornerRadius = 4.0
//            ViewCategories.layer.borderWidth = 1.0
//            ViewCategories.layer.borderColor = UIColor.black.cgColor
//            ViewCategories.bounds = CGRect(x: 0, y: 0, width: 10, height: 10);
//            oltPopup.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,10)


        }
    }
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    
     //MARK:- Properties
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let selectionDropdown = DropDown()
    lazy var dropDowns : [DropDown] = { 
        return [
            self.selectionDropdown
        ]
    }()
    var dropDownKeysArray = [String]()
    var dropDownValuesArray = [String]()
    var hasCatTemplateArray = [Bool]()
    var hasTempelateArray = [Bool]()
    var hasSubArray = [Bool]()
    var btnPopUpAction: (()->())?
    var selectedValue = ""
    var selectedKey = ""
    var fieldName = ""
    var isBiddingArray = [Bool]()
    var isPayArray = [Bool]()
    var isImageArray = [Bool]()
    var isBidSelected = true
    var IsPaySelected = true
    var IsImageSelected = true
    var selectedId = ""
    
    var hasCatTempelate = false
    var hasTempelate = false
    var hasSub = false
    var fieldTypeName = ""
    var isShowArr = [Bool]()
    var isShow = true
    
    var dataArray = [AdPostField]()
    var appDel = UIApplication.shared.delegate as! AppDelegate
    var delegatePopup: PopupValueChangeDelegate?
      let defaults = UserDefaults.standard
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.setupView()
    }
   
    //MARK:- Custom
    func setupView() {
        if defaults.bool(forKey: "isRtl") {
            oltPopup.contentHorizontalAlignment = .right
        } else {
            oltPopup.contentHorizontalAlignment = .left
        }
    }
    
    //MARK:- SetUp Drop Down
    func popupShow() {
        selectionDropdown.anchorView = oltPopup
        selectionDropdown.dataSource = dropDownValuesArray
        selectionDropdown.selectionAction = { [unowned self]
            (index, item) in

//            self.oltPopup.setTitle(item, for: .normal)
//            self.selectedValue = item
//            self.selectedKey = self.dropDownKeysArray[index]
//            self.selectedValue = self.dropDownValuesArray[index]
//            self.hasTempelate = self.hasTempelateArray[index]
//            self.hasCatTempelate = self.hasCatTemplateArray[index]
           
            self.isShow = self.isShowArr[index]
            
            if self.fieldTypeName == "ad_cats1"{
                self.isBidSelected = self.isBiddingArray[index]
                self.IsPaySelected = self.isPayArray[index]
                self.IsImageSelected = self.isImageArray[index]
            }
            
            //UserDefaults.standard.set(self.isBidSelected, forKey: "isBidSelected")
            self.hasSub = self.hasSubArray[index]
            
            if self.IsPaySelected == false{
                let buy = self.defaults.string(forKey: "buy")
                let alert = Constants.showBasicAlert(message: buy!)
                self.window?.rootViewController?.presentVC(alert)
            }else{
        
                self.oltPopup.setTitle(item, for: .normal)
                self.selectedValue = item
                self.selectedKey = self.dropDownKeysArray[index]
                self.selectedValue = self.dropDownValuesArray[index]
                self.hasTempelate = self.hasTempelateArray[index]
                self.hasCatTempelate = self.hasCatTemplateArray[index]
                
                self.delegatePopup?.changePopupValue(selectedKey: self.selectedKey, fieldTitle: self.fieldName, selectedText: item, isBidSelected: self.isBidSelected,IsPaySelected:self.IsPaySelected,isImageSelected:self.IsImageSelected ,isShow:self.isShow)
                
                if self.hasCatTempelate {
                    if self.hasTempelate {
                        let param: [String: Any] = ["cat_id": self.selectedKey]
                        print(param)
                        self.dynamicFields(param: param as NSDictionary)
                    }
                }
                
                if self.hasSub {
                    let param: [String: Any] = ["subcat": self.selectedKey]
                    print(param)
                    self.subCategoryData(param: param as NSDictionary)
                }
            }
        }
    }
    
    //MARK:- Delegate Function
    func subCategoryDetails(name: String, id: Int, hasSubType: Bool, hasTempelate: Bool, hasCatTempelate: Bool)
    {
        print(name, id, hasSubType, hasTempelate, hasCatTempelate)
        if hasSubType
        {
            let param: [String: Any] = ["subcat": id]
            print(param)
            self.subCategoryData(param: param as NSDictionary)
        }
        else
        {
            self.oltPopup.setTitle(name, for: .normal)
            self.selectedKey = String(id)
            self.selectedValue = name
        }
        if hasCatTempelate
        {
            if hasTempelate
            {
                let param: [String: Any] = ["cat_id" : id]
                print(param)
                self.dynamicFields(param: param as NSDictionary)
            }
        }
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 1
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let maxLength = 5
      let currentString: NSString = textField.text! as NSString
      let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
      return newString.length <= maxLength
    }
    
     //MARK:- IBActions
    
    @IBAction func actionPopup(_ sender: Any) {
        self.btnPopUpAction?()
    }

    //MARK:- API Call
    
    func dynamicFields(param: NSDictionary)
    {
        let adPostVC = AadPostController()
        adPostVC.showLoader()
        AddsHandler.adPostDynamicFields(parameter: param, success: { (successResponse) in
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success
            {
                AddsHandler.sharedInstance.objAdPostData = successResponse.data.fields
                AddsHandler.sharedInstance.adPostImagesArray = successResponse.data.adImages
            }
            else
            {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDel.presentController(ShowVC: alert)
            }
            
            }) { (error) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDel.presentController(ShowVC: alert)
        }
    }
    
    // Sub category data
    func subCategoryData(param: NSDictionary)
    {
        let adPostVC = AadPostController()
        adPostVC.showLoader()
        AddsHandler.adPostSubcategory(parameter: param, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objSearchCategory = successResponse.data
                let seacrhCatVC = self.storyboard.instantiateViewController(withIdentifier: "SearchCategoryDetail") as! SearchCategoryDetail
                seacrhCatVC.dataArray = successResponse.data.values
                seacrhCatVC.modalPresentationStyle = .overCurrentContext
                seacrhCatVC.modalTransitionStyle = .crossDissolve
                seacrhCatVC.delegate = self
                self.appDel.presentController(ShowVC: seacrhCatVC)
              //UserDefaults.standard.set(successResponse.isBid, forKey: "isBid")
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDel.presentController(ShowVC: alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDel.presentController(ShowVC: alert)
        }
    }
}
