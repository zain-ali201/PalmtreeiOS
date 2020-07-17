//
//  TFNearbyUsersViewController.swift
//  TaskForce
//
//  Created by DB MAC MINI on 8/30/17.
//  Copyright © 2017 Devbatch(Pvt) Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class PlaceCell: UITableViewCell
{
    @IBOutlet weak var lblLocation: UILabel!
}

class PlaceDTO: NSObject
{
    var placeID:String!
    var placeName: String!
    var longitude: String!
    var latitude: String!
}

class LocationViewController:  UIViewController, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var locView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var pinView: UIImageView!
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    var latitudeStr : String!
    var longitudeStr : String!
    var latitude : Double!
    var longitude : Double!
    
    var locationName : String!
    
    var locContactVC: LocationContactVC!
    
    var locationManager = CLLocationManager()
    
    var placesArray:[PlaceDTO] = []
    
    var fromVC = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locView.layer.cornerRadius = 10
        locView.layer.masksToBounds = true

        locationBtn.isUserInteractionEnabled = false
        updateMapLocation()
        
        mapView.isMyLocationEnabled = true
        
        mapView.delegate = self
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
    
    func updateMapLocation()
    {
        if latitudeStr != nil && longitudeStr != nil && latitudeStr != "0.0"
        {
            let camera = GMSCameraPosition.camera(withLatitude: Double(latitudeStr!)!, longitude: Double(longitudeStr!)!, zoom: 15.0)
            mapView.camera = camera
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            pinView.alpha  = 1
        }
        else if userDetail?.currentLocation != nil && userDetail?.currentLocation.coordinate.latitude != 0.0
        {
            let camera = GMSCameraPosition.camera(withLatitude: (userDetail?.currentLocation.coordinate.latitude)!, longitude: (userDetail?.currentLocation.coordinate.longitude)!, zoom: 15.0)
            mapView.camera = camera

            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            pinView.alpha  = 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func getLocationName(location: CLLocation)
    {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
            }
            else
            {
                if let placemark = placemarks?[0]
                {
                    var address:String = placemark.name ?? ""
                    
//                    if let street = placemark.thoroughfare {
//                        address += ", \(street)"
//                    }
                    
                    if let city = placemark.locality {
                        address += ", \(city)"
                    }
                    
                    self.locationName = address
                    
                    DispatchQueue.main.async
                    {
                        self.locationBtn.isUserInteractionEnabled = true
                        self.locationBtn.setTitle(String(format: "    %@", self.locationName), for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func selectLocationAction(_ sender: Any)
    {
        imgView.image = mapView.takeScreenshot()
        lblLocation.text = locationName
        locView.alpha = 1
    }
    
    @IBAction func changeLocationAction(_ sender: Any)
    {
        locView.alpha = 0
    }
    
    @IBAction func saveLocationAction(_ sender: Any)
    {
        adDetailObj.location.lat = latitude
        adDetailObj.location.lng = longitude
        adDetailObj.location.address = locationName
        DispatchQueue.main.async
        {
            self.locContactVC.lblLocation.text = self.locationName
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: PlacePicker API
    @IBAction func searchBtnAction(_ sender: Any)
    {
        autocompleteClicked()
    }
    
    func autocompleteClicked()
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        latitudeStr = String(place.coordinate.latitude)
        longitudeStr = String(place.coordinate.longitude)
        
        updateMapLocation()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - GMMapViewDelegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        latitudeStr = String(position.target.latitude)
        longitudeStr = String(position.target.longitude)
        
//        taskDetailVC.parentVC.task.latitude = latitudeStr
//        taskDetailVC.parentVC.task.longitude = longitudeStr
        
        if latitudeStr != nil && latitudeStr != "0.0"
        {
            nearbyPlaces()
        }
        
        let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            // Check for errors
            if error != nil {
            }
            else
            {
                if let placemark = placemarks?[0]
                {
                    self.locationName = placemark.compactAddress ?? ""
                    
//                    self.locationName = placemark.name
                    DispatchQueue.main.async
                    {
                        self.locationBtn.isUserInteractionEnabled = true
                        self.locationBtn.setTitle(String(format: "    %@", self.locationName), for: .normal)
                        self.imgView.image = mapView.takeScreenshot()
                        self.lblLocation.text = self.locationName
                    }
                }
            }
        }
    }
    
    func nearbyPlaces()
    {
        let url = String(format: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=200&key=%@", latitudeStr, longitudeStr, Constants.googlePlacesAPIKey.placesKey)
        print(url)
        
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result
            {
                case .success:
                    let dict = response.result.value as? [String:Any]
                    
                    guard let array = dict?["results"] as? [Any], array.count > 0 else {
                        print("Expected 'results' array or Array is empty")
                        return
                    }
                    
//                    print(array)
                    self.placesArray = []
                    for resultDict in array
                    {
                        let place:PlaceDTO = PlaceDTO()
                        if let resultDict = resultDict as? [String : Any]
                        {
                            if let name = resultDict["name"] as? String,
                                let place_id = resultDict["place_id"] as? String,
                                let geometryDict = resultDict["geometry"] as? [String : Any]
                            {
                                if let locationDict = geometryDict["location"] as? [String : Any] {
                                    if let lat = locationDict["lat"] as? Double, let lng = locationDict["lng"] as? Double {
                                        place.placeID = place_id
                                        place.placeName = name
                                        place.latitude = String(format: "%f",lat)
                                        place.longitude = String(format: "%f",lng)
                                        self.placesArray.append(place)
                                        
                                    }
                                }
                            }
                        }
                    }
                    self.tblView.reloadData()
                    break
                case .failure(let error):
                    
                    print(error)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: PlaceCell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as! PlaceCell
        cell.lblLocation.text = placesArray[indexPath.row].placeName;
        
        return cell
    }
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let place: PlaceDTO = placesArray[indexPath.row]
        
        latitudeStr = place.latitude
        longitudeStr = place.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(latitudeStr!)!, longitude: Double(longitudeStr!)!, zoom: 15.0)
        mapView.camera = camera

        locView.alpha = 1
    }
}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
