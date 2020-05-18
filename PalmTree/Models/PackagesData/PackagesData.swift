//
//  PackagesData.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackagesData {
    
    var isPaypalKey : Bool!
    var paymentTypes : [PackagesDataPaymentType]!
    var paypal : PackagesDataPaypal!
    var products : [PackagesDataProduct]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isPaypalKey = dictionary["is_paypal_key"] as? Bool
        paymentTypes = [PackagesDataPaymentType]()
        if let paymentTypesArray = dictionary["payment_types"] as? [[String:Any]]{
            for dic in paymentTypesArray{
                let value = PackagesDataPaymentType(fromDictionary: dic)
                paymentTypes.append(value)
            }
        }
        if let paypalData = dictionary["paypal"] as? [String:Any]{
            paypal = PackagesDataPaypal(fromDictionary: paypalData)
        }
        products = [PackagesDataProduct]()
        if let productsArray = dictionary["products"] as? [[String:Any]]{
            for dic in productsArray{
                let value = PackagesDataProduct(fromDictionary: dic)
                products.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isPaypalKey != nil{
            dictionary["is_paypal_key"] = isPaypalKey
        }
        if paymentTypes != nil{
            var dictionaryElements = [[String:Any]]()
            for paymentTypesElement in paymentTypes {
                dictionaryElements.append(paymentTypesElement.toDictionary())
            }
            dictionary["payment_types"] = dictionaryElements
        }
        if paypal != nil{
            dictionary["paypal"] = paypal.toDictionary()
        }
        if products != nil{
            var dictionaryElements = [[String:Any]]()
            for productsElement in products {
                dictionaryElements.append(productsElement.toDictionary())
            }
            dictionary["products"] = dictionaryElements
        }
        return dictionary
    }
    
}
