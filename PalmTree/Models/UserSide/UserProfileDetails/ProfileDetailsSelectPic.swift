//
//  ProfileDetailsSelectPic.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsSelectPic {
 
    var camera : String!
    var cancel : String!
    var library : String!
    var noCamera : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        camera = dictionary["camera"] as? String
        cancel = dictionary["cancel"] as? String
        library = dictionary["library"] as? String
        noCamera = dictionary["no_camera"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if camera != nil{
            dictionary["camera"] = camera
        }
        if cancel != nil{
            dictionary["cancel"] = cancel
        }
        if library != nil{
            dictionary["library"] = library
        }
        if noCamera != nil{
            dictionary["no_camera"] = noCamera
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
