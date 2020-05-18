//
//  SentOffersTitle.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SentOffersTitle {
    
    var main : String!
    var receive : String!
    var sent : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        main = dictionary["main"] as? String
        receive = dictionary["receive"] as? String
        sent = dictionary["sent"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if main != nil{
            dictionary["main"] = main
        }
        if receive != nil{
            dictionary["receive"] = receive
        }
        if sent != nil{
            dictionary["sent"] = sent
        }
        return dictionary
    }
    
}
