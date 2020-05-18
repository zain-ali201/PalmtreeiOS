//
//  SentOffersData.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SentOffersData{
    
    var pagination : SentOffersPagination!
    var sentOffers : SentOffers!
    var title : SentOffersTitle!
    var isRedirec : Bool = false
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = SentOffersPagination(fromDictionary: paginationData)
        }
        if let sentOffersData = dictionary["sent_offers"] as? [String:Any]{
            sentOffers = SentOffers(fromDictionary: sentOffersData)
        }
        if let titleData = dictionary["title"] as? [String:Any]{
            title = SentOffersTitle(fromDictionary: titleData)
        }
        
        if dictionary["is_redirect"] as? Bool != nil{
            isRedirec = (dictionary["is_redirect"] as? Bool)!
        }
        
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if sentOffers != nil{
            dictionary["sent_offers"] = sentOffers.toDictionary()
        }
        if title != nil{
            dictionary["title"] = title.toDictionary()
        }
      
        return dictionary
    }
    
}
