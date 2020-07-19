//
//  AdPostMapController.swift
//  PalmTree
//
//  Created by SprintSols on 4/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MapKit
import TextFieldEffects
import DropDown
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import NVActivityIndicatorView
import JGProgressHUD


class AdPostMapController: UITableViewController, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate , UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, NVActivityIndicatorViewable, SubCategoryDelegate,latLongitudePro {
  
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblUserinfo: UILabel!
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var txtNumber: HoshiTextField!
    @IBOutlet weak var containerViewPopup: UIView! {
        didSet {
            containerViewPopup.addShadowToView()
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var oltPopup: UIButton! {
        didSet {
            oltPopup.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var containerViewAddress: UIView!
    @IBOutlet weak var txtAddress: HoshiTextField! {
        didSet{
            txtAddress.delegate = self
        }
    }
    @IBOutlet weak var containerViewMap: UIView!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            
        }
    }
    @IBOutlet weak var txtLatitude: HoshiTextField!
    @IBOutlet weak var txtLongitude: HoshiTextField!
    @IBOutlet weak var containerViewFeatureAdd: UIView! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                containerViewFeatureAdd.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblFeatureAdd: UILabel!
    @IBOutlet weak var oltCheck: UIButton!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var oltPostAdd: UIButton! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltPostAdd.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var containerViewBumpUpAds: UIView! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                containerViewBumpUpAds.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgCheckBump: UIImageView!
    @IBOutlet weak var lblBumpText: UILabel!
    
    
    
    @IBOutlet weak var btnTermCondition: UIButton!
    @IBOutlet weak var txtTermCondition: UITextField!
    @IBOutlet weak var imgViewCheckBox: UIImageView!
    @IBOutlet weak var btnCheckBoxTermCond: UIButton!
    
    
    
    //MARK:- Properties
    let locationDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.locationDropDown
        ]
    }()
    
    var popUpArray = [String]()
    var hasSubArray = [Bool]()
    var locationIdArray = [String]()
    
    var hasSub = false
    var selectedID = ""
    
    var popUpTitle = ""
    var popUpConfirm = ""
    var popUpCancel = ""
    var popUpText = ""
    
