//
//  AdPostExtra.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostExtra {
    
    var dialgCancel : String!
    var dialogSend : String!
    var imageText : String!
    var isShowBidtime : Bool!
    var priceTypeData : [AdPostPriceTypeData]!
    var sortImageMsg : String!
    var userInfo : String!
    var termsCondition : String!
    var termsUrl : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        dialgCancel = dictionary["dialg_cancel"] as? String
        dialogSend = dictionary["dialog_send"] as? String
        imageText = dictionary["image_text"] as? String
        isShowBidtime = dictionary["is_show_bidtime"] as? Bool
        priceTypeData = [AdPostPriceTypeData]()
        if let priceTypeDataArray = dictionary["price_type_data"] as? [[String:Any]]{
            for dic in priceTypeDataArray{
                let value = AdPostPriceTypeData(fromDictionary: dic)
                priceTypeData.append(value)
            }
        }
        sortImageMsg = dictionary["sort_image_msg"] as? String
        userInfo = dictionary["user_info"] as? String
        termsUrl = dictionary["adpost_terms_url"] as? String
        termsCondition = dictionary["adpost_terms_title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if dialgCancel != nil{
            dictionary["dialg_cancel"] = dialgCancel
        }
        if dialogSend != nil{
            dictionary["dialog_send"] = dialogSend
        }
        if imageText != nil{
            dictionary["image_text"] = imageText
        }
        if isShowBidtime != nil{
            dictionary["is_show_bidtime"] = isShowBidtime
        }
        if priceTypeData != nil{
            var dictionaryElements = [[String:Any]]()
            for priceTypeDataElement in priceTypeData {
                dictionaryElements.append(priceTypeDataElement.toDictionary())
            }
            dictionary["price_type_data"] = dictionaryElements
        }
        if sortImageMsg != nil{
            dictionary["sort_image_msg"] = sortImageMsg
        }
        if userInfo != nil{
            dictionary["user_info"] = userInfo
        }
        return dictionary
    }
    
}
