//
//  AadPostController.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AadPostController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource, textFieldValueDelegate, PopupValueChangeDelegate {
   
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = UIColor.black
            tableView.showsVerticalScrollIndicator = false
            //tableView.register(UINib(nibName: <#T##String#>, bundle: <#T##Bundle?#>), forCellReuseIdentifier: <#T##String#>)
        }
    }
    
    
    //MARK:- Properties
    var isFromEditAd = false
    var ad_id = 0
    var catID = ""
    var dataArray = [AdPostField]()
    var newArray = [AdPostField]()
    var imagesArray = [AdPostImageArray]()
    var dynamicArray = [AdPostField]()
    var hasPageNumber = ""
    var refreshArray = [AdPostField]()
    var imageIDArray = [Int]()
    var data = [AdPostField]()
    let defaults = UserDefaults.standard
    var isBidding = true
    var isPaid = true
    var isImage = true
    var isCatTempOn = false
    //var idBiddingDefault = true
    var selectOption = ""
    var id = ""
    var value = ""
    
    // Empty Fields Check
    var adTitle = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.forwardButton()
        self.googleAnalytics(controllerName: "Add Post Controller")
        if isFromEditAd
        {
            let param: [String: Any] = ["is_update": ad_id]
            print(param)
            self.adPost(param: param as NSDictionary)
        }
        else
        {
            let param: [String: Any] = ["is_update": ""]
            print(param)
            self.adPost(param: param as NSDictionary)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserDefaults.standard.set(true, forKey: "isBid")
        UserDefaults.standard.set("0", forKey: "is")
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func forwardButton() {
        let button = UIButton(type: .custom)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        }
        if defaults.bool(forKey: "isRtl") {
            button.setBackgroundImage(#imageLiteral(resourceName: "backbutton"), for: .normal)
        } else {
                button.setBackgroundImage(#imageLiteral(resourceName: "forwardButton"), for: .normal)
        }
//        button.addTarget(self, action: #selector(onForwardButtonClciked), for: .touchUpInside)
        let forwardBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = forwardBarButton
    }
    
    func changeText(value: String, fieldTitle: String) {
        for index in 0..<dataArray.count {
            if let objData = dataArray[index] as? AdPostField {
                if objData.fieldType == "textfield" {
                    if let cell  = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostCell {
                        var obj = AdPostField()
                        obj.fieldVal = value
                        obj.fieldTypeName = cell.fieldName
                        obj.fieldType = "textfield"
                        data.append(obj)
                        if fieldTitle == self.dataArray[index].fieldTypeName {
                             self.dataArray[index].fieldVal = value
                        }
                    }
                }
            }
        }
    }
    
    func changePopupValue(selectedKey: String, fieldTitle: String, selectedText: String,isBidSelected:Bool,IsPaySelected:Bool,isImageSelected:Bool,isShow:Bool) {
        print(selectedKey, fieldTitle, selectedText,isBidSelected,IsPaySelected,isImageSelected)
        isBidding = isBidSelected
        isPaid = IsPaySelected
        isImage = isImageSelected
        id = selectedKey
        for index in 0..<dataArray.count {
            if let objData = dataArray[index] as? AdPostField {
                if objData.fieldType == "select" {
                    if let cell  = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostPopupCell {
                        var obj = AdPostField()
                        obj.fieldVal = selectedKey
                        obj.fieldTypeName = fieldTitle
                        obj.fieldType = "select"
                        data.append(obj)
                        
//                        if obj.fieldTypeName == "ad_price_type" {
//                            if id == "on_call"{
//                                if let cell  = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TextFieldCell {
//                                   if isShow == false{
//
//                                    cell.isHidden = true
//                                    print(id)
//                                    //                                if fieldTitle == "ad_currency" {
//                                    //                                cell.lblType.isHidden = true
//                                    //                                cell.oltPopup.isHidden = true
//
//                                    //                                }
//                                    }
//                                }
//
//                            }
//                        }
                        
                        if fieldTitle == self.dataArray[index].fieldTypeName {
                            self.dataArray[index].fieldVal = selectedText
                            cell.oltPopup.setTitle(selectedText, for: .normal)
                        }
                    }
                }
                
                
                
//                if objData.fieldType == "select" {
                    if let cell  = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TextFieldCell {
                        if objData.fieldTypeName == "ad_price_type"{
                        
                            if isShow == false{
                                print("IamHere")
                                 cell.isHidden = true
                            }
                        }
                        
//                    }
                }
                
                
            }
        }
    }
  
    @IBAction func onForwardButtonClciked(_ sender: Any)
    {
        var option = ""
        
        var data = [AdPostField]()
        for index in  0..<dataArray.count {
            if let objData = dataArray[index] as? AdPostField {
                if objData.fieldType == "textfield" {
                    if let cell  = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostCell {
                        var obj = AdPostField()
                        obj.fieldVal = cell.txtType.text
                        obj.fieldTypeName = cell.fieldName
                        obj.fieldType = "textfield"
                        data.append(obj)
                        guard let txtTitle = cell.txtType.text else {return}
                        if cell.fieldName == "ad_title" {
                            if txtTitle == "" {
                                cell.txtType.shake(6, withDelta: 10, speed: 0.06)
                            }else {
                                self.adTitle = txtTitle
                            }
                        }
                        if cell.fieldName == "ad_price" {
                            if txtTitle == "" {
                                cell.txtType.shake(6, withDelta: 10, speed: 0.06)
                            }else {
                                self.adTitle = txtTitle
                            }
                        }
                    }
                }
                else if objData.fieldType == "select"
                {
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostPopupCell {
                        var obj = AdPostField()
                        obj.fieldVal = cell.selectedKey
                        obj.fieldTypeName = cell.fieldName
                        obj.fieldType = "select"
                        value = cell.selectedKey
                        print(obj.fieldVal, obj.fieldTypeName, obj.fieldType)
                        data.append(obj)
                        print(selectOption)
                        option = obj.fieldVal
                       if obj.fieldTypeName == "ad_type" {
                           //index == 7 &&
                           if option == "" {
                               value = cell.oltPopup.currentTitle!
                               cell.oltPopup.titleLabel?.textColor = UIColor.red
                               cell.oltPopup.shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])

                           }
                       }

//                        if id == ""{
//                            print("No..")
//                            value = cell.oltPopup.currentTitle!
//                            cell.oltPopup.titleLabel?.textColor = UIColor.red
//
//                        }else{
//                            print("Yes..")
//                            cell.oltPopup.titleLabel?.textColor = UIColor.gray
//                        }
                        
                    }
                }
            }
        }
        
//        ||  id == ""
        if self.adTitle == "" || option == "" {
             
        }
        else {
            let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
            if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                self.refreshArray = dataArray
                self.refreshArray.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                postVC.fieldsArray = self.refreshArray
                postVC.objArray = data
                postVC.isfromEditAd = self.isFromEditAd
            }
            else {
                postVC.objArray = data
                postVC.fieldsArray = self.dataArray
                postVC.isfromEditAd = self.isFromEditAd
            }
            postVC.imageArray = self.imagesArray
            postVC.imageIDArray = self.imageIDArray
            postVC.isBid = self.isBidding
            postVC.isImg = self.isImage
            
            self.navigationController?.pushViewController(postVC, animated: true)
        }
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasPageNumber == "1" {
            return dataArray.count
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = dataArray[indexPath.row]
        
        if objData.fieldType == "textfield"  && objData.hasPageNumber == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdPostCell", for: indexPath) as! AdPostCell
            if let title = objData.title  {
                cell.txtType.placeholder = title
            }
            if let fieldValue = objData.fieldVal {
                cell.txtType.text = fieldValue
            }
            cell.fieldName = objData.fieldTypeName
            
            cell.delegateText = self
            return cell
        }
        else if objData.fieldType == "select" && objData.hasPageNumber == "1"  {
            let cell: AdPostPopupCell = tableView.dequeueReusableCell(withIdentifier: "AdPostPopupCell", for: indexPath) as! AdPostPopupCell
            
            if let title = objData.title {
                cell.lblType.text = title
            }
            
//            if let fieldValue = objData.fieldVal {
//                cell.oltPopup.setTitle(fieldValue, for: .normal)
//            }
            var i = 1
            for item in objData.values {
                if item.id == "" {
                    continue
                }
                if i == 1 {
                    if cell.selectedValue == ""{
                        cell.oltPopup.setTitle(objData.values[0].name, for: .normal)
                        value = objData.values[0].name
                                            }else{
                        cell.oltPopup.setTitle(cell.selectedValue, for: .normal)
                        //cell.oltPopup.setTitle(item.name, for: .normal)
                        cell.selectedKey = String(item.id)
                        value = objData.values[0].name
                        
                    }
                    id = objData.values[0].id
                   // cell.oltPopup.setTitle(item.name, for: .normal)
                   // cell.selectedKey = String(item.id)
                }
                i = i + 1
            }
            
            cell.btnPopUpAction = { () in
                cell.dropDownKeysArray = []
                cell.dropDownValuesArray = []
                cell.hasCatTemplateArray = []
                cell.hasTempelateArray = []
                cell.hasSubArray = []
                for items in objData.values {
                    if items.id == "" {
                        continue
                    }
                    cell.dropDownKeysArray.append(String(items.id))
                    cell.dropDownValuesArray.append(items.name)
                    cell.hasCatTemplateArray.append(objData.hasCatTemplate)
                    cell.hasTempelateArray.append(items.hasTemplate)
                    cell.hasSubArray.append(items.hasSub)
                    self.id = items.id

                    if objData.fieldTypeName == "ad_cats1"
                    {
                        cell.isBiddingArray.append(items.isBid)
                        cell.isPayArray.append(items.isPay)
                        cell.isImageArray.append(items.isImg)
                        cell.fieldTypeName = objData.fieldTypeName
                    }
                    
                     cell.isShowArr.append(items.isShow)
                   
                }
                cell.popupShow()
                cell.selectionDropdown.show()
            }
            cell.fieldName = objData.fieldTypeName
            cell.delegatePopup = self
            
            return cell
        }
        return UITableViewCell()
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let objData = dataArray[indexPath.row]
        if objData.fieldType == "textfield" {
            height = 60
        }
        else if objData.fieldType == "select" {
            height = 80
        }
        return height
    }
    
    //MARK:- API Calls
    func adPost(param: NSDictionary)
    {
        print(param)
        self.showLoader()
        AddsHandler.adPost(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.title
                self.isCatTempOn = successResponse.data.catTemplateOn
                AddsHandler.sharedInstance.isCategoeyTempelateOn = successResponse.data.catTemplateOn
                //this ad id send in parameter in 3rd step
                AddsHandler.sharedInstance.adPostAdId = successResponse.data.adId
                AddsHandler.sharedInstance.objAdPost = successResponse
                //Fields
                self.dataArray = successResponse.data.fields
                self.newArray = successResponse.data.fields
                self.imagesArray = successResponse.data.adImages
                for imageId in self.imagesArray {
                    if imageId.imgId == nil {
                        continue
                    }
                    self.imageIDArray.append(imageId.imgId)
                }
                for item in successResponse.data.fields {
                    if item.hasPageNumber == "1" {
                        self.hasPageNumber = item.hasPageNumber
                    }
                }
                
                //get category id to get dynamic fields
                if let cat_id = successResponse.data.adCatId {
                    self.catID = String(cat_id)
                }
                if self.isCatTempOn == true{
                    if successResponse.data.adCatId != nil {
                        let param: [String: Any] = ["cat_id": self.catID,
                                                    "ad_id": self.ad_id
                        ]
                        print(param)
                        self.dynamicFields(param: param as NSDictionary)
                    }
                }
                else
                {
                    print("Not Called...")
                }
                
                UserDefaults.standard.set(successResponse.extra.dialgCancel, forKey: "dialgCancel")
                UserDefaults.standard.set(successResponse.extra.dialogSend, forKey: "dialogSend")
                
                self.tableView.reloadData() 
            }
            else
            {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                  self.navigationController?.popViewController(animated: true)
                })
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // Dynamic Fields
    func dynamicFields(param: NSDictionary) {
       self.showLoader()
        AddsHandler.adPostDynamicFields(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objAdPostData = successResponse.data.fields
                AddsHandler.sharedInstance.adPostImagesArray = successResponse.data.adImages
                //self.isBidding = successResponse.isBid
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
             //self.isBidding = successResponse.isBid
            
//            if successResponse.isBid == true{
//                 UserDefaults.standard.set(true, forKey: "isBid")
//            }else{
//                UserDefaults.standard.set(false, forKey: "isBid")
//            }
            
             //UserDefaults.standard.set(successResponse.isBid, forKey: "isBid")
            
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

}
extension UIView {


    // Using CAMediaTimingFunction
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        // Swift 4.1 and below
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)


        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        self.layer.add(animation, forKey: "shake")
    }


    // Using SpringWithDamping
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)

    }


    // Using CABasicAnimation
    func shake(duration: TimeInterval = 0.05, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - xValue, y: self.center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + xValue, y: self.center.y - yValue))
        self.layer.add(animation, forKey: "shake")
    }

}
