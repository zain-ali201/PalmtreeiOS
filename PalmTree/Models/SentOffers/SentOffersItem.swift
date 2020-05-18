//
//  SentOffersItem.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SentOffersItem {
    
    var adId : String!
    var messageAdImg : [SentOffersMessageAdImage]!
    var messageAdTitle : String!
    var messageAuthorName : String!
    var messageDate : String!
    var messageReadStatus : Bool!
    var messageReceiverId : String!
    var messageSenderId : String!
    var is_block : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adId = dictionary["ad_id"] as? String
        messageAdImg = [SentOffersMessageAdImage]()
        if let messageAdImgArray = dictionary["message_ad_img"] as? [[String:Any]]{
            for dic in messageAdImgArray{
                let value = SentOffersMessageAdImage(fromDictionary: dic)
                messageAdImg.append(value)
            }
        }
        messageAdTitle = dictionary["message_ad_title"] as? String
        messageAuthorName = dictionary["message_author_name"] as? String
        messageDate = dictionary["message_date"] as? String
        messageReadStatus = dictionary["message_read_status"] as? Bool
        messageReceiverId = dictionary["message_receiver_id"] as? String
        messageSenderId = dictionary["message_sender_id"] as? String
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
        if messageAuthorName != nil{
            dictionary["message_author_name"] = messageAuthorName
        }
        if messageDate != nil{
            dictionary["message_date"] = messageDate
        }
        if messageReadStatus != nil{
            dictionary["message_read_status"] = messageReadStatus
        }
        if messageReceiverId != nil{
            dictionary["message_receiver_id"] = messageReceiverId
        }
        if messageSenderId != nil{
            dictionary["message_sender_id"] = messageSenderId
        }
        if is_block != nil{
            dictionary["is_block"] = is_block
        }
        return dictionary
    }
    
}
