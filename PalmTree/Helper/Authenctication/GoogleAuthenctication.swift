//
//  GoogleAuthenctication.swift
//  GoRich
//
//  Created by SprintSols PC on 23/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn


class GoogleAuthenctication {

    class func getInstance() -> GIDSignIn {
        return GIDSignIn.sharedInstance()
    }
    
    class var isLooggedIn: Bool {
        return getInstance().hasAuthInKeychain()
    }
    
    class func signIn() {
        getInstance().signIn()
    }
    
    class func signInSilenty() {
        getInstance().signInSilently()
    }
    
    class func signOut() {
        if isLooggedIn {
            getInstance().signOut()
        }
    }
    
    class var user: GIDGoogleUser? {
        return getInstance().currentUser
    }
    
    class func isValidatedWithUrl(url: URL) -> Bool {
        return url.scheme!.hasPrefix(Bundle.main.bundleIdentifier!) || url.scheme!.hasPrefix("com.googleusercontent.apps.")
    }
}
