//
//  ProfileDetailsChangePassword.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsChangePassword {
    
    var errPass : String!
    var newPass : String!
    var newPassCon : String!
    var oldPass : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        errPass = dictionary["err_pass"] as? String
        newPass = dictionary["new_pass"] as? String
        newPassCon = dictionary["new_pass_con"] as? String
        oldPass = dictionary["old_pass"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if errPass != nil{
            dictionary["err_pass"] = errPass
        }
        if newPass != nil{
            dictionary["new_pass"] = newPass
        }
        if newPassCon != nil{
            dictionary["new_pass_con"] = newPassCon
        }
        if oldPass != nil{
            dictionary["old_pass"] = oldPass
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
