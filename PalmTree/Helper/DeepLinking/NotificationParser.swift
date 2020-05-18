//
//  NotificationParser.swift
//  PalmTree
//
//  Created by SprintSols on 11/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class NotificationParser {
    
    static let shared = NotificationParser()
    
    func handleNotification(_ userInfo: [AnyHashable: Any]) -> DeepLinkType? {
       
        if let adID = userInfo["adId"] as? String {
            return DeepLinkType.message(.ad_id(is: adID))
        }
        if let senderID = userInfo["senderId"] as? String {
            return DeepLinkType.message(.sender_id(id: senderID))
        }
        if let receiverID = userInfo["recieverId"] as? String {
            return DeepLinkType.message(.receiver_id(id: receiverID))
        }
        if let messageType = userInfo["type"] as? String {
            return DeepLinkType.message(.messageType(type: messageType))
        }
        return nil
    }
}
