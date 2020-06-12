//
//  SearchSectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 8/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown

class SearchSectionCell: UITableViewCell, UITextFieldDelegate,refreshdata {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!{
        didSet {
            txtSearch.delegate = self
        }
    }
    @IBOutlet weak var oltSearch: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var containerViewtextField: UIView! {
        didSet {
            containerViewtextField.roundCorners()
        }
    }
    @IBOutlet weak var containerViewSearch: UIView! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                containerViewSearch.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lineView: UIView! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lineView.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var btnLoc: UIButton!
    
    
    @IBOutlet weak var viewLoc: UIView!
    @IBOutlet weak var txtFielLoc: UITextField!
    
    @IBOutlet weak var btnLocN: UIButton!
    
    
    
    @IBOutlet weak var topConstraintSearch: NSLayoutConstraint!
    
    
    //MARK:- Properties
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let objData = AddsHandler.sharedInstance.topLocationArray
    
    let dropDown = DropDown()
    
    var dropDownArray = [String]()
    
    var dataCatLoc = [CatLocation]()
    var namelOC = ""
    
    var isLoc = false
    
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtSearch.textAlignment = .right
            lblTitle.textAlignment = .right
            lblSubTitle.textAlignment = .right
        } else {
            txtSearch.textAlignment = .left
            lblTitle.textAlignment = .left
            lblSubTitle.textAlignment = .left
        }
        
        viewLoc.roundCorners()
        nokri_dropDownSetup()
    
       // let lo = UserDefaults.standard.string(forKey: "selLoc")
        //txtFielLoc.text = lo
        
//        if isLoc == true{
//            viewLoc.isHidden = true
//            topConstraintSearch.constant -= 40
//        }
        
    }
    
  
    func tableRef(name: String) {
        namelOC = name
        txtFielLoc.text = namelOC
    }
    
    //MARK:- TextField Deletage
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearch {
            txtSearch.resignFirstResponder()
            categoryDetail()
        }
        return true
    }
    
    //MARK:- Custom
    func categoryDetail() {
        self.txtFielLoc.text = ""
        let id = UserDefaults.standard.integer(forKey: "locId")
        print(id)
        
        guard let searchText = txtSearch.text else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.searchText = searchText
        categoryVC.locId = id
        categoryVC.isFromTextSearch = true
        self.viewController()?.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- IBActions
    @IBAction func actionSearch(_ sender: UIButton) {
        categoryDetail()
    }
    
    @IBAction func btnLocClicked(_ sender: UIButton) {
//        let loginVC = storyboard.instantiateViewController(withIdentifier: SetLocationController.className) as! SetLocationController
//        let nav: UINavigationController = UINavigationController(rootViewController: loginVC)
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        
        //appDelegate.moveTosetLocationCtrl()
        
       // dropDown.show()
   
    }
    
    @IBAction func btnLocNcLICKED(_ sender: UIButton) {
       // dropDown.show()
        //appDelegate.moveTosetLocationCtrl()
         
         let loginVC = storyboard.instantiateViewController(withIdentifier: LocationHomeDetViewController.className) as! LocationHomeDetViewController
         loginVC.modalPresentationStyle = .overCurrentContext
         loginVC.modalTransitionStyle = .crossDissolve
         loginVC.modalPresentationStyle = .overFullScreen
         loginVC.dataArray = dataCatLoc
         loginVC.delegate = (self as! refreshdata)
         self.window?.rootViewController?.presentVC(loginVC)
        
    }
    
    
    func nokri_dropDownSetup(){
        
//        let mainColor = UserDefaults.standard.string(forKey: "mainColor")
        
        var dropDownArr = [String]()
        var dropDownArrKey = [String]()
        
        for key in objData{
            dropDownArrKey.append(key.locationId)
            dropDownArr.append(key.locationName)
        }
        
        let intArray = dropDownArrKey.map { Int($0)!}
        
        dropDown.dataSource = dropDownArr
        dropDown.reloadAllComponents()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            print(intArray[index])
            UserDefaults.standard.set(intArray[index], forKey: "locId")
            self.txtFielLoc.text = item
            //self.nokri_filterRecvdResume(filterKey: dropDownArrKey[index])
        }
        
        dropDown.anchorView = viewLoc
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 12)
        DropDown.appearance().backgroundColor = UIColor.white
        //DropDown.appearance().selectionBackgroundColor = UIColor(hex: mainColor!)
        DropDown.appearance().cellHeight = 40
        
    }
    
    
}
