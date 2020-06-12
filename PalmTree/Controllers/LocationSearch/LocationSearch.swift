//
//  LocationSearch.swift
//  PalmTree
//
//  Created by SprintSols on 5/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import RangeSeekSlider
import NVActivityIndicatorView
import CoreLocation
import MapKit
import GooglePlacePicker
import GoogleMaps

protocol NearBySearchDelegate {
    func nearbySearchParams(lat: Double, long: Double, searchDistance: CGFloat, isSearch: Bool)
}

class LocationSearch: UIViewController , RangeSeekSliderDelegate, NVActivityIndicatorViewable , CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate , UITextFieldDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.roundCorners()
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var viewImage: UIView!{
        didSet{
            viewImage.circularView()
        }
    }
    @IBOutlet weak var imgRoute: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var oltCancel: UIButton!{
        didSet {
            oltCancel.roundCornors()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltCancel.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    @IBOutlet weak var oltSubmit: UIButton!{
        didSet {
            oltSubmit.roundCornors()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltSubmit.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    @IBOutlet weak var seekBar: RangeSeekSlider!
    @IBOutlet weak var txtAddress: UITextField! {
        didSet {
            txtAddress.delegate = self
        }
    }
    
    
    //MARK:- Properties
    var delegate: NearBySearchDelegate?
    let defaults = UserDefaults.standard
    var nearByDistance : CGFloat = 0
    var maximumValue: CGFloat = 0.0
    var sliderStep: CGFloat = 0
    let locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var maxValue : CGFloat = 0.0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateData()
        self.hideBackButton()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Location Search")
       
        let whiteColorAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black]
        let attributePlaceHolder = NSAttributedString(string: "Search", attributes: whiteColorAttribute)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributePlaceHolder
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(whiteColorAttribute, for: .normal)
    }
    
   
    //MARK:- TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = GMSAutocompleteViewController()
        searchVC.delegate = self
        self.presentVC(searchVC)
    }
    
    // Google Places Delegate Methods
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place Name : \(place.name)")
        print("Place Address : \(place.formattedAddress ?? "null")")
        txtAddress.text = place.formattedAddress
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        self.dismissVC(completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismissVC(completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismissVC(completion: nil)
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func userLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        if locationManager.location != nil {
            if let lat = locationManager.location?.coordinate.latitude {
                self.latitude = lat
            }
            if let long = locationManager.location?.coordinate.longitude {
                self.longitude = long
            }
        }
    }

    func populateData() {
        if let settingsInfo = defaults.object(forKey: "settings") {
            let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
            let model = SettingsRoot(fromDictionary: settingObject)
            
            if let description = model.data.locationPopup.text {
                self.lblDescription.text = description
            }
            if let clearBtnText = model.data.locationPopup.btnClear {
                self.oltCancel.setTitle(clearBtnText, for: .normal)
            }
            if let submitBtnText = model.data.locationPopup.btnSubmit {
                self.oltSubmit.setTitle(submitBtnText, for: .normal)
            }
            if let sliderStepRange = model.data.locationPopup.sliderStep {
                self.sliderStep = CGFloat(sliderStepRange)
            }
            if let maxValue = model.data.locationPopup.sliderNumber {
                self.maxValue = CGFloat(maxValue)
            }
            if let txtPlaceHolder = model.data.locationPopup.currentLocation {
                txtAddress.placeholder = txtPlaceHolder
            }
        }
        self.userLocation()
        self.sliderSetting()
    }
    
    //MARK:- Range Slider Delegate
    func sliderSetting() {
        seekBar.delegate = self
        seekBar.disableRange = true
        seekBar.enableStep = true
        seekBar.step = sliderStep
        seekBar.selectedMinValue = 0
        seekBar.minDistance = 0
        seekBar.minValue = 0
        seekBar.maxDistance = maxValue
        seekBar.maxValue = maxValue
        if let bgColor = UserDefaults.standard.string(forKey: "mainColor") {
            seekBar.tintColor = Constants.hexStringToUIColor(hex: bgColor)
            seekBar.minLabelColor = Constants.hexStringToUIColor(hex: bgColor)
            seekBar.maxLabelColor = Constants.hexStringToUIColor(hex: bgColor)
            seekBar.handleColor = Constants.hexStringToUIColor(hex: bgColor)
            seekBar.handleBorderColor = Constants.hexStringToUIColor(hex: bgColor)
            seekBar.colorBetweenHandles = Constants.hexStringToUIColor(hex: bgColor)
            seekBar.initialColor = Constants.hexStringToUIColor(hex: bgColor)
        }
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === seekBar {
            let mxValue = maxValue
            self.maximumValue = mxValue
            self.nearByDistance = mxValue
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
    
    //MARK:- IBActions
    @IBAction func actionSubmit(_ sender: Any) {
        self.popVC {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: { (success) in
                self.delegate?.nearbySearchParams(lat: self.latitude, long: self.longitude, searchDistance: self.nearByDistance, isSearch: true)
            })
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.popVC(completion: nil)
            self.delegate?.nearbySearchParams(lat: self.latitude, long: self.longitude, searchDistance: 0, isSearch: false)
        }
    }
}
