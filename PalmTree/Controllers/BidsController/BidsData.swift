//
//  BidsData.swift
//  AdForest
//
//  Created by apple on 4/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct BidsData {
    
    var adTimer : AdTimer!
    var bids : [Bid]!
    var form : Form!
    var noTopBidders : String!
    var pageTitle : String!
    var topBidders : [TopBidder]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adTimerData = dictionary["ad_timer"] as? [String:Any]{
            adTimer = AdTimer(fromDictionary: adTimerData)
        }
        bids = [Bid]()
        if let bidsArray = dictionary["bids"] as? [[String:Any]]{
            for dic in bidsArray{
                let value = Bid(fromDictionary: dic)
                bids.append(value)
            }
        }
        if let formData = dictionary["form"] as? [String:Any]{
            form = Form(fromDictionary: formData)
        }
        noTopBidders = dictionary["no_top_bidders"] as? String
        pageTitle = dictionary["page_title"] as? String
        topBidders = [TopBidder]()
        if let topBiddersArray = dictionary["top_bidders"] as? [[String:Any]]{
            for dic in topBiddersArray{
                let value = TopBidder(fromDictionary: dic)
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
