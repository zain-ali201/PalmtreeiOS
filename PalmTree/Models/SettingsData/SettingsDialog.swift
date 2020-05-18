//
//  SettingsDialog.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsDialog {
    
    var confirmation : SettingsConfirmation!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let confirmationData = dictionary["confirmation"] as? [String:Any]{
            confirmation = SettingsConfirmation(fromDictionary: confirmationData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if confirmation != nil{
            dictionary["confirmation"] = confirmation.toDictionary()
        }
        return dictionary
    }
    
}
