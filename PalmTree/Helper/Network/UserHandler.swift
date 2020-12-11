//
//  UserHandler.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import Alamofire
class UserHandler
{
    static let sharedInstance = UserHandler()
    
    var objLoginDetails: LoginData?
    var objregisterDetails: RegisterData?
    var objForgotDetails: ForgotData?
    
    
    //MARK:- Login Get
    class func loginDetails(success: @escaping(LoginRoot) -> Void, failure: @escaping(NetworkError) -> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.logIn
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = LoginRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    //MARK:- Login Post
    class func loginUser(parameter: NSDictionary, success: @escaping(UserRegisterRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.logIn
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            let objLogin = UserRegisterRoot(fromDictionary: dictionary)
            success(objLogin)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Register Post
    class func registerUser(parameter: NSDictionary, success: @escaping(UserRegisterRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.register
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            let objRegister = UserRegisterRoot(fromDictionary: dictionary)
            success(objRegister)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Forgot Password Get
    class func forgotDetails(success: @escaping(ForgotRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.forgotPassword
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objForgot = ForgotRoot(fromDictionary: dictionary)
            success(objForgot)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Forgot Password Post
    class func forgotUser(parameter: NSDictionary, success: @escaping(UserForgot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.forgotPassword
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objForgotUser = UserForgot(fromDictionary: dictionary)
            success(objForgotUser)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Profile Post
    class func profileUpdate(parameters: NSDictionary, success: @escaping(ProfileUpdateRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.updateProfile
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameters as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objProfile = ProfileUpdateRoot(fromDictionary: dictionary)
            success(objProfile)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Change Password
    class func changePassword(parameter: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.changePassword
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPass = AdRemovedRoot(fromDictionary: dictionary)
            success(objPass)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Change Password
    class func getClientSecret(parameter: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.clientSecret
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPass = AdRemovedRoot(fromDictionary: dictionary)
            success(objPass)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
