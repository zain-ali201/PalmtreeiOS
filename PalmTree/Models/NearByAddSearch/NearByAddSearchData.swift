//
//  NearByAddSearchData.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct NearByAddSearchData{
    
    var distance : Int!
    var lat : NearByAddSearchLat!
    var longField : NearByAddSearchLat!
    var radius : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        distance = dictionary["distance"] as? Int
        if let latData = dictionary["lat"] as? [String:Any]{
            lat = NearByAddSearchLat(fromDictionary: latData)
        }
        if let longFieldData = dictionary["long"] as? [String:Any]{
            longField = NearByAddSearchLat(fromDictionary: longFieldData)
        }
        radius = dictionary["radius"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if distance != nil{
            dictionary["distance"] = distance
        }
        if lat != nil{
            dictionary["lat"] = lat.toDictionary()
        }
        if longField != nil{
            dictionary["long"] = longField.toDictionary()
        }
        if radius != nil{
            dictionary["radius"] = radius
        }
        return dictionary
    }
    
}
