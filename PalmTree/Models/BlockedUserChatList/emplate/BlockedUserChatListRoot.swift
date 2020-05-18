//
//  BlockedUserChatListRoot.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct BlockedUserChatListRoot{
    
    var data : [BlockedUserChatListData]!
    var success : Bool!
    var message : String!
    
    init(fromDictionary dictionary: [String:Any]){
        data = [BlockedUserChatListData]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = BlockedUserChatListData(fromDictionary: dic)
                data.append(value)
            }
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
  
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        if success != nil{
            dictionary["success"] = success
        }
        if message != nil{
            dictionary["message"] = message
        }
        return dictionary
    }
    
}
