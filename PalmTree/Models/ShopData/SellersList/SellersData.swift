//
//  SellersData.swift
//  PalmTree
//
//  Created by SprintSols on 9/6/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SellersData{
    
    var authors : [SellersAuthor]!
    var loadMore : String!
    var pageTitle : String!
    var pagination : SellersPagination!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        authors = [SellersAuthor]()
        if let authorsArray = dictionary["authors"] as? [[String:Any]]{
            for dic in authorsArray{
                let value = SellersAuthor(fromDictionary: dic)
                authors.append(value)
            }
        }
        loadMore = dictionary["load_more"] as? String
        pageTitle = dictionary["page_title"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = SellersPagination(fromDictionary: paginationData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if authors != nil{
            var dictionaryElements = [[String:Any]]()
            for authorsElement in authors {
                dictionaryElements.append(authorsElement.toDictionary())
            }
            dictionary["authors"] = dictionaryElements
        }
        if loadMore != nil{
            dictionary["load_more"] = loadMore
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        return dictionary
    }
    
}
