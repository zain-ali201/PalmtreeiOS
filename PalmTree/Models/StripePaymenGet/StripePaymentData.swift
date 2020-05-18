//
//  StripePaymentData.swift
//  PalmTree
//
//  Created by SprintSols on 4/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct StripePaymentData {
    
    var error : StripePaymentError!
    var form : StripePaymentForm!
    var pageTitle : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let errorData = dictionary["error"] as? [String:Any]{
            error = StripePaymentError(fromDictionary: errorData)
        }
        if let formData = dictionary["form"] as? [String:Any]{
            form = StripePaymentForm(fromDictionary: formData)
        }
        pageTitle = dictionary["page_title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if error != nil{
            dictionary["error"] = error.toDictionary()
        }
        if form != nil{
            dictionary["form"] = form.toDictionary()
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        return dictionary
    }
    
}
