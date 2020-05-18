//
//  PaymentSuccessData.swift
//  PalmTree
//
//  Created by SprintSols on 4/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PaymentSuccessData {
    
    var data : String!
    var orderThankyouBtn : String!
    var orderThankyouTitle : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        data = dictionary["data"] as? String
        orderThankyouBtn = dictionary["order_thankyou_btn"] as? String
        orderThankyouTitle = dictionary["order_thankyou_title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data
        }
        if orderThankyouBtn != nil{
            dictionary["order_thankyou_btn"] = orderThankyouBtn
        }
        if orderThankyouTitle != nil{
            dictionary["order_thankyou_title"] = orderThankyouTitle
        }
        return dictionary
    }
    
}
