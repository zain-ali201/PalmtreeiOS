//
//  RegisterData.swift
//  PalmTree
//
//  Created by SprintSols on 3/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct RegisterData {
    
    var bgColor : String!
    var emailPlaceholder : String!
    var facebookBtn : String!
    var appleBtn : String!
    var formBtn : String!
    var googleBtn : String!
    var heading : String!
    var loginText : String!
    var logo : String!
    var namePlaceholder : String!
    var passwordPlaceholder : String!
    var phonePlaceholder : String!
    var separator : String!
    var termsText : String!
    var termPageId : String!
    var isVerifyOn : Bool!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bgColor = dictionary["bg_color"] as? String
        emailPlaceholder = dictionary["email_placeholder"] as? String
        facebookBtn = dictionary["facebook_btn"] as? String
        appleBtn = dictionary["apple_btn"] as? String
        formBtn = dictionary["form_btn"] as? String
        googleBtn = dictionary["google_btn"] as? String
        heading = dictionary["heading"] as? String
        loginText = dictionary["login_text"] as? String
        logo = dictionary["logo"] as? String
        namePlaceholder = dictionary["name_placeholder"] as? String
        passwordPlaceholder = dictionary["password_placeholder"] as? String
        phonePlaceholder = dictionary["phone_placeholder"] as? String
        separator = dictionary["separator"] as? String
        termsText = dictionary["terms_text"] as? String
        termPageId = dictionary["term_page_id"] as? String
        
        isVerifyOn = dictionary["is_verify_on"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bgColor != nil{
            dictionary["bg_color"] = bgColor
        }
        if emailPlaceholder != nil{
            dictionary["email_placeholder"] = emailPlaceholder
        }
        if facebookBtn != nil{
            dictionary["facebook_btn"] = facebookBtn
        }
        if appleBtn != nil{
            dictionary["apple_btn"] = appleBtn
        }
        if formBtn != nil{
            dictionary["form_btn"] = formBtn
        }
        if googleBtn != nil{
            dictionary["google_btn"] = googleBtn
        }
        if heading != nil{
            dictionary["heading"] = heading
        }
        if loginText != nil{
            dictionary["login_text"] = loginText
        }
        if logo != nil{
            dictionary["logo"] = logo
        }
        if namePlaceholder != nil{
            dictionary["name_placeholder"] = namePlaceholder
        }
        if passwordPlaceholder != nil{
            dictionary["password_placeholder"] = passwordPlaceholder
        }
        if phonePlaceholder != nil{
            dictionary["phone_placeholder"] = phonePlaceholder
        }
        if separator != nil{
            dictionary["separator"] = separator
        }
        if termsText != nil{
            dictionary["terms_text"] = termsText
        }
        if termPageId != nil{
            dictionary["term_page_id"] = termPageId
        }
        if isVerifyOn != nil{
            dictionary["is_verify_on"] = isVerifyOn
        }
        return dictionary
    }
    
}
