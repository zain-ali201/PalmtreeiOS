//
//  BlockedUserChatListData.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct BlockedUserChatListData{
  
    var userId : String!
    var userImg : String!
    var userName : String!
    var recvId : String!
    var senderId : Int!
    var block_text : String!
    var block_time : String!
    
    
    init(fromDictionary dictionary: [String:Any]){
        userId = dictionary["user_id"] as? String
        userImg = dictionary["user_img"] as? String
        userName = dictionary["user_name"] as? String
        recvId = dictionary["receiver_id"] as? String
        senderId = dictionary["sender_id"] as? Int
        block_text = dictionary["block_text"] as? String
        block_time = dictionary["block_time"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userImg != nil{
            dictionary["user_img"] = userImg
        }
        if userName != nil{
            dictionary["user_name"] = userName
        }
        return dictionary
    }
    
}
