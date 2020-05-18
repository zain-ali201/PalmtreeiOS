//
//  BlockUserChatRoot.swift
//  PalmTree
//
//  Created by SprintSols on 9/3/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
struct BlockUserChatRoot{
    
    
    var message : String!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
       
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
   
    
}