    let map = GMSMapView()
    let locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 25.276987, longitude: 55.296249)
    
    var latitude = ""
    var longitude = ""
    // var objFieldData = [AdPostField]()
    var valueArray = [String]()
    
    var localVariable = ""
    var isSimpleAddress = true
    
    //this array get data from previous controller
    var objArray = [AdPostField]()
    
    
    var imageIdArray = [Int]()
    var descriptionText = ""
    
    var addInfoDictionary = [String: Any]()
    var customDictionary = [String: Any]()
    var customArray = [AdPostField]()
    var imageArray = AddsHandler.sharedInstance.adPostImagesArray
    // get values in populate data and send it with parameters
    var phone_number = ""
    var address = ""
    
    var isFeature = "false"
    var isBump = false
    var localDictionary = [String: Any]()
    var selectedCountry = ""
    var isTermCond = false
    var termCondURL = ""
    let defaults = UserDefaults.standard
    
    var mapBoxLat = ""
    var mapBoxLong = ""
    var mapBoxPlace = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.populateData()
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        
        for item in objArray {
            print(item.fieldTypeName, item.fieldName, item.fieldVal, item.fieldType)
        }
        
        let whiteColorAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        let attributePlaceHolder = NSAttributedString(string: "Search", attributes: whiteColorAttribute)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributePlaceHolder
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(whiteColorAttribute, for: .normal)
        
        if defaults.bool(forKey: "isRtl") {
            txtName.textAlignment = .right
            txtNumber.textAlignment = .right
            txtAddress.textAlignment = .right
            txtLatitude.textAlignment = .right
            txtLongitude.textAlignment = .right
            txtTermCondition.textAlignment = .right
            oltPopup.contentHorizontalAlignment = .right
        } else {
            txtName.textAlignment = .left
            txtNumber.textAlignment = .left
            txtAddress.textAlignment = .left
            txtLatitude.textAlignment = .left
            txtLongitude.textAlignment = .left
            txtTermCondition.textAlignment = .left
            oltPopup.contentHorizontalAlignment = .left
        }
  
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Text Field Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if AddsHandler.sharedInstance.objAdPost != nil {

            let objData = AddsHandler.sharedInstance.objAdPost

            if isSimpleAddress == true{
                if objData?.data.profile.map.mapStyle == "google_map"{
                    let searchVC = GMSAutocompleteViewController()
                    searchVC.delegate = self
                    searchVC.modalPresentationStyle = .fullScreen
                    self.presentVC(searchVC)
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let mapBoxPlaceVc = storyboard.instantiateViewController(withIdentifier: MapBoxPlacesViewController.className) as! MapBoxPlacesViewController
                    mapBoxPlaceVc.delegate = self
                    mapBoxPlaceVc.modalPresentationStyle = .fullScreen
                    self.presentVC(mapBoxPlaceVc)
                }
            }else{
                address = txtAddress.text!
            }
            
           

        }
        
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func latLong(lat: String, long: String,place:String) {
      
        mapBoxLat = lat
        mapBoxLong = long
        
        self.txtLatitude.text = lat
        self.txtLatitude.text = long
        
        self.latitude = lat
        self.longitude = long
        self.txtAddress.text = place
        self.address = place
        initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        self.centerMapOnLocation(location: initialLocation)
        self.addAnnotations(coords: [initialLocation])
        
       }
    
    func populateData() {
        if AddsHandler.sharedInstance.objAdPost != nil {
            let objData = AddsHandler.sharedInstance.objAdPost
            
            if let pageTitle = objData?.data.title {
                self.title = pageTitle
            }
            if let infoText = objData?.extra.userInfo {
                self.lblUserinfo.text = infoText
            }
            if let nameText = objData?.data.profile.name.title {
                self.txtName.placeholder = nameText
            }
            if  let name = objData?.data.profile.name.fieldVal {
                self.txtName.text = name
            }
            
            if let nmbrText = objData?.data.profile.phone.title {
                self.txtNumber.placeholder = nmbrText
            }
            if let nmbr = objData?.data.profile.phone.fieldVal {
                self.txtNumber.text = nmbr
                self.phone_number = nmbr
            }
            
            if let termsCond = objData?.extra {
                self.txtTermCondition.text = termsCond.termsCondition
                self.btnTermCondition.setTitle(termsCond.termsUrl, for: .normal)
                self.termCondURL = termsCond.termsUrl
            }
            
            var isPhoneEdit = false
            if let editNumber = objData?.data.profile.phoneEditable {
                isPhoneEdit = editNumber
            }
            
            if isPhoneEdit {
                self.txtNumber.isEnabled = true
            }
            else if isPhoneEdit == false {
                self.txtNumber.isEnabled = false
            }
            
            if let addressText = objData?.data.profile.location.title {
                self.txtAddress.placeholder = addressText
               
            }
            
            if let addressValue = objData?.data.profile.location.fieldVal {
                self.txtAddress.text = addressValue
                self.address = addressValue
            }
            
            guard let isMapShow = objData?.data.profile.map.onOff else {
                return
            }
            isSimpleAddress = isMapShow
            if isMapShow {
                
                if let latText = objData?.data.profile.map.locationLat.title {
                    self.txtLatitude.placeholder = latText
                }
                
                if let latValue =  objData?.data.profile.map.locationLat.fieldVal {
                    self.txtLatitude.text = latValue
                }
                
                if let longText = objData?.data.profile.map.locationLong.title {
                    self.txtLongitude.placeholder = longText
                }
                
                if let longValue = objData?.data.profile.map.locationLong.fieldVal {
                    self.txtLongitude.text = longValue
                }
                if let lat = objData?.data.profile.map.locationLat.fieldVal {
                    self.latitude = lat
                }
                if let long = objData?.data.profile.map.locationLong.fieldVal {
                    self.longitude = long
                }
                
                if latitude != "" && longitude != "" {
                    initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                }
                self.centerMapOnLocation(location: initialLocation)
                self.addAnnotations(coords: [initialLocation])
                self.setupView()
            }
                
            else if isMapShow == false {
                containerViewMap.isHidden = true
                containerViewFeatureAdd.translatesAutoresizingMaskIntoConstraints = false
                containerViewFeatureAdd.topAnchor.constraint(equalTo: self.containerViewAddress.bottomAnchor, constant: 20).isActive = true
            }
            
            guard let isShowCountry = objData?.data.profile.adCountryShow else {
                return
            }
            if isShowCountry {
                for values in (objData?.data.profile.adCountry.values)! {
                    var i = 1
                    if values.id == "" {
                        continue
                    }
                    self.popUpArray.append(values.name)
                    self.hasSubArray.append(values.hasSub)
                    self.locationIdArray.append(String(values.id))
                    if i == 1 {
                        self.oltPopup.setTitle(values.name, for: .normal)
                    }
                    
                    i = i + 1
                }
                //location popup method call here after asigning data
                self.locationPopup()
            }
                
            else if isShowCountry == false {
                self.containerViewPopup.isHidden = true
                containerViewAddress.translatesAutoresizingMaskIntoConstraints = false
                containerViewAddress.topAnchor.constraint(equalTo: self.txtNumber.bottomAnchor, constant: 8).isActive = true
            }
            
            if let locationText = objData?.data.profile.adCountry.title {
                self.lblLocation.text = locationText
            }
            
            guard let featuredAdBuy = objData?.data.profile.featuredAdBuy else {
                return
            }
            
            if featuredAdBuy {
                if let checkButtonTitle = objData?.data.profile.featuredAdNotify.btn {
                    self.oltCheck.setTitle(checkButtonTitle, for: .normal)
                    self.oltCheck.backgroundColor = Constants.hexStringToUIColor(hex: "#00a2ff")
                    imgCheckBox.image = nil
                }
                if let featureTitle = objData?.data.profile.featuredAdNotify.text {
                    self.lblFeatureAdd.text = featureTitle
                }
            }
            
            guard let featureAdShow = objData?.data.profile.featuredAdIsShow else {
                return
            }
            
             if featureAdShow {
                  imgCheckBox.image = #imageLiteral(resourceName: "uncheck")
                if let featureAdText = objData?.data.profile.featuredAd.title {
                    self.lblFeatureAdd.text = featureAdText
                }
                
                if let titlePop = objData?.data.profile.featuredAdText.title {
                    self.popUpTitle = titlePop
                }
                if let textPop = objData?.data.profile.featuredAdText.text {
                    self.popUpText = textPop
                }
                if let okPop = objData?.data.profile.featuredAdText.btnOk {
                    self.popUpConfirm = okPop
                }
                
                if let cancelPop = objData?.data.profile.featuredAdText.btnNo {
                    self.popUpCancel = cancelPop
                }
            }
            if featureAdShow == false && featuredAdBuy == false {
                    containerViewFeatureAdd.isHidden = true
            }
            if let postButtonTitle =  objData?.data.btnSubmit {
                self.oltPostAdd.setTitle(postButtonTitle, for: .normal)
            }
            
            guard let isShowBump = objData?.data.profile.bumpAdIsShow else {
                return
            }
            if isShowBump {
                imgCheckBump.image = #imageLiteral(resourceName: "uncheck")
                if let bumpText = objData?.data.profile.bumpAd.title {
                    lblBumpText.text = bumpText
                }
            } else {
                containerViewBumpUpAds.isHidden = true
                containerViewFeatureAdd.translatesAutoresizingMaskIntoConstraints = false
                containerViewFeatureAdd.topAnchor.constraint(equalTo: self.containerViewMap.bottomAnchor, constant: 8).isActive = true
            }
        }
    }
    
    
    //MARK:- SetUp Drop Down
    func locationPopup() {
        locationDropDown.anchorView = oltPopup
        locationDropDown.dataSource = popUpArray
        locationDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.oltPopup.setTitle(item, for: .normal)
            self.selectedCountry = item
            self.hasSub = self.hasSubArray[index]
            self.selectedID = self.locationIdArray[index]
            print(self.selectedID)
            
            if self.hasSub {
                let param: [String: Any] = ["ad_country" : self.selectedID]
                print(param)
                self.subLocations(param: param as NSDictionary)
            }
        }
    }
    
    //MARK:- Sub Locations Delegate Method

    func subCategoryDetails(name: String, id: Int, hasSubType: Bool, hasTempelate: Bool, hasCatTempelate: Bool) {
      
        if hasSubType {
            let param: [String: Any] = ["ad_country" : id]
            print(param)
            self.subLocations(param: param as NSDictionary)
            self.selectedID = String(id)
        }
        else {
            self.oltPopup.setTitle(name, for: .normal)
            self.selectedID = String(id)
        }
    }
   
    // Google Places Delegate Methods
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
        txtAddress.text = place.formattedAddress
        self.address = place.formattedAddress!
        self.txtLatitude.text = String(place.coordinate.latitude)
        self.txtLongitude.text = String(place.coordinate.longitude)
        self.latitude = String(place.coordinate.latitude)
        self.longitude = String(place.coordinate.longitude)
        self.dismissVC(completion: nil)
        
        if latitude != "" && longitude != "" {
            initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        }
        self.centerMapOnLocation(location: initialLocation)
        self.addAnnotations(coords: [initialLocation])
        self.setupView()
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismissVC(completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismissVC(completion: nil)
    }
    
    //MARK:- Map View Delegate Methods
    
    func setupView (){
        mapView.delegate = self
        mapView.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Map
    func centerMapOnLocation (location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func addAnnotations(coords: [CLLocation]){
        
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            mapView.addAnnotation(anno);
        }
    }
    
    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else {
            let pinIdent = "Pin"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
            }
            return pinView;
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.latitude = String(location.coordinate.latitude)
        self.longitude = String(location.coordinate.longitude)
        self.txtLatitude.text = self.latitude
        self.txtLongitude.text = self.longitude
        self.mapView.setRegion(region, animated: true)
    }
    
    //MARK:- IBActions
    
    @IBAction func actionPopup(_ sender: Any) {
        locationDropDown.show()
    }
    
    @IBAction func actionCheck(_ sender: Any) {
        if AddsHandler.sharedInstance.objAdPost != nil {
            let objData = AddsHandler.sharedInstance.objAdPost
            guard let isFeatureBuy = objData?.data.profile.featuredAdBuy else {
                return
            }
            if isFeatureBuy {
                if let featureTitle = objData?.data.profile.featuredAdNotify.text {
                    self.showToast(message: featureTitle)
                }
            } else if isFeatureBuy == false {
                self.imgCheckBox.image = #imageLiteral(resourceName: "check")
                let alert = UIAlertController(title: popUpTitle, message: popUpText, preferredStyle: .alert)
                let confirm = UIAlertAction(title: popUpConfirm, style: .default) { (action) in
                    self.imgCheckBox.image = #imageLiteral(resourceName: "check")
                    self.isFeature = "true"
                }
                let cancel = UIAlertAction(title: popUpCancel, style: .default) { (action) in
                    self.imgCheckBox.image =  #imageLiteral(resourceName: "uncheck")
                }
                alert.addAction(cancel)
                alert.addAction(confirm)
                self.presentVC(alert)
            }
        }
    }
    
    @IBAction func actionBumpAd(_ sender: UIButton) {
        if AddsHandler.sharedInstance.objAdPost != nil {
            let objData = AddsHandler.sharedInstance.objAdPost
            self.imgCheckBump.image = #imageLiteral(resourceName: "check")
            var title = ""
            var message = ""
            var confirm = ""
            var cancel = ""
            
            if let tit = objData?.data.profile.bumpAdText.title {
                title = tit
            }
            if let msg = objData?.data.profile.bumpAdText.text {
                message = msg
            }
            if let con = objData?.data.profile.bumpAdText.btnOk {
                confirm = con
            }
            if let can = objData?.data.profile.bumpAdText.btnNo {
                cancel = can
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirm, style: .default) { (action) in
                self.imgCheckBump.image = #imageLiteral(resourceName: "check")
                self.isBump = true
            }
            let cancelAction = UIAlertAction(title: cancel, style: .default) { (action) in
                self.imgCheckBump.image = #imageLiteral(resourceName: "uncheck")
            }
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.presentVC(alert)
        }
    }
    
    
    @IBAction func btnTermConditionClicked(_ sender: UIButton) {
        
        let inValidUrl:String = "Invalid url"
        
        if #available(iOS 10.0, *) {
            if verifyUrl(urlString: termCondURL) == false {
                Constants.showBasicAlert(message: inValidUrl)
            }else{
                UIApplication.shared.open(URL(string: termCondURL)!, options: [:], completionHandler: nil)
            }
            
        } else {
            if verifyUrl(urlString: termCondURL) == false {
                Constants.showBasicAlert(message: inValidUrl)
            }else{
                UIApplication.shared.openURL(URL(string: termCondURL)!)
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    @IBAction func btnCheckBoxTermCondClicked(_ sender: UIButton) {
        
        if isTermCond == false{
            self.imgViewCheckBox.image = UIImage(named: "check")
            isTermCond = true
        }else{
            self.imgViewCheckBox.image = UIImage(named: "uncheck")
            isTermCond = false
        }
        
    }
    
    @IBAction func actionPostAdd(_ sender: Any) {
        
        if isSimpleAddress == false
        {
            address = txtAddress.text!
        }
        
        if address == ""
        {
            self.txtAddress.shake(6, withDelta: 10, speed: 0.06)
        }
        else if isTermCond == false
        {
            self.txtTermCondition.shake(6, withDelta: 10, speed: 0.06)
        }
        else
        {
            var parameter: [String: Any] = [
                "images_array": imageIdArray,
                "ad_phone": self.txtNumber.text!, //phone_number,
                "ad_location": address,
                "location_lat": latitude,
                "location_long": longitude,
                "ad_country": selectedID,   //selectedCountry,
                "ad_featured_ad": isFeature,
                "ad_id": AddsHandler.sharedInstance.adPostAdId,
                "ad_bump_ad": isBump,
                "name": self.txtName.text!
            ]
      
            print(parameter)
            let dataArray = objArray
            print(objArray)
            
            for (_, value) in dataArray.enumerated()
            {
                if value.fieldVal == ""
                {
                    continue
                }
                
                if customArray.contains(where: { $0.fieldTypeName == value.fieldTypeName})
                {
                    if value.fieldType == "checkbox"
                    {
                        let points = value.fieldVal
                        let pointsArr = points!.components(separatedBy: ",")
                        print(pointsArr)
                        let uni = uniq(source: pointsArr)
                        print(uni)

                        let formattedArray = (uni.map{String($0)}).joined(separator: ",")
                        print(formattedArray)

                        customDictionary[value.fieldTypeName] = formattedArray//value.fieldVal
                        print(customDictionary)
                    }
                    else
                    {
                        customDictionary[value.fieldTypeName] = value.fieldVal
                        print(customDictionary)
                    }


                }
                else
                {
                    addInfoDictionary[value.fieldTypeName] = value.fieldVal
                    print(addInfoDictionary)
                }
            }
                customDictionary.merge(with: localDictionary)
                let custom = Constants.json(from: customDictionary)
                if AddsHandler.sharedInstance.isCategoeyTempelateOn
                {
                    let param: [String: Any] = ["custom_fields": custom!]
                    parameter.merge(with: param)
                }
                parameter.merge(with: addInfoDictionary)
                parameter.merge(with: customDictionary) //Added by Furqan
                print(parameter)
                //self.dummy(param: parameter as NSDictionary)
                self.postAd(param: parameter as NSDictionary)
        }
//            for (_, value) in dataArray.enumerated() {
//                if value.fieldVal == "" {
//                    continue
//                }
//                if customArray.contains(where: { $0.fieldTypeName == value.fieldTypeName}) {
//                    customDictionary[value.fieldTypeName] = value.fieldVal
//                    print(customDictionary)
//                }
//                else {
//                    addInfoDictionary[value.fieldTypeName] = value.fieldVal
//                    print(addInfoDictionary)
//                }
//            }
//
//            customDictionary.merge(with: localDictionary)
//            let custom = Constants.json(from: customDictionary)
//            if AddsHandler.sharedInstance.isCategoeyTempelateOn {
//                let param: [String: Any] = ["custom_fields": custom!]
//                parameter.merge(with: param)
//            }
//            parameter.merge(with: addInfoDictionary)
//            parameter.merge(with: customDictionary) //Added by Furqan
//            print(parameter)
//             //self.dummy(param: parameter as NSDictionary)
//            self.postAd(param: parameter as NSDictionary)
//        }
    }
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    //MARK:- API Call
    //Post Add
    func postAd(param: NSDictionary) {
        self.showLoader()
        AddsHandler.adPostLive(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                self.presentVC(alert)
                self.imageIdArray.removeAll()
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
    
    // sub locations
    func subLocations(param: NSDictionary) {
        self.showLoader()
        AddsHandler.adPostSubLocations(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objSearchCategory = successResponse.data
                let searchCatVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchCategoryDetail") as! SearchCategoryDetail
                searchCatVC.dataArray = successResponse.data.values
                searchCatVC.modalPresentationStyle = .overCurrentContext
                searchCatVC.modalTransitionStyle = .crossDissolve
                searchCatVC.delegate = self
                self.presentVC(searchCatVC)
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
}
