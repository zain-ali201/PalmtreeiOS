//
//  UserPublicRatingData.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserPublicRatingData{
    
    var canRate : Bool!
    var form : UserPublicRatingForm!
    var pageTitle : String!
    var rattings : [UserPublicRate]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        canRate = dictionary["can_rate"] as? Bool
        if let formData = dictionary["form"] as? [String:Any]{
            form = UserPublicRatingForm(fromDictionary: formData)
        }
        pageTitle = dictionary["page_title"] as? String
        rattings = [UserPublicRate]()
        if let rattingsArray = dictionary["rattings"] as? [[String:Any]]{
            for dic in rattingsArray{
                let value = UserPublicRate(fromDictionary: dic)
                rattings.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if canRate != nil{
            dictionary["can_rate"] = canRate
        }
        if form != nil{
            dictionary["form"] = form.toDictionary()
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if rattings != nil{
            var dictionaryElements = [[String:Any]]()
            for rattingsElement in rattings {
                dictionaryElements.append(rattingsElement.toDictionary())
            }
            dictionary["rattings"] = dictionaryElements
        }
        return dictionary
    }
    
}
