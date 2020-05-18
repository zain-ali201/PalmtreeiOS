//
//  OfferAdsItem.swift
//  PalmTree
//
//  Created by SprintSols on 4/14/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct OfferAdsItem{
    
    var adId : Int!
    var messageAdImg : [OfferAdsMessageAdImage]!
    var messageAdTitle : String!
    var messageReadStatus : Bool!
    var is_block : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adId = dictionary["ad_id"] as? Int
        messageAdImg = [OfferAdsMessageAdImage]()
        if let messageAdImgArray = dictionary["message_ad_img"] as? [[String:Any]]{
            for dic in messageAdImgArray{
                let value = OfferAdsMessageAdImage(fromDictionary: dic)
                messageAdImg.append(value)
            }
        }
        messageAdTitle = dictionary["message_ad_title"] as? String
        messageReadStatus = dictionary["message_read_status"] as? Bool
        is_block = dictionary["is_block"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        if messageAdImg != nil{
            var dictionaryElements = [[String:Any]]()
            for messageAdImgElement in messageAdImg {
                dictionaryElements.append(messageAdImgElement.toDictionary())
            }
            dictionary["message_ad_img"] = dictionaryElements
        }
        if messageAdTitle != nil{
            dictionary["message_ad_title"] = messageAdTitle
        }
        if messageReadStatus != nil{
            dictionary["message_read_status"] = messageReadStatus
        }
        return dictionary
    }
    
}
