//
//  LangData.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 17/06/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
struct LangData {
    
    var code : String!
    var flag_url : String!
    var native_name : String!
    var translated_name : String!
    var locale : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? String
        flag_url = dictionary["flag_url"] as? String
        native_name = dictionary["native_name"] as? String
        translated_name = dictionary["translated_name"] as? String
        locale = dictionary["locale"] as? String
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if flag_url != nil{
            dictionary["flag_url"] = flag_url
        }
        if native_name != nil{
            dictionary["native_name"] = native_name
        }
        if translated_name != nil{
            dictionary["translated_name"] = translated_name
        }
        if locale != nil{
            dictionary["locale"] = locale
        }
        return dictionary
    }
    
}
