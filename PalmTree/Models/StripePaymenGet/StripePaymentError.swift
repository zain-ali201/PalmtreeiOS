//
//  StripePaymentError.swift
//  PalmTree
//
//  Created by SprintSols on 4/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct StripePaymentError {
    
    var cardDetails : String!
    var cardNumber : String!
    var expirationDate : String!
    var invalidCvc : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cardDetails = dictionary["card_details"] as? String
        cardNumber = dictionary["card_number"] as? String
        expirationDate = dictionary["expiration_date"] as? String
        invalidCvc = dictionary["invalid_cvc"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cardDetails != nil{
            dictionary["card_details"] = cardDetails
        }
        if cardNumber != nil{
            dictionary["card_number"] = cardNumber
        }
        if expirationDate != nil{
            dictionary["expiration_date"] = expirationDate
        }
        if invalidCvc != nil{
            dictionary["invalid_cvc"] = invalidCvc
        }
        return dictionary
    }
    
}
