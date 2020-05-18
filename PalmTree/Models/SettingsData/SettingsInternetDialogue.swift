//
//  SettingsInternetDialogue.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation


struct SettingsInternetDialogue {
   
    var cancelBtn : String!
    var okBtn : String!
    var text : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cancelBtn = dictionary["cancel_btn"] as? String
        okBtn = dictionary["ok_btn"] as? String
        text = dictionary["text"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cancelBtn != nil{
            dictionary["cancel_btn"] = cancelBtn
        }
        if okBtn != nil{
            dictionary["ok_btn"] = okBtn
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
