//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import OpalImagePicker

struct AdPostObject
{
    
}

class AdPostVC: UIViewController, NVActivityIndicatorViewable, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate
{
    //MARK:- Properties
    
    var maximumImagesAllowed = 9
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescp: UITextView!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblPhoto : UILabel!
    @IBOutlet weak var lblCategory : UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    
    var fromVC = ""
    
    var photoArray = [UIImage]()
    var imageArray = [AdPostImageArray]()
    var imgCtrlCount = 0
    var imageIDArray = [Int]()
    
    var phone = ""
    var address = ""
    
    //MARK:- Collectionview Properties
    var isDrag : Bool = false
    
    @IBOutlet weak var viewDragImage: UIView!
    @IBOutlet weak var lblArrangeImage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            if #available(iOS 11.0, *) {
                collectionView.dragInteractionEnabled = true
                collectionView.dragDelegate = self
                collectionView.dropDelegate = self
                collectionView.reorderingCadence = .immediate //default value - .immediate

            } else {
                // Fallback on earlier versions
            }
            collectionView.backgroundColor = UIColor.groupTableViewBackground
        }
    }

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPhoto.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCancel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPreview.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtTitle.textAlignment = .right
            txtDescp.textAlignment = .right
            txtPrice.textAlignment = .right
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var contactStr = userDetail?.userEmail ?? ""
        
        if AddsHandler.sharedInstance.phone != ""
        {
            contactStr = contactStr + ", " + AddsHandler.sharedInstance.phone
        }
        
        if AddsHandler.sharedInstance.address != ""
        {
            contactStr = contactStr + ", " + AddsHandler.sharedInstance.address
        }
        
        lblEmail.text = contactStr
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryBtnACtion(_ sender: Any)
    {
        
    }
    
    @IBAction func locationBtnACtion(_ sender: Any)
    {
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationContactVC") as! LocationContactVC
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    @IBAction func postAdBtnACtion(_ sender: Any)
    {
        if txtTitle.text!.isEmpty
        {
            self.txtTitle.shake(6, withDelta: 10, speed: 0.06)
        }
        else if txtPrice.text!.isEmpty
        {
            self.txtPrice.shake(6, withDelta: 10, speed: 0.06)
        }
        else
        {
            let param: [String: Any] = ["is_update": ""]
            print(param)
            self.adPost(param: param as NSDictionary)
        }
        
//        let featuredVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedVC") as! FeaturedVC
//        self.navigationController?.pushViewController(featuredVC, animated: true)
    }
    
    func hideKeypad()
    {
        txtDescp.resignFirstResponder()
        txtPrice.resignFirstResponder()
        txtTitle.resignFirstResponder()
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
            self.photoArray = images
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
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                self.photoArray = [pickedImage]
                collectionView.alpha = 1
                collectionView.reloadData()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- Textview Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        lblDescp.alpha = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty
        {
            lblDescp.alpha = 0
        }
        else
        {
            lblDescp.alpha = 1
        }
    }
    
    //MARK:- Ad Post APIs
    func addPostLiveAPI()
    {
        let parameter: [String: Any] = [
            "images_array": self.imageIDArray,
            "ad_phone": "+923225582024",
            "ad_location": "Sialkot Road",
            "location_lat": "32.1774414",
            "location_long": "74.2001039",
            "ad_country": "Pakistan",
            "ad_featured_ad": false,
            "ad_id": AddsHandler.sharedInstance.adPostAdId,
            "ad_bump_ad": true,
            "name": self.txtTitle.text!,
            "ad_price" : self.txtPrice.text!,
            "ad_title": self.txtTitle.text!,
        ]
        
        self.adPostLive(param: parameter as NSDictionary)
    }
    
    func adPost(param: NSDictionary)
    {
        print(param)
        self.showLoader()
        AddsHandler.adPost(parameter: param, success: { (successResponse) in
//            self.stopAnimating()
            if successResponse.success {

                print(successResponse)
                AddsHandler.sharedInstance.adPostAdId = successResponse.data.adId
                AddsHandler.sharedInstance.objAdPost = successResponse
                
                let param: [String: Any] = ["cat_id": 3]
                print(param)
                self.dynamicFields(param: param as NSDictionary)
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
    
    func dynamicFields(param: NSDictionary)
    {
        self.showLoader()
        AddsHandler.adPostDynamicFields(parameter: param, success: { (successResponse) in
            
            if successResponse.success
            {
                let param: [String: Any] = ["ad_id": AddsHandler.sharedInstance.adPostAdId]
                print(param)
                self.uploadImages(param: param as NSDictionary, images: self.photoArray)
            }
            else
            {
                self.stopAnimating()
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adPostLive(param: NSDictionary)
    {
        self.showLoader()
        AddsHandler.adPostLive(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                self.presentVC(alert)
                
                self.imageIDArray.removeAll()
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
    
    func uploadImages(param: NSDictionary, images: [UIImage]) {
        
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            
            //self.stopAnimating()
            if successResponse.success {
                self.imageArray = successResponse.data.adImages
                self.imgCtrlCount = successResponse.data.adImages.count
                //add image id to array to send to next View Controller and hit to server
                for item in self.imageArray {
                    self.imageIDArray.append(item.imgId)
                }
            }
            else
            {
                self.stopAnimating()
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
            
        }, success: { (successResponse) in
            self.addPostLiveAPI()
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
                    self.photoArray.remove(at: sourceIndexPath.row)
                    
                    item.dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {(newImage, error) -> Void in
                        
                        if let image = newImage as? UIImage
                        {
                            self.photoArray.insert(image, at: dIndexPath.row)
                        }
                    })
                }
            })
            
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        
        }
    }
        

    //MARK:- Collection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        
        let image = photoArray[indexPath.row]

        cell.imgPictures.image = image
        
        cell.btnDelete = { () in
            self.removeItem(index: indexPath.row)
        }
        
        return cell
    }
        
        
    func rotateImageAppropriately(_ imageToRotate: UIImage?) -> UIImage? {
        //This method will properly rotate our image, we need to make sure that
        //We call this method everywhere pretty much...
        
        let imageRef = imageToRotate?.cgImage
        var properlyRotatedImage: UIImage?
        
        //if imageOrientationWhenAddedToScreen == 0 {
            //Don't rotate the image
            properlyRotatedImage = imageToRotate
        //}
 //       else if imageOrientationWhenAddedToScreen == 3 {
//
//            //We need to rotate the image back to a 3
//           if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 3) {                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)          }
        
//    }
      //     else if imageOrientationWhenAddedToScreen == 1 {
//
//            //We need to rotate the image back to a 1
            if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 1) {
                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)
            }
       // }
        
        return properlyRotatedImage
        
    }
    
    //Remove item at selected Index
    func removeItem(index: Int) {
        photoArray.remove(at: index)
        self.collectionView.reloadData()
    }
}

extension AdPostVC: UICollectionViewDragDelegate
{
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.imageArray[indexPath.row]
        let itemProvider = NSItemProvider(object: item.thumb as NSString)
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
