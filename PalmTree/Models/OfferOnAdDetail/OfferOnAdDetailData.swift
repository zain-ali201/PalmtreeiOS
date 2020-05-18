//
//  OfferOnAdDetailData.swift
//  PalmTree
//
//  Created by SprintSols on 4/15/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct OfferOnAdDetailData{
    
    var pagination : OfferOnAdDetailPagination!
    var receivedOffers : OfferOnAdDetailReceivedOffer!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = OfferOnAdDetailPagination(fromDictionary: paginationData)
        }
        if let receivedOffersData = dictionary["received_offers"] as? [String:Any]{
            receivedOffers = OfferOnAdDetailReceivedOffer(fromDictionary: receivedOffersData)
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
        return dictionary
    }
    
}
