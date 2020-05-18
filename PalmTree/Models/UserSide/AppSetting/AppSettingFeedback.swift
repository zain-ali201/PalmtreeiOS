//
//  AppSettingFeedback.swift
//  PalmTree
//
//  Created by SprintSols on 9/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AppSettingFeedback{
    
    var form : AppSettingForm!
    var isShow : Bool!
    var subline : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let formData = dictionary["form"] as? [String:Any]{
            form = AppSettingForm(fromDictionary: formData)
        }
        isShow = dictionary["is_show"] as? Bool
        subline = dictionary["subline"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if form != nil{
            dictionary["form"] = form.toDictionary()
        }
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if subline != nil{
            dictionary["subline"] = subline
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
