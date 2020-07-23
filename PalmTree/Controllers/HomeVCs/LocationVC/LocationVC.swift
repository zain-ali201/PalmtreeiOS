//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreLocation

class LocationVC: UIViewController, CLLocationManagerDelegate
{   
    //MARK:- Properties
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var locView: UIView!
    
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locView.layer.cornerRadius = 5.0
        
        if userDetail?.currentAddress != ""
        {
            lblLocation.text = userDetail?.currentAddress
        }
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblHeading.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDistance.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        locationManager.requestWhenInUseAuthorization()
        
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
    
    @IBAction func backBtnACtion(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locBtnAction(_ sender: Any)
    {
        locView.alpha = 1
        //Location manager
        getGPSLocation()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any)
    {
        locView.alpha = 0
    }
    
    //MARK:- Cutom Functions
        
    func getGPSLocation()
    {
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            userDetail?.currentLocation = currentLoc
            
            if userDetail?.currentLocation != nil
            {
                geocoder.reverseGeocodeLocation(currentLoc) { (placemarks, error) in
                    self.processResponse(withPlacemarks: placemarks, error: error)
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        print("Location: \(location)")
        userDetail?.currentLocation = location
        
        if userDetail?.currentLocation != nil
        {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View

        if let error = error
        {
            print("Unable to Reverse Geocode Location (\(error))")
        }
        else
        {
            if let placemarks = placemarks, let placemark = placemarks.first
            {
                userDetail?.currentAddress = placemark.compactAddress ?? ""
                userDetail?.country = placemark.currentCountry ?? ""
                defaults.set(userDetail?.currentAddress, forKey: "address")
                defaults.set(userDetail?.country, forKey: "country")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
