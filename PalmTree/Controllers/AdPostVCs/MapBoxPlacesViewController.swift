//
//  MapBoxPlacesViewController.swift
//  MapBoxNew
//
//  Created by SprintSols on 10/28/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import MapboxGeocoder
import Mapbox

import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


protocol latLongitudePro {
    func latLong(lat:String,long:String,place:String)
}

class MapBoxPlacesViewController: UIViewController, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    // MARK: - Variables
    var mapView: MGLMapView!
    var resultsLabel: UILabel!
    var geocoder: Geocoder!
    var geocodingDataTask: URLSessionDataTask?
    
    var searchActive : Bool = false  //for controlling search states
      //the searchbar to be added in navigation bar
    var searchedPlaces: NSMutableArray = []
    let decoder = JSONDecoder()
    var delegate : latLongitudePro?
    
    static var mapbox_api = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardWillShowNotification()
    }
    
    @IBAction func crossBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func keyboardWasShown (notification: NSNotification)
    {
        let info = notification.userInfo
        let frame = info![UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = frame?.cgRectValue.size
        var contentInsets:UIEdgeInsets

        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        }
        else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.width, 0.0)
        }

        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(false, animated: false)
    }
    
    func cancelSearching(){
        searchActive = false;
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchMe), object: nil)
        self.perform(#selector(self.searchMe), with: nil, afterDelay: 0.5)
        
        if(searchBar.text!.isEmpty)
        {
            searchActive = false;
        }
        else
        {
            searchActive = true;
        }
    }

    @objc func searchMe()
    {
        if(searchBar?.text!.isEmpty)!
        {
            self.searchedPlaces = []
            self.tableView.reloadData()
        }
        else
        {
            self.searchPlaces(query: (searchBar?.text)!)
        }
    }
    
     func searchPlaces(query: String)
     {
        let urlStr = "\(MapBoxPlacesViewController.mapbox_api)\(query).json?access_token=\(mapboxToken)"
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { (dataResponse) in
            
            if dataResponse.result.isSuccess {
                let resJson = JSON(dataResponse.result.value!)
                if let myjson = resJson["features"].array {
                    for itemobj in myjson {
                        try? print(itemobj.rawData())
                        do {
                            let place = try self.decoder.decode(Feature.self, from: itemobj.rawData())
                            
                            self.searchedPlaces.insert(place, at: 0)
                            self.tableView.reloadData()
                        } catch let error  {
                            if let error = error as? DecodingError {
                                print(error.errorDescription!)
                            }
                        }
                    }
                }
            }
            
            if dataResponse.result.isFailure {
                let error : Error = dataResponse.result.error!
                print(error)
            }
        }
    }
    
    // MARK: - MGLMapViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedPlaces.count
       }
      
       func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
           geocodingDataTask?.cancel()
       }
       
       func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
           geocodingDataTask?.cancel()
           let options = ReverseGeocodeOptions(coordinate: mapView.centerCoordinate)
           geocodingDataTask = geocoder.geocode(options) { [unowned self] (placemarks, attribution, error) in
               if let error = error {
                   NSLog("%@", error)
               } else if let placemarks = placemarks, !placemarks.isEmpty {
                   self.resultsLabel.text = placemarks[0].qualifiedName
               } else {
                   self.resultsLabel.text = "No results"
               }
           }
       }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.detailTextLabel?.textColor = UIColor.darkGray
    
            let pred = self.searchedPlaces.object(at: indexPath.row) as! Feature
            cell.textLabel?.text = pred.place_name!
            if let add = pred.properties.address {
                cell.detailTextLabel?.text = add
            } else { }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let pred = self.searchedPlaces.object(at: indexPath.row) as! Feature
        let coord = CLLocationCoordinate2D.init(latitude: pred.geometry.coordinates[1], longitude: pred.geometry.coordinates[0])
        
        print(coord)
        let latString = "\(coord.latitude)"
        let longString = "\(coord.longitude)"
        
        delegate?.latLong(lat: latString, long: longString, place: pred.place_name!)
        
        self.dismissVC(completion: nil)
    }
}



struct Feature: Codable {
    var id: String!
    var type: String?
    var matching_place_name: String?
    var place_name: String?
    var geometry: Geometry
    var center: [Double]
    var properties: Properties
}

struct Geometry: Codable {
    var type: String?
    var coordinates: [Double]
}

struct Properties: Codable {
    var address: String?
}
