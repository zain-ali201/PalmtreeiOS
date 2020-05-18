//
//  PackagesDataExtra.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackagesDataExtra {
    
    var android : PackageDataAndroid!
    var billingError : String!
    var ios : PackagesDataIOS!
    var pageTitle : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let androidData = dictionary["android"] as? [String:Any]{
            android = PackageDataAndroid(fromDictionary: androidData)
        }
        billingError = dictionary["billing_error"] as? String
        if let iosData = dictionary["ios"] as? [String:Any]{
            ios = PackagesDataIOS(fromDictionary: iosData)
        }
        pageTitle = dictionary["page_title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if android != nil{
            dictionary["android"] = android.toDictionary()
        }
        if billingError != nil{
            dictionary["billing_error"] = billingError
        }
        if ios != nil{
            dictionary["ios"] = ios.toDictionary()
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        return dictionary
    }
    
}
