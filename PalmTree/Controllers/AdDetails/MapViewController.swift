//
//  TFNearbyUsersViewController.swift
//  TaskForce
//
//  Created by DB MAC MINI on 8/30/17.
//  Copyright © 2017 Devbatch(Pvt) Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController:  UIViewController, GMSMapViewDelegate
{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblAddress: UILabel!

    var latitude : Double!
    var longitude : Double!
    
    var address = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblAddress.text = address
        
        if latitude != nil && longitude != nil && latitude != 0
        {
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
            mapView.camera = camera
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            marker.map = mapView
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
