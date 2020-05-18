//
//  OfferAdsData.swift
//  PalmTree
//
//  Created by SprintSols on 4/14/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct OfferAdsData{
    
    var pagination : OfferAdsPagination!
    var receivedOffers : OfferAdsReceivedOffer!
    var title : OfferAdsTitle!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = OfferAdsPagination(fromDictionary: paginationData)
        }
        if let receivedOffersData = dictionary["received_offers"] as? [String:Any]{
            receivedOffers = OfferAdsReceivedOffer(fromDictionary: receivedOffersData)
        }
        if let titleData = dictionary["title"] as? [String:Any]{
            title = OfferAdsTitle(fromDictionary: titleData)
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
        if receivedOffers != nil{
            dictionary["received_offers"] = receivedOffers.toDictionary()
        }
        if title != nil{
            dictionary["title"] = title.toDictionary()
        }
        return dictionary
    }
    
}
