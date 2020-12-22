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
        
        if userDetail?.locationName != ""
        {
            lblLocation.text = userDetail?.locationName
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
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any)
    {
        locView.alpha = 0
    }
    
    //MARK:- Cutom Functions
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        print("Location: \(location)")
        userDetail?.currentLocation = location
        
        userDetail?.currentLocation = location
        userDetail?.lat = location.coordinate.latitude
        userDetail?.lng = location.coordinate.longitude
        
        defaults.set(userDetail?.lat, forKey: "latitude")
        defaults.set(userDetail?.lng, forKey: "longitude")
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
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
                userDetail?.locationName = placemark.name ?? ""
                userDetail?.country = placemark.currentCountry ?? ""
                defaults.set(userDetail?.currentAddress, forKey: "address")
                defaults.set(userDetail?.locationName, forKey: "locName")
                defaults.set(userDetail?.country, forKey: "country")
                locationManager.stopUpdatingLocation()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
