//
//  AdPostFeaturedAdText.swift
//  PalmTree
//
//  Created by SprintSols on 8/30/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostFeaturedAdText{
    
    var btnNo : String!
    var btnOk : String!
    var text : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnNo = dictionary["btn_no"] as? String
        btnOk = dictionary["btn_ok"] as? String
        text = dictionary["text"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btnNo != nil{
            dictionary["btn_no"] = btnNo
        }
        if btnOk != nil{
            dictionary["btn_ok"] = btnOk
        }
        if text != nil{
            dictionary["text"] = text
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
