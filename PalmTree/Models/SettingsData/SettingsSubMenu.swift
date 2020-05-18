//
//  SettingsSubMenu.swift
//  PalmTree
//
//  Created by SprintSols on 3/31/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsSubMenu {
    
    var hasPage : Bool!
    var pages : [SettingsPage]!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        hasPage = dictionary["has_page"] as? Bool
        pages = [SettingsPage]()
        if let pagesArray = dictionary["pages"] as? [[String:Any]]{
            for dic in pagesArray{
                let value = SettingsPage(fromDictionary: dic)
                pages.append(value)
            }
        }
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if hasPage != nil{
            dictionary["has_page"] = hasPage
        }
        if pages != nil{
            var dictionaryElements = [[String:Any]]()
            for pagesElement in pages {
                dictionaryElements.append(pagesElement.toDictionary())
            }
            dictionary["pages"] = dictionaryElements
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
