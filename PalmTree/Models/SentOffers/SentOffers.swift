//
//  SentOffers.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SentOffers{
    
    var items : [SentOffersItem]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        items = [SentOffersItem]()
        if let itemsArray = dictionary["items"] as? [[String:Any]]{
            for dic in itemsArray{
                let value = SentOffersItem(fromDictionary: dic)
                items.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if items != nil{
            var dictionaryElements = [[String:Any]]()
            for itemsElement in items {
                dictionaryElements.append(itemsElement.toDictionary())
            }
            dictionary["items"] = dictionaryElements
        }
        return dictionary
    }
    
}
