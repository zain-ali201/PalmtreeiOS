//
//  FacebookAuthentication.swift
//  GoRich
//
//  Created by SprintSols PC on 23/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookAuthentication {

    class var token: String? {
        
        if AccessToken.current != nil {
            return AccessToken.current?.tokenString
        } else {
            return nil
        }
    }

    class var isLoggedIn: Bool {
    
        return AccessToken.current != nil
    
    }
    
    class func signOut() {
    
        if isLoggedIn {
            
            let loginManager = LoginManager()
            loginManager.logOut()
        }
    }
   
    class func isValidatedWithUrl(url: URL) -> Bool {
        return url.scheme!.hasPrefix("fb\(Settings.appID)") && url.host == "authorize"
    }
}
