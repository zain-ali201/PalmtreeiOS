//
//  HomeRoot.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeRoot{

   
    var data : HomeData!
    var message : String!
    var settings : HomeSettings!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = HomeData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        if let settingsData = dictionary["settings"] as? [String:Any]{
            settings = HomeSettings(fromDictionary: settingsData)
        }
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if settings != nil{
            dictionary["settings"] = settings.toDictionary()
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
}
