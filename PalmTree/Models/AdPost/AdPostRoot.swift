//
//  AdPostRoot.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostRoot {
    
    var data : AdPostData!
    var extra : AdPostExtra!
    var message : String!
    var success : Bool!
    var isBid :Bool!
    var isRequiredImages : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = AdPostData(fromDictionary: dataData)
        }
        if let extraData = dictionary["extra"] as? [String:Any]{
            extra = AdPostExtra(fromDictionary: extraData)
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
        isBid = dictionary["bid_check"] as? Bool
        isRequiredImages = dictionary["is_required"] as? Bool
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
        if extra != nil{
            dictionary["extra"] = extra.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        if isRequiredImages != nil{
            dictionary["is_required"] = isRequiredImages
        }
        return dictionary
    }
    
}
