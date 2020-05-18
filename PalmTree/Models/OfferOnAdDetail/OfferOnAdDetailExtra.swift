//
//  OfferOnAdDetailExtra.swift
//  PalmTree
//
//  Created by SprintSols on 4/15/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct OfferOnAdDetailExtra{
    
    var pageTitle : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pageTitle = dictionary["page_title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        return dictionary
    }
    
}
