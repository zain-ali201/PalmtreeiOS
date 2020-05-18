//
//  BidsForm.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BidsForm {
  
    var bidAmount : String!
    var bidBtn : String!
    var bidInfo : String!
    var bidTextarea : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bidAmount = dictionary["bid_amount"] as? String
        bidBtn = dictionary["bid_btn"] as? String
        bidInfo = dictionary["bid_info"] as? String
        bidTextarea = dictionary["bid_textarea"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bidAmount != nil{
            dictionary["bid_amount"] = bidAmount
        }
        if bidBtn != nil{
            dictionary["bid_btn"] = bidBtn
        }
        if bidInfo != nil{
            dictionary["bid_info"] = bidInfo
        }
        if bidTextarea != nil{
            dictionary["bid_textarea"] = bidTextarea
        }
        return dictionary
    }
    
}
