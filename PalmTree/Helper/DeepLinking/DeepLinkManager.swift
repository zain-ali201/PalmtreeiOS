//
//  DeepLinkManager.swift
//  PalmTree
//
//  Created by SprintSols on 11/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
/*
guard let adID = remoteMessage.appData[AnyHashable("adId")]as? String else  {
    return
}
guard let textFrom = remoteMessage.appData[AnyHashable("from")] as? String else {
    return
}
guard let textTitle = remoteMessage.appData[AnyHashable("title")] as? String else  {
    return
}
guard let userMessage = remoteMessage.appData[AnyHashable("message")] as? String else {
    return
}
guard let senderID = remoteMessage.appData[AnyHashable("senderId")] as? String else {
    return
}
guard let receiverID = remoteMessage.appData[AnyHashable("recieverId")] as? String else {
    return
}
guard let type = remoteMessage.appData[AnyHashable("type")] as? String else {
    return
}
guard let topic = remoteMessage.appData[AnyHashable("topic")] as? String else {
    return
 
}
 broadcast
 chat

 */
enum DeepLinkType {
    case chat
    enum messages {
        case ad_id(is: String)
        case sender_id(id: String)
        case receiver_id(id: String)
        case messageType(type: String)
    }
    case message(messages)
    case broadcast
}

enum ShortcutKey: String {
    case chat = "com.AdForest.chat"
    case broadcast = "com.AdForest.broadcast"
}


let deepLinker = DeepLinkManager()

class DeepLinkManager {
    fileprivate init() {}
    
    private var deepLinkType : DeepLinkType?
    
    func checkDeepLink() {
        guard let linkType = deepLinkType else {
            return
        }
        DeepLinkNavigator.shared.proceedTodeepLink(linkType)
        //Reset Deep Link After Launching
        self.deepLinkType = nil
    }
}

