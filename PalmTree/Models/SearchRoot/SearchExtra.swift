//
//  SearchExtra.swift
//  PalmTree
//
//  Created by SprintSols on 5/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SearchExtra {
    
    var dialgCancel : String!
    var dialogSend : String!
    var fieldTypeName : String!
    var searchBtn : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        dialgCancel = dictionary["dialg_cancel"] as? String
        dialogSend = dictionary["dialog_send"] as? String
        fieldTypeName = dictionary["field_type_name"] as? String
        searchBtn = dictionary["search_btn"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if dialgCancel != nil{
            dictionary["dialg_cancel"] = dialgCancel
        }
        if dialogSend != nil{
            dictionary["dialog_send"] = dialogSend
        }
        if fieldTypeName != nil{
            dictionary["field_type_name"] = fieldTypeName
        }
        if searchBtn != nil{
            dictionary["search_btn"] = searchBtn
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
