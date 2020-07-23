//
//  AdPostImagesController.swift
//  PalmTree
//
//  Created by SprintSols on 4/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Photos
import NVActivityIndicatorView
import Alamofire
import OpalImagePicker
import UITextField_Shake
import JGProgressHUD

class AdPostImagesController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, OpalImagePickerControllerDelegate, UINavigationControllerDelegate, textFieldValueDelegate,UIImagePickerControllerDelegate,imagesCount {
 
    
   //textViewValueDelegate
  
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.register(UINib(nibName: "AdPostURLCell", bundle: nil), forCellReuseIdentifier: "AdPostURLCell")
            tableView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
        }
    }
    
    //MARK:- Properties
    
    private lazy var uploadingProgressBar: JGProgressHUD = {
        let progressBar = JGProgressHUD(style: .dark)
        progressBar.indicatorView = JGProgressHUDRingIndicatorView()
        progressBar.textLabel.text = "Uploading"
        return progressBar
    }()
    var isDragAdpost : Bool = false
    var UiImagesArrAdpost = [UIImage]()
    var imageUrl:URL?
    var imgIdDrag = [Int]()
    var photoArray = [UIImage]()
   
    var imageArray = [AdPostImageArray]()
    var imgCtrlCount = 0
    
    var fieldsArray = [AdPostField]()
    var data = [AdPostImageArray]()
    var adID = 0
    var imageIDArray = [Int]()
    //this array get data from previous controller
    var objArray = [AdPostField]()
    var customArray = [AdPostField]()
    var haspageNumber = ""
    var localArray = AddsHandler.sharedInstance.objAdPostData
    var dataArray = [AdPostField]()
    var valueArray = [String]()
    var maximumImagesAllowed = 0
    var localVariable = ""
    var localDictionary = [String: Any]()
    var isfromEditAd = false
    let defaults = UserDefaults.standard
    
    var isFromAddData = ""
    var popUpTitle = ""
    var selectedIndex = 0
    
    var isValidUrl = false
    var isBid = true
    var isImg = true
    var imagesMsg = ""
    var isShowPrice = true
    var isImagesRequired = "true"
    var isEditStart  = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.hideKeyboard()
        self.forwardButton()
        self.populateData()
//        self.imgeCount(count: imgCtrlCount)
        print(imgCtrlCount)
        for ite in objArray {
            print(ite.fieldTypeName, ite.fieldName, ite.fieldVal, ite.fieldType)
        }
        self.dataArray = fieldsArray
        
        let valuesArray = ["ad_title","ad_cats1" ,"ad_price_type", "ad_price", "ad_currency", "ad_condition", "ad_warranty", "ad_type", "ad_yvideo", "checkbox"]
        let valueToremove = ["ad_title","ad_cats1"]
        
        for item in dataArray {
            if AddsHandler.sharedInstance.isCategoeyTempelateOn ==  false {
                if valuesArray.contains(item.fieldTypeName) {
                    let value = item.fieldTypeName
                    let index = dataArray.index{ $0.fieldTypeName ==  value}
                    if let index = index {
                        dataArray.remove(at: index)
                    }
                }
            }
            else {
                if valueToremove.contains(item.fieldTypeName) {
                    let value = item.fieldTypeName
                    let index = dataArray.index{ $0.fieldTypeName ==  value}
                    if let index = index {
                        dataArray.remove(at: index)
                    }
                }
            }
        }
        fieldsArray = dataArray
        self.populateData()
        self.tableView.reloadData()
//        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
//        self.tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print(imageArray.count)
      

//        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

        button.addTarget(self, action: #selector(onForwardButtonClciked), for: .touchUpInside)
        
        let forwardBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = forwardBarButton
    }
    
    func changeText(value: String, fieldTitle: String) {
        for index in 0..<dataArray.count {
            if let objData = dataArray[index] as? AdPostField {
                if objData.fieldType == "textfield" {
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? TextFieldCell {
                        var obj = AdPostField()
                        obj.fieldType = "textfield"
                        obj.fieldVal = value
                        obj.fieldTypeName = cell.fieldName
                        objArray.append(obj)
                        customArray.append(obj)
                        
                        if fieldTitle == self.dataArray[index].fieldTypeName {
                            self.dataArray[index].fieldVal = value
                        }
                    }
                }
            }
        }
    }

