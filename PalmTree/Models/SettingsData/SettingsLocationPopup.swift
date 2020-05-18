//
//  SettingsLocationPopup.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsLocationPopup {
    
 
    var btnClear : String!
    var btnSubmit : String!
    var sliderNumber : Int!
    var sliderStep : Int!
    var text : String!
    
    var currentLocation: String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnClear = dictionary["btn_clear"] as? String
        btnSubmit = dictionary["btn_submit"] as? String
        sliderNumber = dictionary["slider_number"] as? Int
        sliderStep = dictionary["slider_step"] as? Int
        text = dictionary["text"] as? String
        
        currentLocation = dictionary["location"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btnClear != nil{
            dictionary["btn_clear"] = btnClear
        }
        if btnSubmit != nil{
            dictionary["btn_submit"] = btnSubmit
        }
        if sliderNumber != nil{
            dictionary["slider_number"] = sliderNumber
        }
        if sliderStep != nil{
            dictionary["slider_step"] = sliderStep
        }
        if text != nil{
            dictionary["text"] = text
        }
        if currentLocation != nil {
            dictionary["location"] = currentLocation
        }
        return dictionary
    }
    
}
