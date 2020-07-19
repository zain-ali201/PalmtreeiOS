//
//  TFNearbyUsersViewController.swift
//  TaskForce
//
//  Created by DB MAC MINI on 8/30/17.
//  Copyright © 2017 Devbatch(Pvt) Ltd. All rights reserved.
//

import UIKit
import MapKit

class MapViewController:  UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 25.276987, longitude: 55.296249)
    var latitudeStr = ""
    var longitudeStr = ""
    
    var fromVC = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        if latitudeStr != ""
        {
            initialLocation = CLLocation(latitude: Double(latitudeStr)!, longitude: Double(longitudeStr)!)
            self.centerMapOnLocation(location: initialLocation)
            self.addAnnotations(coords: [initialLocation])
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
}
