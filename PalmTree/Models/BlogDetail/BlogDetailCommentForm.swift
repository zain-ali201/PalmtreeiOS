//
//  BlogDetailCommentForm.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogDetailCommentForm {
   
    var btnCancel : String!
    var btnSubmit : String!
    var textarea : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnSubmit = dictionary["btn_submit"] as? String
        textarea = dictionary["textarea"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btnCancel != nil{
            dictionary["btn_cancel"] = btnCancel
        }
        if btnSubmit != nil{
            dictionary["btn_submit"] = btnSubmit
        }
        if textarea != nil{
            dictionary["textarea"] = textarea
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
