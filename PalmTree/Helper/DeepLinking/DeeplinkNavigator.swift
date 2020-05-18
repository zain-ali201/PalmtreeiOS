//
//  DeeplinkNavigator.swift
//  PalmTree
//
//  Created by SprintSols on 11/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class DeepLinkNavigator {
    static let shared = DeepLinkNavigator()
    private init() {}
    
    func proceedTodeepLink(_ type: DeepLinkType) {
        switch type {
        case .broadcast:
            print("BroadCast")
        case .chat:
            print("Chat")
        default:
            break
        }
    }
}
