//
//  AdPostVC.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import ImageSlideshow
import OpalImagePicker

var adDetailObj: AdDetailObject = AdDetailObject()
var adPostVC: AdPostVC!

class AdPostVC: UIViewController, NVActivityIndicatorViewable, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate
{
    //MARK:- Properties
    
    var maximumImagesAllowed = 9
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescp: UITextView!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescp: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblPhoto : UILabel!
    @IBOutlet weak var lblCategoryText : UILabel!
    @IBOutlet weak var lblCategory : UILabel!
    @IBOutlet weak var lblFixedPrice : UILabel!
    @IBOutlet weak var lblDetailText : UILabel!
    @IBOutlet weak var lblDetail : UILabel!
    @IBOutlet weak var lblContactText : UILabel!
    @IBOutlet weak var lblPhone : UILabel!
    @IBOutlet weak var lblWhatsapp : UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnPhoto1: UIButton!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var fixedTick: UIImageView!
    @IBOutlet weak var negotiateTick: UIImageView!
    
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtWhatsapp: UITextField!
    
    @IBOutlet weak var phoneSwitch: UISwitch!
    @IBOutlet weak var whatsappSwitch: UISwitch!
    
    var fromVC = ""
    var priceFlag = false
    
    var numberFlag = true
    var whatsappFlag = true
    
    //MARK:- Collectionview Properties
    var isDrag : Bool = false
    
