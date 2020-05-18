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

let MapboxAccessToken = "pk.eyJ1IjoiZ2xpeGVuIiwiYSI6ImNrMmFkNXdjbjJpeHgzbG16bW5kZ3R5OGkifQ.sUMfX4HRKF9l3YorJ4a02A"

class MapBoxPlacesViewController: UIViewController,MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   

    
    // MARK: - Variables

      var mapView: MGLMapView!
      var resultsLabel: UILabel!
      var geocoder: Geocoder!
      var geocodingDataTask: URLSessionDataTask?
    
    
    var searchActive : Bool = false  //for controlling search states
    var searchBar:UISearchBar?   //the searchbar to be added in navigation bar
   // lazy   var searchBars:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    var searchedPlaces: NSMutableArray = []
    let decoder = JSONDecoder()
    var delegate : latLongitudePro?
    
    
    static var mapbox_api = "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    static var mapbox_access_token = "pk.eyJ1IjoiZ2xpeGVuIiwiYSI6ImNrMmFkNXdjbjJpeHgzbG16bW5kZ3R5OGkifQ.sUMfX4HRKF9l3YorJ4a02A"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self .cancelSearching()
        searchActive = false;
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
        if(searchBar.text!.isEmpty){
            searchActive = false;
        } else {
            searchActive = true;
        }
    }

    @objc func searchMe() {
        if(searchBar?.text!.isEmpty)!{ } else {
            self.searchPlaces(query: (searchBar?.text)!)
        }
    }
    
    
     func searchPlaces(query: String) {
        let urlStr = "\(MapBoxPlacesViewController.mapbox_api)\(query).json?access_token=\(MapBoxPlacesViewController.mapbox_access_token)"
        

        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseSwiftyJSON { (dataResponse) in
            
            if dataResponse.result.isSuccess {
                let resJson = JSON(dataResponse.result.value!)
                if let myjson = resJson["features"].array {
                    for itemobj in myjson {
                        try? print(itemobj.rawData())
                        do {
                            let place = try self.decoder.decode(Feature.self, from: itemobj.rawData())
                            self.searchedPlaces.add(place)
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.detailTextLabel?.textColor = UIColor.darkGray
    
            let pred = self.searchedPlaces.object(at: indexPath.row) as! Feature
            cell.textLabel?.text = pred.place_name!
            if let add = pred.properties.address {
                cell.detailTextLabel?.text = add
            } else { }
        //cell.imageView?.image = UIImage(.)
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
//        if let bgColor = UserDefaults.standard.string(forKey: "mainColor"){
//            headerView.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
//            tableView.backgroundColor =  Constants.hexStringToUIColor(hex: bgColor)
//            view.backgroundColor =  Constants.hexStringToUIColor(hex: bgColor)
//        }
        
        let btn: UIButton = UIButton(frame: CGRect(x:5, y:0, width:25, height:40))
       
        btn.addTarget(self, action: #selector(closeAction), for: UIControlEvents.touchUpInside)
            
        btn.setImage(UIImage(named: "cancel-music"), for: .normal)
        headerView.addSubview(btn)
        
     
        if self.searchBar == nil {
            self.searchBar = UISearchBar()
            self.searchBar?.frame = CGRect(x:30, y:0, width:tableView.frame.width - 30, height:40)
            self.searchBar!.searchBarStyle = UISearchBar.Style.minimal
            self.searchBar!.tintColor = UIColor.black
            self.searchBar!.barTintColor = UIColor.white
            self.searchBar!.delegate = self

            self.searchBar!.placeholder = "Search for place";
            let leftNavBarButton = UIBarButtonItem(customView: searchBar!)
            self.navigationItem.leftBarButtonItem = leftNavBarButton
        }
        
        headerView.addSubview(searchBar!)
       return headerView
       }

    
    @objc func closeAction(){
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
