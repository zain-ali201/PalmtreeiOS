//
//  BidsData.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BidsData {
    
   
    var adTimer : BidsAdTime!
    var bids : [BidsBid]!
    var form : BidsForm!
    var noTopBidders : String!
    var pageTitle : String!
    var topBidders : [TopBidders]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adTimerData = dictionary["ad_timer"] as? [String:Any]{
            adTimer = BidsAdTime(fromDictionary: adTimerData)
        }
        bids = [BidsBid]()
        if let bidsArray = dictionary["bids"] as? [[String:Any]]{
            for dic in bidsArray{
                let value = BidsBid(fromDictionary: dic)
                bids.append(value)
            }
        }
        if let formData = dictionary["form"] as? [String:Any]{
            form = BidsForm(fromDictionary: formData)
        }
        noTopBidders = dictionary["no_top_bidders"] as? String
        pageTitle = dictionary["page_title"] as? String
        topBidders = [TopBidders]()
        if let topBiddersArray = dictionary["top_bidders"] as? [[String:Any]]{
            for dic in topBiddersArray{
                let value = TopBidders(fromDictionary: dic)
                topBidders.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adTimer != nil{
            dictionary["ad_timer"] = adTimer.toDictionary()
        }
        if bids != nil{
            var dictionaryElements = [[String:Any]]()
            for bidsElement in bids {
                dictionaryElements.append(bidsElement.toDictionary())
            }
            dictionary["bids"] = dictionaryElements
        }
        if form != nil{
            dictionary["form"] = form.toDictionary()
        }
        if noTopBidders != nil{
            dictionary["no_top_bidders"] = noTopBidders
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if topBidders != nil{
            var dictionaryElements = [[String:Any]]()
            for topBiddersElement in topBidders {
                dictionaryElements.append(topBiddersElement.toDictionary())
            }
            dictionary["top_bidders"] = dictionaryElements
        }
        return dictionary
    }
    
}
