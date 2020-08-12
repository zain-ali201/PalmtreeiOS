//
//  TFNearbyUsersViewController.swift
//  TaskForce
//
//  Created by DB MAC MINI on 8/30/17.
//  Copyright © 2017 Devbatch(Pvt) Ltd. All rights reserved.
//

import UIKit
import Mapbox

class MapBoxViewController:  UIViewController
{
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var doneView: UIView!
    
    var latitudeStr : String!
    var longitudeStr : String!
    var latitude : Double!
    var longitude : Double!
    
    var address = ""
    var fromVC = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblAddress.text = address
        
        if fromVC == "detail"
        {
            searchBtn.alpha = 0
            doneView.alpha = 0
        }
        else
        {
            searchBtn.alpha = 1
            doneView.alpha = 1
        }
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        mapView.styleURL = url
        
        if latitudeStr != nil && longitudeStr != nil && latitudeStr != "0.0"
        {
            mapView.setCenter(CLLocationCoordinate2D(latitude: Double(latitudeStr!)!, longitude: Double(longitudeStr!)!), zoomLevel: 12, animated: true)
        }
        else if latitude != nil && longitude != nil && latitude != 0
        {
            mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoomLevel: 12, animated: true)
        }
        else if userDetail?.currentLocation != nil && userDetail?.currentLocation.coordinate.latitude != 0.0
        {
            mapView.setCenter(CLLocationCoordinate2D(latitude: (userDetail?.currentLocation.coordinate.latitude)!, longitude: (userDetail?.currentLocation.coordinate.longitude)!), zoomLevel: 12, animated: true)
        }
        else
        {
            mapView.setCenter(CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708), zoomLevel: 12, animated: true)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any)
    {
        let placesVC = self.storyboard?.instantiateViewController(withIdentifier: "MapBoxPlacesViewController") as! MapBoxPlacesViewController
        placesVC.modalPresentationStyle = .fullScreen
        self.present(placesVC, animated:true, completion: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: Any)
    {
        
    }
}