    @IBOutlet weak var viewDragImage: UIView!
    @IBOutlet weak var lblArrangeImage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet
        {
            collectionView.delegate = self
            collectionView.dataSource = self
            if #available(iOS 11.0, *)
            {
                collectionView.dragInteractionEnabled = true
                collectionView.dragDelegate = self
                collectionView.dropDelegate = self
                collectionView.reorderingCadence = .immediate //default value - .immediate
            }
            else
            {
                // Fallback on earlier versions
            }
        }
    }

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adPostVC = self
        
        if fromVC == "myads"
        {
            for image in adDetailObj.adImages
            {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: String(format: "%@%@", Constants.URL.imagesUrl, image.url))!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                adDetailObj.images.append(image)
                                self!.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        else
        {
            if homeVC != nil
            {
                homeVC.getGPSLocation()
            }
        }
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPhone.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtWhatsapp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblContactText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPhone.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblWhatsapp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblCurrency.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFixedPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPhoto.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblCategoryText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCancel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPreview.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtTitle.textAlignment = .right
            txtDescp.textAlignment = .right
            txtPrice.textAlignment = .right
            txtPhone.textAlignment = .right
            txtWhatsapp.textAlignment = .right
            lblDescp.textAlignment = .right
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func populateData()
    {
        if adDetailObj.location.address == ""
        {
            adDetailObj.location.address = userDetail?.currentAddress ?? ""
            adDetailObj.location.lat = userDetail?.currentLocation.coordinate.latitude
            adDetailObj.location.lng = userDetail?.currentLocation.coordinate.longitude
            lblEmail.text = userDetail?.currentAddress
        }
        else
        {
            lblEmail.text = adDetailObj.location.address
        }
        
        if adDetailObj.adTitle != "" && fromVC == "myads"
        {
            txtTitle.text = adDetailObj.adTitle
        }
        
        if !txtDescp.text.isEmpty
        {
            lblDescp.alpha = 0
        }
        
        if adDetailObj.adDesc != "" && fromVC == "myads"
        {
            lblDescp.alpha = 0
            txtDescp.text = adDetailObj.adDesc
        }
        
        if adDetailObj.adSubCategory != ""
        {
            lblCategory.text = adDetailObj.adSubCategory
        }
        else if adDetailObj.adCategory != ""
        {
            lblCategory.text = adDetailObj.adCategory
        }
        
        if adDetailObj.adCategory == "Motors" || adDetailObj.adCategory == "Property"
        {
            lblDetail.text = adDetailObj.specs
            detailView.alpha = 1
            top.constant = 85
        }
        else
        {
            detailView.alpha = 0
            top.constant = 12
        }

        if adDetailObj.subcatID > 0
        {
            lblCategory.text = adDetailObj.adSubCategory
        }
        else if adDetailObj.catID > 0
        {
            lblCategory.text = adDetailObj.adCategory
        }
        
        if adDetailObj.phone != ""
        {
            txtPhone.text = adDetailObj.phone
            txtWhatsapp.text = adDetailObj.phone
            
            numberFlag = true
            whatsappFlag = true
            
            phoneSwitch.setOn(true, animated: false)
            whatsappSwitch.setOn(true, animated: false)
        }
        else
        {
            if fromVC == "myads"
            {
                numberFlag = false
                whatsappFlag = false
                
                phoneSwitch.setOn(false, animated: false)
                whatsappSwitch.setOn(false, animated: false)
            }
            else
            {
                numberFlag = true
                whatsappFlag = true
                
                txtPhone.text = userDetail?.phone
                txtWhatsapp.text = userDetail?.phone
            }
        }
        
        if adDetailObj.priceType != "" && fromVC == "myads"
        {
            lblFixedPrice.text = adDetailObj.priceType
        }
        else
        {
            lblFixedPrice.text = "Fixed"
            adDetailObj.priceType = "Fixed"
        }
        
        if adDetailObj.adPrice != "" && fromVC == "myads"
        {
            txtPrice.text = adDetailObj.adPrice
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func photoBtnAction()
    {
        let actionSheet = UIAlertController(title: "Select", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = languageCode == "ar" ? "الة تصوير" : "Camera"
        actionSheet.addAction(UIAlertAction(title: camera, style: .default, handler: { (action) -> Void in
            
            let imagePickerConroller = UIImagePickerController()
            imagePickerConroller.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerConroller.sourceType = .camera
            }
            else
            {
                let al = UserDefaults.standard.string(forKey: "aler")
                 let ok = UserDefaults.standard.string(forKey: "okbtnNew")
                let alert = UIAlertController(title: al, message: "cameraNotAvailable", preferredStyle: UIAlertControllerStyle.alert)
                let OkAction = UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(OkAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.present(imagePickerConroller,animated:true, completion:nil)
        }))
        
        let gallery = languageCode == "ar" ? "إلبوم الصور" : "Photo Gallery"
        actionSheet.addAction(UIAlertAction(title: gallery, style: .default, handler: { (action) -> Void in

            let imagePicker = OpalImagePickerController()
            imagePicker.maximumSelectionsAllowed = self.maximumImagesAllowed

            let configuration = OpalImagePickerConfiguration()
            configuration.maximumSelectionsAllowedMessage = "You cannot select more than 9 images."
            imagePicker.configuration = configuration
            imagePicker.imagePickerDelegate = self
            self.present(imagePicker, animated: true, completion: nil)

        }))
        let cancel = languageCode == "ar" ? "إلغاء" : "Cancel"
            actionSheet.addAction(UIAlertAction(title: cancel, style: .destructive, handler: { (action) -> Void in
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnACtion(_ sender: Any)
    {
        adDetailObj = AdDetailObject()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryBtnACtion(_ sender: Any)
    {
//        let selectCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "TblViewController") as! TblViewController
//        self.navigationController?.pushViewController(selectCategoryVC, animated: true)
        
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        categoryVC.fromVC = "adPost"
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @IBAction func priceBtnACtion(_ sender: Any)
    {
        priceView.alpha = 1
    }
    
    @IBAction func clickBtnACtion(button: UIButton)
    {
        if button.tag == 1001
        {
            lblFixedPrice.text = "Fixed Price"
            fixedTick.alpha = 1
            negotiateTick.alpha = 0
            adDetailObj.priceType = "Fixed"
        }
        else
        {
            lblFixedPrice.text = "Negotiable"
            fixedTick.alpha = 0
            negotiateTick.alpha = 1
            adDetailObj.priceType = "Negotiable"
        }
        priceView.alpha = 0
    }
    
    @IBAction func detailBtnACtion(_ sender: Any)
    {
        if adDetailObj.adCategory == "Motors"
        {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        else if adDetailObj.adCategory == "Property"
        {
            let propertyVC = self.storyboard?.instantiateViewController(withIdentifier: "PropertyVC") as! PropertyVC
            self.navigationController?.pushViewController(propertyVC, animated: true)
        }
    }
    
    @IBAction func locationBtnACtion(_ sender: Any)
    {
//        let mapboxVC = self.storyboard?.instantiateViewController(withIdentifier: "MapBoxViewController") as! MapBoxViewController
//        mapboxVC.latitude = userDetail?.currentLocation.coordinate.latitude
//        mapboxVC.longitude = userDetail?.currentLocation.coordinate.longitude
//        self.navigationController?.pushViewController(mapboxVC, animated: true)
        
//        let locVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
//        locVC.latitude = userDetail?.currentLocation.coordinate.latitude
//        locVC.longitude = userDetail?.currentLocation.coordinate.longitude
//        self.navigationController?.pushViewController(locVC, animated: true)
        
        let locVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryAreasVC") as! CountryAreasVC
        locVC.fromInd = "AdPost"
        self.navigationController?.pushViewController(locVC, animated: true)
    }
    
    @IBAction func switchAction(switchC: UISwitch)
    {
        if switchC.tag == 1001
        {
            if switchC.isOn
            {
                numberFlag = true
            }
            else
            {
                numberFlag = false
            }
        }
        else if switchC.tag == 1002
        {
            if switchC.isOn
            {
                whatsappFlag = true
            }
            else
            {
                whatsappFlag = false
            }
        }
    }
    
    @IBAction func previewBtnACtion(_ sender: Any)
    {
        adDetailObj.adTitle = txtTitle.text ?? ""
        adDetailObj.adDesc = txtDescp.text
        adDetailObj.adCurrency = "AED"
        adDetailObj.adPrice = txtPrice.text ?? ""
        
        let previewAdVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewAdVC") as! PreviewAdVC
        previewAdVC.adDetailObj = adDetailObj
        self.navigationController?.pushViewController(previewAdVC, animated: true)
    }
    
    @IBAction func postAdBtnAction(_ sender: Any)
    {
        if adDetailObj.images.count == 0 && fromVC == ""
        {
            var msg = "Please add atleast one photo."
            
            if languageCode == "ar"
            {
                msg = "يرجى إضافة صورة واحدة على الأقل"
            }
            
            self.showToast(message: msg)
        }
        else if txtTitle.text!.isEmpty
        {
            self.txtTitle.shake(6, withDelta: 10, speed: 0.06)
        }
        else if txtDescp.text!.isEmpty || txtDescp.text.count < 20
        {
            var msg = "Please enter minimum 20 characters in description"
            
            if languageCode == "ar"
            {
                msg = "الرجاء إدخال 20 حرفًا كحد أدنى في الوصف"
            }
            
            self.showToast(message: msg)
        }
        else if txtPrice.text!.isEmpty
        {
            self.txtPrice.shake(6, withDelta: 10, speed: 0.06)
        }
        else if numberFlag && txtPhone.text!.isEmpty
        {
            var msg = "Please enter your contact number"
            
            if languageCode == "ar"
            {
                msg = "يرجى إدخال رقم الهاتف الخاص بك"
            }
            
            self.showToast(message: msg)
        }
        else if whatsappFlag && txtPhone.text!.isEmpty
        {
            var msg = "Please add your whatsApp number."
            
            if languageCode == "ar"
            {
                msg = "يرجى إدخال رقم WhatsApp الخاص بك"
            }
            
            self.showToast(message: msg)
        }
        else
        {
            if fromVC == "myads"
            {
                adDetailObj.phone = txtPhone.text!
                adDetailObj.whatsapp = txtWhatsapp.text!
                
                addPostLiveAPI()
            }
            else
            {
                adDetailObj.phone = txtPhone.text!
                adDetailObj.whatsapp = txtWhatsapp.text!
                adDetailObj.adTitle = self.txtTitle.text!
                adDetailObj.adPrice = self.txtPrice.text!
                adDetailObj.priceType = lblFixedPrice.text!
                adDetailObj.name = self.txtTitle.text!
                adDetailObj.adDesc = txtDescp.text
                
                let featuredVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedVC") as! FeaturedVC
                self.navigationController?.pushViewController(featuredVC, animated: true)
            }
        }
    }
    
    //MARK:- Customs
    
    @objc func hideLoader()
    {
        self.stopAnimating()
        
        if adDetailObj.adCategory == "Motors"
        {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        else if adDetailObj.adCategory == "Property"
        {
            let propertyVC = self.storyboard?.instantiateViewController(withIdentifier: "PropertyVC") as! PropertyVC
            self.navigationController?.pushViewController(propertyVC, animated: true)
        }
    }
    
    func hideKeypad()
    {
        priceView.alpha = 0
        txtDescp.resignFirstResponder()
        txtPrice.resignFirstResponder()
        txtTitle.resignFirstResponder()
        txtPhone.resignFirstResponder()
        txtWhatsapp.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        hideKeypad()
    }
    
    //MARK:- Imagepicker Delegate
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage])
    {
        if !images.isEmpty
        {
            for var image in images
            {
                image = resizeImage(image: image, targetSize: CGSize(width: 300, height: 300))
                adDetailObj.images.append(image)
            }
            
            hideShowControls(controls1Alpha: 1, controlsAlpha: 0)
            collectionView.alpha = 1
            collectionView.reloadData()
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController)
    {
        self.dismissVC(completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil
        {
            if var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                pickedImage = resizeImage(image: pickedImage, targetSize: CGSize(width: 300, height: 300))
                
                adDetailObj.images.append(pickedImage)
                hideShowControls(controls1Alpha: 1, controlsAlpha: 0)
                collectionView.alpha = 1
                collectionView.reloadData()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func hideShowControls(controls1Alpha: CGFloat, controlsAlpha: CGFloat)
    {
        btnPhoto1.alpha = controls1Alpha
        
        btnPhoto.alpha = controlsAlpha
        lblPhoto.alpha = controlsAlpha
    }
    
    //MARK:- Textview Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblDescp.alpha = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty
        {
            lblDescp.alpha = 1
        }
        else
        {
            lblDescp.alpha = 0
        }
    }
    

    
    //MARK:- Ad Post APIs
    func addPostLiveAPI()
    {
        var parameter: [String: Any] = [
            "id" : adDetailObj.adId,
            "user_id": String(format: "%d", userDetail?.id ?? 0),
            "phone": adDetailObj.phone,
            "whatsapp": adDetailObj.whatsapp,
            "latitude": "",
            "longitude": "",
            "address": "Palm Jumeirah",
            "country": "Dubai",
//                "address": adDetailObj.location.address,
            "is_featured": "0",
            "featured_date": "",
            "name": adDetailObj.adTitle,
            "price" : adDetailObj.adPrice,
            "price_type" : adDetailObj.priceType,
            "title": adDetailObj.adTitle,
            "description" : adDetailObj.adDesc,
            "status" : "1",
            "cat_id" : "1"
//                "cat_id" : String(format: "%d", adDetailObj.subcatID > 0 ? adDetailObj.subcatID : adDetailObj.catID)
        ]
        
        var customDictionary: [String: Any] = [String: Any]()

        if adDetailObj.motorCatObj.regNo != ""
        {
            customDictionary.merge(with: ["regNo" : adDetailObj.motorCatObj.regNo])
        }

        if adDetailObj.motorCatObj.sellerType != ""
        {
            customDictionary.merge(with: ["sellerType" : adDetailObj.motorCatObj.sellerType])
        }

        if adDetailObj.motorCatObj.make != ""
        {
            customDictionary.merge(with: ["make" : adDetailObj.motorCatObj.make])
        }

        if adDetailObj.motorCatObj.model != ""
        {
            customDictionary.merge(with: ["model" : adDetailObj.motorCatObj.model])
        }

        if adDetailObj.motorCatObj.year != ""
        {
            customDictionary.merge(with: ["year" : adDetailObj.motorCatObj.year])
        }

        if adDetailObj.motorCatObj.mileage != ""
        {
            customDictionary.merge(with: ["mileage" : adDetailObj.motorCatObj.mileage])
        }

        if adDetailObj.motorCatObj.bodyType != ""
        {
            customDictionary.merge(with: ["bodyType" : adDetailObj.motorCatObj.bodyType])
        }

        if adDetailObj.motorCatObj.fuelType != ""
        {
            customDictionary.merge(with: ["fuelType" : adDetailObj.motorCatObj.fuelType])
        }

        if adDetailObj.motorCatObj.transmission != ""
        {
            customDictionary.merge(with: ["transmission" : adDetailObj.motorCatObj.transmission])
        }

        if adDetailObj.motorCatObj.colour != ""
        {
            customDictionary.merge(with: ["colour" : adDetailObj.motorCatObj.colour])
        }

        if adDetailObj.motorCatObj.engineSize != ""
        {
            customDictionary.merge(with: ["engineSize" : adDetailObj.motorCatObj.engineSize])
        }

        if adDetailObj.propertyCatObj.propertyType != ""
        {
            customDictionary.merge(with: ["propertyType" : adDetailObj.propertyCatObj.propertyType])
        }

        if adDetailObj.propertyCatObj.bedrooms != ""
        {
            customDictionary.merge(with: ["bedrooms" : adDetailObj.propertyCatObj.bedrooms])
        }

        if adDetailObj.propertyCatObj.sellerType != ""
        {
            customDictionary.merge(with: ["psellerType" : adDetailObj.propertyCatObj.sellerType])
        }

        if customDictionary.count > 0
        {
            let custom = Constants.json(from: customDictionary)
            let param: [String: Any] = ["custom_fields": custom]
            parameter.merge(with: param)
        }
            
        self.showLoader()
        self.uploadAdWithImages(param: parameter as NSDictionary, images: adDetailObj.images)
    }
    
    func uploadAdWithImages(param: NSDictionary, images: [UIImage])
    {
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            
            self.stopAnimating()
            if successResponse.success
            {
                self.showToast(message: "Ad updated successfully.")
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adPostUploadImages(parameter: NSDictionary, imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.adPostLive
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            
        }, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: Any]
            print(dictionary)
            let objImg = AdPostImagesRoot(fromDictionary: dictionary)
            success(objImg)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            self.stopAnimating()
        }
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    @available(iOS 11.0, *)
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            
            collectionView.performBatchUpdates({
                if collectionView === self.collectionView
                {
                    print(sourceIndexPath.row)
                    print(dIndexPath.row)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [dIndexPath])
                    adDetailObj.images.remove(at: sourceIndexPath.row)
                    
                    item.dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {(newImage, error) -> Void in
                        
                        if let image = newImage as? UIImage
                        {
                            adDetailObj.images.insert(image, at: dIndexPath.row)
                        }
                    })
                }
            })
            
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        
        }
    }
        
    func addDetail(param: NSDictionary)
    {
      self.showLoader()
      AddsHandler.addDetails(parameter: param, success: { (successResponse) in
          self.stopAnimating()
          if successResponse.success
          {
                AddsHandler.sharedInstance.objAddDetails = successResponse.data
                adDetailObj.phone = AddsHandler.sharedInstance.objAddDetails?.adDetail.phone ?? ""
                adDetailObj.adDesc = AddsHandler.sharedInstance.objAddDetails?.adDetail.adDesc ?? ""
                adDetailObj.adPrice = AddsHandler.sharedInstance.objAddDetails?.adDetail.adPrice.price ?? ""
                adDetailObj.priceType = AddsHandler.sharedInstance.objAddDetails?.adDetail.adPrice.priceType ?? ""
                adDetailObj.adPrice = adDetailObj.adPrice.replacingOccurrences(of: "AED ", with: "")
                self.populateData()
          }
          else
          {
              let alert = Constants.showBasicAlert(message: successResponse.message)
              self.presentVC(alert)
          }
          
      }) { (error) in
          self.stopAnimating()
          let alert = Constants.showBasicAlert(message: error.message)
          self.presentVC(alert)
      }
    }

    //MARK:- Collection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adDetailObj.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        
        let image = adDetailObj.images[indexPath.row]

        cell.imgPictures.image = image
        
        cell.btnDelete = { () in
            self.removeImage(index: indexPath.row)
        }
        
        return cell
    }
        
        
    func rotateImageAppropriately(_ imageToRotate: UIImage?) -> UIImage? {
        //This method will properly rotate our image, we need to make sure that
        //We call this method everywhere pretty much...
        
        let imageRef = imageToRotate?.cgImage
        var properlyRotatedImage: UIImage?

            properlyRotatedImage = imageToRotate
            if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 1) {
                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)
            }
        
        return properlyRotatedImage
    }
    
    func removeImage(index: Int)
    {
        self.showLoader()
        let parameter : [String: Any] = ["img_id": adDetailObj.adImages[index].id ?? 0]
        
        AddsHandler.deleteAdd(param: parameter as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    adDetailObj.images.remove(at: index)
                    
                    if adDetailObj.images.count == 0
                    {
                        self.hideShowControls(controls1Alpha: 0, controlsAlpha: 1)
                        self.collectionView.alpha = 0
                    }
                    
                    self.collectionView.reloadData()
                })
                self.presentVC(alert)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension AdPostVC: UICollectionViewDragDelegate
{
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = adDetailObj.images[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        isDrag = true
        return [dragItem]
    }
}

extension AdPostVC: UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
    }
    
    @available(iOS 11.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?)
        -> UICollectionViewDropProposal {
            if collectionView.hasActiveDrag{
                return UICollectionViewDropProposal(operation: .move ,intent: .insertAtDestinationIndexPath)

            }
            return UICollectionViewDropProposal(operation: .forbidden)

    }
    
     @available(iOS 11.0, *)
     func AdPostVC(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
         var destinationIndexpath = IndexPath()
         if let indexPath = coordinator.destinationIndexPath{
             destinationIndexpath = indexPath
         }
         else{
             let row = collectionView.numberOfItems(inSection: 0)
             destinationIndexpath = IndexPath(item: row - 1 , section: 0)
         }
         if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator:coordinator , destinationIndexPath: destinationIndexpath ,collectionView: collectionView)
                print(destinationIndexpath)

         }
     }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage
{
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
