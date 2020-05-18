//
//  AdPostMap.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostMap{
    
    var locationLat : AdPostLocation!
    var locationLong : AdPostLocation!
    var onOff : Bool!
    var mapStyle : String!
    
    init(fromDictionary dictionary: [String:Any]){
        if let locationLatData = dictionary["location_lat"] as? [String:Any]{
            locationLat = AdPostLocation(fromDictionary: locationLatData)
        }
        if let locationLongData = dictionary["location_long"] as? [String:Any]{
            locationLong = AdPostLocation(fromDictionary: locationLongData)
        }
        onOff = dictionary["on_off"] as? Bool
        mapStyle = dictionary["map_style"] as? String
    }
  
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if locationLat != nil{
            dictionary["location_lat"] = locationLat.toDictionary()
        }
        if locationLong != nil{
            dictionary["location_long"] = locationLong.toDictionary()
        }
        if onOff != nil{
            dictionary["on_off"] = onOff
        }
        return dictionary
    }
    
}
