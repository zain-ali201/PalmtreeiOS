//
//  ProfileDetailsRoot.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsRoot {
    
    var data : ProfileDetailsData!
    var extraText : ProfileDetailsTexts!
    var message : String!
    var success : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = ProfileDetailsData(fromDictionary: dataData)
        }
        if let extraTextData = dictionary["extra_text"] as? [String:Any]{
            extraText = ProfileDetailsTexts(fromDictionary: extraTextData)
        }
        message = dictionary["message"] as? String
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
        if extraText != nil{
            dictionary["extra_text"] = extraText.toDictionary()
        }
//        if extraData != nil {
//            dictionary[""]
//        }
        
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
