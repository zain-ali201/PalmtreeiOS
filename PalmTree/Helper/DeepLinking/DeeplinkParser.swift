//
//  DeeplinkParser.swift
//  PalmTree
//
//  Created by SprintSols on 11/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

class DeepLinkParser {
    static let shared = DeepLinkParser()
    private init() {
    }
    
    @discardableResult
    func handleDeeplink(url: URL)-> Void {
        
    }
    
    
//    func parseDeepLink(_ url: URL) -> DeepLinkType? {
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//            let host = components.host else {
//                return nil
//        }
//
//        var pathComponents = components.path.components(separatedBy: "/")
//        pathComponents.removeFirst()
//
//
//    }

}

