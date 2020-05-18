//
//  StripePaymentForm.swift
//  PalmTree
//
//  Created by SprintSols on 4/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct StripePaymentForm {
    
    var btnText : String!
    var cardInputText : String!
    var cvcInputText : String!
    var selectMonth : String!
    var selectOptionYear : [Int]!
    var selectTitle : String!
    var selectYear : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnText = dictionary["btn_text"] as? String
        cardInputText = dictionary["card_input_text"] as? String
        cvcInputText = dictionary["cvc_input_text"] as? String
        selectMonth = dictionary["select_month"] as? String
        selectOptionYear = dictionary["select_option_year"] as? [Int]
        selectTitle = dictionary["select_title"] as? String
        selectYear = dictionary["select_year"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btnText != nil{
            dictionary["btn_text"] = btnText
        }
        if cardInputText != nil{
            dictionary["card_input_text"] = cardInputText
        }
        if cvcInputText != nil{
            dictionary["cvc_input_text"] = cvcInputText
        }
        if selectMonth != nil{
            dictionary["select_month"] = selectMonth
        }
        if selectOptionYear != nil{
            dictionary["select_option_year"] = selectOptionYear
        }
        if selectTitle != nil{
            dictionary["select_title"] = selectTitle
        }
        if selectYear != nil{
            dictionary["select_year"] = selectYear
        }
        return dictionary
    }
    
}
