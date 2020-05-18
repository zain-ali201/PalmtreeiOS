//
//  SettingsAlertDialog.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsAlertDialog {
    
  
    var message : String!
    var title : String!
    var select : String!
    var camera : String!
    var CameraNotAvailable : String!
    var gallery : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        title = dictionary["title"] as? String
        select = dictionary["alert_select"] as? String
        camera = dictionary["alert_camera"] as? String
        CameraNotAvailable = dictionary["alert_camera_not"] as? String
        gallery = dictionary["alert_gallery"] as? String

    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if message != nil{
            dictionary["message"] = message
        }
        if title != nil{
            dictionary["title"] = title
        }
        if select != nil{
            dictionary["alert_select"] = select
        }
        if camera != nil{
            dictionary["alert_camera"] = camera
        }
        if gallery != nil{
            dictionary["alert_gallery"] = gallery
        }
        
        return dictionary
    }
    
}
