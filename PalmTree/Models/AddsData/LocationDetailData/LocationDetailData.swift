//
//  LocationDetailData.swift
//  PalmTree
//
//  Created by SprintSols on 9/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct LocationDetailData{
    
    var pageTitle : String!
    var pagination : LocationDetailPagination!
    var terms : [LocationDetailTerm]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pageTitle = dictionary["page_title"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = LocationDetailPagination(fromDictionary: paginationData)
        }
        terms = [LocationDetailTerm]()
        if let termsArray = dictionary["terms"] as? [[String:Any]]{
            for dic in termsArray{
                let value = LocationDetailTerm(fromDictionary: dic)
                terms.append(value)
            }
        }
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
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if terms != nil{
            var dictionaryElements = [[String:Any]]()
            for termsElement in terms {
                dictionaryElements.append(termsElement.toDictionary())
            }
            dictionary["terms"] = dictionaryElements
        }
        return dictionary
    }
    
}
