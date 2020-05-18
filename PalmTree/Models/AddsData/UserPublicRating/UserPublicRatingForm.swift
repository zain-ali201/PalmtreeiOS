//
//  UserPublicRatingForm.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserPublicRatingForm {
    
    var btn : String!
    var selectText : String!
    var selectValue : [Int]!
    var tagline : String!
    var textareaText : String!
    var textareaValue : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btn = dictionary["btn"] as? String
        selectText = dictionary["select_text"] as? String
        selectValue = dictionary["select_value"] as? [Int]
        tagline = dictionary["tagline"] as? String
        textareaText = dictionary["textarea_text"] as? String
        textareaValue = dictionary["textarea_value"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btn != nil{
            dictionary["btn"] = btn
        }
        if selectText != nil{
            dictionary["select_text"] = selectText
        }
        if selectValue != nil{
            dictionary["select_value"] = selectValue
        }
        if tagline != nil{
            dictionary["tagline"] = tagline
        }
        if textareaText != nil{
            dictionary["textarea_text"] = textareaText
        }
        if textareaValue != nil{
            dictionary["textarea_value"] = textareaValue
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
