//
//  SearchDropDown.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DropDown



protocol selectValue {
    func selectValue(selectVal: String,selectKey:String, fieldType: String, indexPath: Int,fieldTypeName: String)
    
}

class SearchDropDown: UITableViewCell, NVActivityIndicatorViewable , SubCategoryDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var oltPopup: UIButton!
    
    //MARK:- Properties
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var dropDownKeysArray = [String]()
    var dropDownValuesArray = [String]()
    var fieldTypeName = [String]()
    var hasSubArray = [Bool]()
    var hasTemplateArray = [Bool]()
    var hasCategoryTempelateArray = [Bool]()
     var delegate : selectValue?
    var fieldNam = ""
    var index = 0
    
    var btnPopupAction : (()->())?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let valueDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.valueDropDown
        ]
    }()
    
    var selectedKey = ""
    var selectedValue = ""
    var param = ""
    var fieldName = ""
    var hasSub = false
    var hasTempelate = false
    var hasCategoryTempelate = false
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    //MARK:- SetUp Drop Down
    func accountDropDown() {
        valueDropDown.anchorView = oltPopup
        valueDropDown.dataSource = dropDownValuesArray
        valueDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.oltPopup.setTitle(item, for: .normal)
            self.selectedKey = self.dropDownKeysArray[index]
            self.selectedValue = item
            self.param = self.fieldTypeName[index]
            print(self.param)
            self.hasSub = self.hasSubArray[index]
            self.hasTempelate = self.hasTemplateArray[index]
            self.hasCategoryTempelate = self.hasCategoryTempelateArray[index]
    
            if self.hasCategoryTempelate {
                if self.hasTempelate {
                    let param: [String: Any] = ["cat_id" : self.selectedKey]
                    print(param)
                    self.dynamicSearch(param: param as NSDictionary)
                }
                self.delegate?.selectValue(selectVal: self.selectedValue, selectKey: self.selectedKey, fieldType: "select", indexPath: index, fieldTypeName: self.fieldNam)
            }
            
            if self.hasSub {
                if self.param == "ad_country" {
                    let url = Constants.URL.baseUrl+Constants.URL.categorySublocations
                    print(url)
                    let param: [String: Any] = ["ad_country": self.selectedKey]
                    self.subCategory(url: url, param: param as NSDictionary)
                     self.delegate?.selectValue(selectVal: "", selectKey: self.selectedKey, fieldType: "select", indexPath: index, fieldTypeName: self.fieldNam)
                }
                else {
                      
                    let param: [String: Any] = ["subcat": self.selectedKey]
                    print(param)
                    let url = Constants.URL.baseUrl+Constants.URL.subCategory
                    print(url)
                    self.subCategory(url: url, param: param as NSDictionary)
                    //self.selectedValue
                    self.delegate?.selectValue(selectVal: self.selectedKey, selectKey: self.selectedKey, fieldType: "select", indexPath: index, fieldTypeName: self.fieldNam)
                }
            }
        }
    }
    
    //MARK:- Delegate Method
    
    func subCategoryDetails(name: String, id: Int, hasSubType: Bool, hasTempelate: Bool, hasCatTempelate: Bool) {
        print(name, id, hasSubType, hasTempelate, hasCatTempelate)
        if hasSubType {
            if self.param == "ad_country" {
                let url = Constants.URL.baseUrl+Constants.URL.categorySublocations
                print(url)
                let param: [String: Any] = ["ad_country": id]
                print(param)
                self.subCategory(url: url, param: param as NSDictionary)
                 self.delegate?.selectValue(selectVal: "", selectKey: self.selectedKey, fieldType: "select", indexPath: index, fieldTypeName: self.fieldNam)
            }
            else {
                let param: [String: Any] = ["subcat": id]
                print(param)
                let url = Constants.URL.baseUrl+Constants.URL.subCategory
                print(url)
                self.selectedKey = String(id)
                self.subCategory(url: url, param: param as NSDictionary)
                oltPopup.setTitle(name, for: .normal)
                self.selectedKey = String(id)
                self.selectedValue = name
                 self.delegate?.selectValue(selectVal: self.selectedKey, selectKey: self.selectedKey, fieldType: "select", indexPath: index, fieldTypeName: self.fieldNam)
            
            }
        }
        else {
            oltPopup.setTitle(name, for: .normal)
            self.selectedKey = String(id)
            self.selectedValue = name
            self.delegate?.selectValue(selectVal: String(id), selectKey: self.selectedKey, fieldType: "select", indexPath: index, fieldTypeName: self.fieldNam)
        }
    }
    
    @IBAction func actionPopup(_ sender: Any) {
        self.btnPopupAction?()
    }
    
    //MARK:- API Call
    func subCategory(url: String ,param: NSDictionary) {
        let searchObj = AdvancedSearchController()
        searchObj.showLoader()
        AddsHandler.subCategory(url: url, parameter: param, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objSearchCategory = successResponse.data
                let seacrhCatVC = self.storyboard.instantiateViewController(withIdentifier: "SearchCategoryDetail") as! SearchCategoryDetail
                
                seacrhCatVC.dataArray = successResponse.data.values
                seacrhCatVC.modalPresentationStyle = .overCurrentContext
                seacrhCatVC.modalTransitionStyle = .crossDissolve
                seacrhCatVC.delegate = self
                self.appDel.presentController(ShowVC: seacrhCatVC)
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
    
    //Dynamic Search
    func dynamicSearch(param: NSDictionary) {
        let searchObj = AdvancedSearchController()
        searchObj.showLoader()
        AddsHandler.dynamicSearch(parameter: param, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objSearchArray = successResponse.data
                AddsHandler.sharedInstance.objSearchData = successResponse.data
                NotificationCenter.default.post(name:NSNotification.Name(Constants.NotificationName.searchDynamicData), object: nil)
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