//    func changeTextViewCharacters(value: String, fieldTitle: String) {
//        for index in 0..<dataArray.count {
//            if let objData = dataArray[index] as? AdPostField {
//                if objData.fieldType == "textarea" {
//                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? DescriptionTableCell {
//                        cell.delegate = self
//                        var obj = AdPostField()
//                        obj.fieldType = "textarea"
//                        obj.fieldVal = value
//                        print(value)
//                        cell.txtDescription.text! = value
//                        obj.fieldTypeName = "ad_desc" //fieldTitle
//                        objArray.append(obj)
//                        customArray.append(obj)
//
//                        if fieldTitle == self.dataArray[index].fieldTypeName {
//                            self.dataArray[index].fieldVal = value
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    @IBAction func onForwardButtonClciked(_ sender: Any) {

        localVariable = ""
        for index in  0..<fieldsArray.count {
            if let objData = fieldsArray[index] as? AdPostField {
                if objData.fieldType == "select"  {
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? DropDownCell {
                        var obj = AdPostField()
                        obj.fieldType = "select"
                        obj.fieldTypeName = cell.param
                        print(cell.param)
                        obj.fieldVal = cell.selectedKey
                        objArray.append(obj)
                        customArray.append(obj)
                    }
                }
                 if objData.fieldType == "textfield"  {
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? TextFieldCell {
                            var obj = AdPostField()
                            obj.fieldType = "textfield"
                            obj.fieldVal = cell.txtType.text
                            obj.fieldTypeName = cell.fieldName
                            objArray.append(obj)
                            customArray.append(obj)
                    }
                }
//                else if objData.fieldType == "textarea" {
//                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? DescriptionTableCell {
//                        var obj = AdPostField()
//                        obj.fieldType = "textarea"
//                        obj.fieldVal = cell.txtDescription.text!
//                        print(cell.txtDescription.text!)
//                        obj.fieldTypeName = "ad_description"
//                        objArray.append(obj)
//                        //dataArray.app
//                        customArray.append(obj)
//                    }
//                }
                else if objData.fieldType == "checkbox" {
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? CheckBoxCell {
                        var obj = AdPostField()
                        obj.fieldTypeName = cell.fieldName
                        objArray.append(obj)
                        customArray.append(obj)
                        localVariable = ""
                        for item in cell.valueArray {
                            localVariable += item + ","
                        }
                        self.localDictionary[cell.fieldName] = localVariable
                    }
                }
                else if objData.fieldType == "textfield_url" {
                    if let cell: AdPostURLCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? AdPostURLCell {
                        var obj = AdPostField()
                        obj.fieldTypeName = cell.fieldName
                        guard let txtUrl = cell.txtUrl.text else {return}
                        if txtUrl.isValidURL {
                            obj.fieldVal = txtUrl
                            self.isValidUrl = true
                        } else {
                            cell.txtUrl.shake(6, withDelta: 10, speed: 0.06)
                            self.isValidUrl = false
                        }
                        objArray.append(obj)
                        customArray.append(obj)
                    }
                }
//                else if objData.fieldType == "textfield_date" {
//                    if let cell: CalenderSingleTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? CalenderSingleTableViewCell {
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "date_input" //cell.fieldName
//                        obj.fieldVal = "\(cell.currentDate)"
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
//                else if objData.fieldType == "radio_color" {
//                    if let cell: RadioColorAdTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? RadioColorAdTableViewCell {
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "select_colors" //cell.fieldName
//                        print(cell.selectedColor)
//                        obj.fieldVal = cell.selectedColor
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
//                else if objData.fieldType == "textfield_number" {
//                    if let cell: NumericRangeTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as?  NumericRangeTableViewCell{
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "number_range" //cell.fieldName
//                        obj.fieldVal = cell.txtMinPrice.text
//                        print(cell.txtMinPrice.text!)
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
                
//                else if objData.fieldType == "radio" {
//                    if let cell: AdpostRadioTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as?  AdpostRadioTableViewCell{
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "radio" //cell.fieldName
//                        obj.fieldVal = cell.seletedRad
//                        print( cell.seletedRad)
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
                    
                    
                else if objData.fieldType == "textfield_number" {
                    if let cell: NumericRangeTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as?  NumericRangeTableViewCell{
                        var obj = AdPostField()
                        obj.fieldTypeName = "number_range" //cell.fieldName
                        obj.fieldVal = cell.txtMinPrice.text
                        objArray.append(obj)
                        customArray.append(obj)
                    }
                }
            }
        }
        let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostMapController") as! AdPostMapController
//        if imageIDArray.isEmpty {
//            let alert = Constants.showBasicAlert(message: "Images Required")
//            self.presentVC(alert)
//        }
//        else if isValidUrl == false {
//            
//        }
       // else {
        if isDragAdpost == true{
            adPostVC.imageIdArray = imgIdDrag
        }else{
            adPostVC.imageIdArray = imageIDArray
        }
//            adPostVC.imageIdArray = imageIDArray
            adPostVC.objArray = objArray
            adPostVC.customArray = self.customArray
            print(self.customArray)
            adPostVC.localVariable = self.localVariable
            adPostVC.valueArray = self.valueArray
            adPostVC.localDictionary = self.localDictionary
        
        let objData = AddsHandler.sharedInstance.objAdPost
        if self.isImagesRequired == objData?.data.images.isRequired{
    
            let msgImg = UserDefaults.standard.string(forKey: "ImgReqMessage")
            if imgCtrlCount == 0{
                let alert = Constants.showBasicAlert(message: msgImg!)
                self.presentVC(alert)
            }
        else{
                self.navigationController?.pushViewController(adPostVC, animated: true)

            }
            
        }
            else{
                self.navigationController?.pushViewController(adPostVC, animated: true)
            }
    }
    
    func populateData() {
        if  AddsHandler.sharedInstance.objAdPost != nil {
            let objData = AddsHandler.sharedInstance.objAdPost
            if let titleText = objData?.data.title {
                self.title = titleText
            }
            if let id = objData?.data.adId {
                self.adID = id
            }
            if let maximumImages = objData?.data.images.numbers {
                self.maximumImagesAllowed = maximumImages
            }
            
        }
    }

    func imgeCount(count: Int) {
        imgCtrlCount = count
//        self.tableView.reloadData()
     }
    //MARK:- Add Data Delegate
    /*
    func addToFieldsArray(obj: AdPostField, index: Int) {
        fieldsArray.insert(obj, at: index)
        self.tableView.reloadData()
    }
   
    func addToFieldsArray(obj: AdPostField, index: Int, isFrom: String, title: String) {
        if isFrom == "textfield" {
            fieldsArray.insert(obj, at: index)
            self.tableView.reloadData()
        }
        else if isFrom == "select" {
            self.selectedIndex = index
            fieldsArray.insert(obj, at: index)
        }
    }
    */
    
    //MARK:- table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if section == 0 {
            returnValue =  1
        }
        else if section == 1 {
              returnValue =  1
        }
        else if section == 2 {
            returnValue = fieldsArray.count
        }
      return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        
        //var isB = UserDefaults.standard.bool(forKey: "isBid")
        
        if section == 0 {
            let cell: UploadImageCell = tableView.dequeueReusableCell(withIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell

            
//            if isImg == false{
//                cell.isHidden = true
//            }else{
//                cell.isHidden = false
//            }
            

            let objData = AddsHandler.sharedInstance.objAdPost
        
            if let imagesTitle = objData?.extra.imageText {
                cell.lblSelectImages.text = imagesTitle
            }
            
            cell.lblPicNumber.text = String(imgCtrlCount)
//            print(imgCtrlCount)
            cell.btnUploadImage = { () in
            
                if self.maximumImagesAllowed == 0{
                    let msgImg = UserDefaults.standard.string(forKey: "imgMsg")
                    let alert = Constants.showBasicAlert(message: msgImg!)
                    self.presentVC(alert)
                }
                else{
                    let select = UserDefaults.standard.string(forKey: "select")
                    let camera = UserDefaults.standard.string(forKey: "camera")
                    let cameraNotAvailable = UserDefaults.standard.string(forKey: "cameraNotAvavilable")
                    
                    let actionSheet = UIAlertController(title: "select", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                                   actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (action) -> Void in
                                       let imagePickerConroller = UIImagePickerController()
                                       imagePickerConroller.delegate = self
                                       if UIImagePickerController.isSourceTypeAvailable(.camera){
                                           imagePickerConroller.sourceType = .camera
                                       }else{
                                        let al = UserDefaults.standard.string(forKey: "aler")
                                            let ok = UserDefaults.standard.string(forKey: "okbtnNew")
                                           let alert = UIAlertController(title: al, message: "cameraNotAvailable", preferredStyle: UIAlertControllerStyle.alert)
                                           let OkAction = UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil)
                                           alert.addAction(OkAction)
                                           self.present(alert, animated: true, completion: nil)
                                       }
                                       self.present(imagePickerConroller,animated:true, completion:nil)
                                   }))
                                   let gallery = UserDefaults.standard.string(forKey: "gallery")
                                   actionSheet.addAction(UIAlertAction(title: "gallery", style: .default, handler: { (action) -> Void in
                                     
                                       let imagePicker = OpalImagePickerController()
                                       imagePicker.navigationBar.tintColor = UIColor.white
                                       imagePicker.maximumSelectionsAllowed = self.maximumImagesAllowed
                                        print(self.maximumImagesAllowed)
                                       imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
                                       // maximum message
                                       let configuration = OpalImagePickerConfiguration()
                                       configuration.maximumSelectionsAllowedMessage = NSLocalizedString((objData?.data.images.message)!, comment: "")
                                       imagePicker.configuration = configuration
                                       imagePicker.imagePickerDelegate = self
                                       self.present(imagePicker, animated: true, completion: nil)
                                   
                                   }))
                                   let cancel = UserDefaults.standard.string(forKey: "cancelBtn")
                                   actionSheet.addAction(UIAlertAction(title: cancel, style: .destructive, handler: { (action) -> Void in
                                   }))
                                   if Constants.isiPadDevice {
                                       actionSheet.popoverPresentationController?.sourceView = cell.containerView
                                       actionSheet.popoverPresentationController?.sourceRect = cell.containerView.bounds
                                       self.present(actionSheet, animated: true, completion: nil)
                                   }else{
                                       self.present(actionSheet, animated: true, completion: nil)
                                   }
                }
               
            }
            return cell
        }
            
        else if section == 1 {
            let cell: CollectionImageCell = tableView.dequeueReusableCell(withIdentifier: "CollectionImageCell", for: indexPath) as! CollectionImageCell
        
            let objData = AddsHandler.sharedInstance.objAdPost
           
            if let sortMsg = objData?.extra.sortImageMsg {
                cell.lblArrangeImage.text = sortMsg
            }
            if let adID = objData?.data.adId {
                cell.ad_id = adID
            }
            if cell.isDrag == false{
                cell.dataArray = self.imageArray
            }else{
                isDragAdpost = true
                imgIdDrag = cell.imageIdArrAd
            }
            print(UiImagesArrAdpost)
            imgCtrlCount = self.imageArray.count
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
        }
            
        else if section == 2 {
            let objData = fieldsArray[indexPath.row]
       
            if objData.fieldType == "textfield"  {
                let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
                
                if objData.fieldTypeName == "ad_bidding_time"{
                  
                    print(isBid)
                    
                    if isBid == false{
                        cell.isHidden = true
                    }else{
                        cell.isHidden = false
                    }
                }
    
                if let title = objData.title {
                    cell.txtType.placeholder = title
                }
               
                if let value = objData.fieldVal {
                    cell.txtType.text = value
                }
                cell.fieldName = objData.fieldTypeName
                cell.inde = indexPath.row
                cell.section = 2
               // cell.selectedIndex = indexPath.row
                cell.delegate = self
                
                
                if objData.fieldTypeName == "ad_price_type"{
                    if isShowPrice == false{
                        cell.isHidden = true
                    }
                }
                
                
                
                return cell
            }
                
            else if objData.fieldType == "select"  {
               
                let cell: DropDownCell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownCell
               
                if objData.fieldTypeName == "ad_bidding"{
                    if isBid == false{
                        cell.isHidden = true
                    }else{
                        cell.isHidden = false
                    }
                }
                
                if let title = objData.title {
                    cell.lblName.text = title
                }
                
                var i = 1
                for item in objData.values {
                    if item.id == "" {
                        continue
                    }
                    if (defaults.string(forKey: "value") != nil) {
                        if indexPath.row == selectedIndex {
                            let name = UserDefaults.standard.string(forKey: "value")
                            cell.oltPopup.setTitle(name, for: .normal)
                        }
                    }
                    if isEditStart == true {
                    if i == 1 {
                        
                         print(cell.selectedValue)
                        
                        if isfromEditAd {
                            cell.oltPopup.setTitle(item.name, for: .normal)
                            cell.selectedKey = String(item.id)
                        }else{
                            if cell.selectedValue == ""{
                                cell.oltPopup.setTitle(objData.values[1].name, for: .normal)
                                cell.selectedKey = String(item.id)
                            }else{
                                cell.oltPopup.setTitle(cell.selectedValue, for: .normal)
                                cell.selectedKey = String(item.id)
                            }
                        }
                      //  cell.oltPopup.setTitle(item.name, for: .normal)
                      //  cell.selectedKey = String(item.id)
                    }
                    i = i + 1
                    }
                    
                }
                cell.btnPopUpAction = { () in
                    cell.dropDownKeysArray = []
                    cell.dropDownValuesArray = []
                    cell.fieldTypeNameArray = []
                    for item in objData.values {
                        if item.id == "" {
                            continue
                        }
                        cell.dropDownKeysArray.append(String(item.id))
                        cell.dropDownValuesArray.append(item.name)
                        cell.hasFieldsArr.append(item.hasTemplate)
                        cell.fieldTypeNameArray.append(objData.fieldTypeName)
//                        cell.isShowArr.append(item.isShow)

                    }
                    cell.accountDropDown()
                    cell.valueDropDown.show()
                }
                cell.param = objData.fieldTypeName
                cell.selectedIndex = indexPath.row
                cell.index = indexPath.row
                cell.section = 2
                cell.fieldNam = objData.fieldTypeName
                cell.delegate = self
                
                return cell
            }
            
            else if objData.fieldType == "textarea" && objData.hasPageNumber == "2"  {
                let cell: DescriptionTableCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableCell", for: indexPath) as! DescriptionTableCell
                
                if let title = objData.title {
                    cell.lblDescription.text = title
                }
                if let value = objData.fieldVal {
                    //cell.richEditorView.html = value
                    cell.txtDescription.text = value
                    //cell.textLabel?.text = value
                }
                cell.fieldName = objData.fieldTypeName
                //cell.delegate = self
                cell.delegateDes = self
                cell.index = indexPath.row
                cell.section = 2
                return cell
            }
                
            else if objData.fieldType == "checkbox" {
                let cell: CheckBoxCell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell", for: indexPath) as! CheckBoxCell
                
                if let title = objData.title {
                    cell.lblName.text = title
                }
                cell.dataArray = objData.values
                cell.fieldName = objData.fieldTypeName
                cell.fieldType = objData.fieldType
                cell.tableView.reloadData()
                return cell
            }
                
            else if objData.fieldType == "textfield_url" {
                let cell: AdPostURLCell = tableView.dequeueReusableCell(withIdentifier: "AdPostURLCell", for: indexPath) as! AdPostURLCell
                
                if let placeHolder = objData.title {
                    cell.txtUrl.placeholder = placeHolder
                }
                
                cell.fieldName = objData.fieldTypeName
                return cell
            }
            
            else if objData.fieldType == "textfield_date" {
                let cell: CalenderSingleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CalenderSingleTableViewCell", for: indexPath) as! CalenderSingleTableViewCell
                if let title = objData.fieldVal {
                    //cell.oltDate.setTitle(title, for: .normal)
                    cell.txtDate.text = title
                }
                if let title = objData.title {
                    cell.txtDate.placeholder = title
                }
                cell.indexP = indexPath.row
                cell.section = 2
                cell.fieldName = objData.fieldTypeName
                cell.delegate = self
                
                return cell
            }
                
            else if objData.fieldType == "radio" {

                let cell: AdpostRadioTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdpostRadioTableViewCell", for: indexPath) as! AdpostRadioTableViewCell

                if let title = objData.title {
                    cell.lblTitle.text = title
                }
                cell.dataArray = objData.values
                cell.isSelected = objData.tempIsSelected
                cell.index = indexPath.row
                cell.section = 2
                cell.delegate = self
                cell.fieldName = objData.fieldTypeName
                cell.tableView.reloadData()
                
                return cell

            }
            
            else if objData.fieldType == "radio_color" {
                let cell: RadioColorAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioColorAdTableViewCell", for: indexPath) as! RadioColorAdTableViewCell
                
                if let title = objData.title {
                    cell.lblTitle.text = title
                    cell.title = title
                }
                cell.fieldName = objData.fieldTypeName
                cell.dataArray = objData.values
                cell.index = indexPath.row
                cell.delegate = self as! ColorRadioDelegateAdpost
                cell.collectionView.reloadData()
                return cell
            }
            
            else if objData.fieldType == "textfield_number" {
                let cell: NumericRangeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NumericRangeTableViewCell", for: indexPath) as! NumericRangeTableViewCell
                
                if let title = objData.title {
                    cell.lblTitle.text = title
                    cell.txtMinPrice.placeholder = title
                }
                cell.fieldName = objData.fieldTypeName
                cell.txtMinPrice.keyboardType = .numberPad
                return cell
            }
            

        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height : CGFloat = 0
        if section == 0 {
            
              height = 100

        } else if section == 1 {
            if imageArray.isEmpty {
                height = 0
            } else {
                height = 140
            }
        
        } else if section == 2 {
            let objData = fieldsArray[indexPath.row]
            if objData.fieldType == "textarea" {
                height = 250
            } else if objData.fieldType == "select" {
                height = 80
            } else if objData.fieldType == "textfield" {
                height = 80
            } else if objData.fieldType == "checkbox" {
                height = 230
            } else if objData.fieldType == "textfield_url" {
                height = 80
            } else if objData.fieldType == "textfield_date" {
                height = 80
            }
            else if objData.fieldType == "radio_color" {
                height = 80
            }
            else if objData.fieldType == "textfield_number" {
                height = 110
            }
            if objData.fieldType == "radio" {
                return 130
            }
        }
        return height
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {

        if images.isEmpty {
        }
        else {
            self.photoArray = images
            let param: [String: Any] = [ "ad_id": String(adID)]
            print(param)
            self.uploadImages(param: param as NSDictionary, images: self.photoArray)
        }
            presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismissVC(completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
    
                self.photoArray = [pickedImage]
                let param: [String: Any] = [ "ad_id": String(adID)]
                print(param)
                self.uploadImages(param: param as NSDictionary, images: self.photoArray)
                
            }
            dismiss(animated: true, completion: nil)
           
        }
    }
    
   
    //MARK:- API Call
    
    //post images
    
    func uploadImages(param: NSDictionary, images: [UIImage]) {
        //self.showLoader()
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: view)
        
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            self.uploadingProgressBar.dismiss(animated: true)
            //self.stopAnimating()
            if successResponse.success {
                self.imageArray = successResponse.data.adImages
                self.imgCtrlCount = successResponse.data.adImages.count
                //add image id to array to send to next View Controller and hit to server
                for item in self.imageArray {
                    self.imageIDArray.append(item.imgId)
                }
                self.maximumImagesAllowed = successResponse.data.images.numbers
                self.imagesMsg = successResponse.data.images.message
                
                UserDefaults.standard.set( self.imagesMsg, forKey: "imgMsg")
                self.tableView.reloadData()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
     func adPostUploadImages(parameter: NSDictionary , imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.adPostUploadImages
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objImg = AdPostImagesRoot(fromDictionary: dictionary)
            success(objImg)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
}

extension AdPostImagesController:textValDelegate,textValDescDelegate,textValDateDelegate,textSelectDropDown,ColorRadioDelegateAdpost,radioDelegateAdpost{
   

    func radVal(rVal: String, fieldType: String, indexPath: Int, isSelected: Bool,fieldNam:String) {
        if fieldType == "radio"{
            var obj = AdPostField()
            obj.fieldType = "radio"
            obj.fieldVal = rVal
            obj.fieldTypeName = fieldNam //"radio"
            self.fieldsArray[indexPath].tempIsSelected = isSelected
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
        }
    }

    func colorVal(colorCode: String, fieldType: String, indexPath: Int, isSelected: Bool,fieldNam:String) {
        if fieldType == "radio_color"{
            var obj = AdPostField()
            obj.fieldType = "radio_color"
            obj.fieldVal = colorCode
            obj.fieldTypeName = fieldNam //"select_colors"
            self.fieldsArray[indexPath].tempIsSelected = isSelected
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
        }
    }

    func textValSelecrDrop(value: String, indexPath: Int, fieldType: String, section: Int,fieldName:String,isShow:Bool,valueName:String) {
        if fieldType == "select"{
            var obj = AdPostField()
            obj.fieldType = "select"
            obj.fieldVal = value
            obj.fieldTypeName = fieldName
            isShowPrice = isShow
            self.fieldsArray[indexPath].fieldVal = valueName
            self.dataArray[indexPath].fieldVal = valueName
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
            isEditStart = true
            //tableView.reloadData()
        }
    }
    
    func textValDate(value: String, indexPath: Int, fieldType: String, section: Int,fieldNam:String) {
        if fieldType == "textfield_date"{
            var obj = AdPostField()
            obj.fieldType = "textfield_date"
            obj.fieldVal = value
            obj.fieldTypeName = fieldNam //"date_input"
            self.fieldsArray[indexPath].fieldVal = value
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
        }
    }
    
    func textValDesc(value: String, indexPath: Int, fieldType: String, section: Int,fieldNam:String) {
        if fieldType == "textarea"{
            var obj = AdPostField()
            obj.fieldType = "textarea"
            obj.fieldVal = value
            obj.fieldTypeName = fieldNam  //"ad_description"
            print(value)
            self.fieldsArray[indexPath].fieldVal = value
            //self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            //customArray.append(obj)
        }
    }
    
    func textVal(value: String, indexPath: Int,fieldType:String,section:Int,fieldNam:String) {
        if fieldType == "textfield"{
            var obj = AdPostField()
            obj.fieldType = "textfield"
            obj.fieldVal = value
            obj.fieldTypeName = fieldNam //fieldType
            self.fieldsArray[indexPath].fieldVal = value
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
            
        }
    }
    
}


