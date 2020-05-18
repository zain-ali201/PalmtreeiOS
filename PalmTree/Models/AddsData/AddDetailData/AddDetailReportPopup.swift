//
//  AddDetailReportPopup.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailReportPopup {
    
    var btnCancel : String!
    var btnSend : String!
    var inputTextarea : String!
    var select : AddDetailSelect!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnSend = dictionary["btn_send"] as? String
        inputTextarea = dictionary["input_textarea"] as? String
        if let selectData = dictionary["select"] as? [String:Any]{
            select = AddDetailSelect(fromDictionary: selectData)
        }
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
        if btnSend != nil{
            dictionary["btn_send"] = btnSend
        }
        if inputTextarea != nil{
            dictionary["input_textarea"] = inputTextarea
        }
        if select != nil{
            dictionary["select"] = select.toDictionary()
        }
        return dictionary
    }
    
}
