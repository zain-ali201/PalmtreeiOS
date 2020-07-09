//
//  NetworkHandler.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//


import Foundation
import Alamofire

class NetworkHandler {

    class func postRequest(url: String, parameters: Parameters?, success: @escaping (Any) -> Void, failure: @escaping (NetworkError) -> Void) {
        
//         var langCode = UserDefaults.standard.string(forKey: "languageCode")
        var langCode = languageCode
        
        if langCode == nil {
            langCode = "en"
        }
        
        if Network.isAvailable {
            var headers: HTTPHeaders
            if UserDefaults.standard.bool(forKey: "isGuest")
            {
                headers = [
                    "Accept": "application/json",
                    //just add security
                    "Purchase-Code" : Constants.customCodes.purchaseCode,
                    "Custom-Security": Constants.customCodes.securityCode,
                    "Adforest-Request-From" : "ios",
                    "Adforest-Lang-Locale" : langCode
                    ] as! HTTPHeaders
            }
            
            if UserDefaults.standard.bool(forKey: "isSocial")
            {
                var email = ""
                var password = ""
                if let userEmail = UserDefaults.standard.string(forKey: "email") {
                    email = userEmail
                }
                if let userPassword = UserDefaults.standard.string(forKey: "password") {
                    password = userPassword
                }
                let emailPass = "\(email):\(password)"
                let encodedString = emailPass.data(using: String.Encoding.utf8)!
                let base64String = encodedString.base64EncodedString(options: [])
                headers = [
                    "Accept": "application/json",
                    "Authorization" : "Basic \(base64String)",
                    "AdForest-Login-Type": "social",
                    //just add security
                    "Purchase-Code" : Constants.customCodes.purchaseCode,
                    "Custom-Security": Constants.customCodes.securityCode,
                    "Adforest-Request-From" : "ios",
                     "Adforest-Lang-Locale" : langCode
                    ] as! HTTPHeaders
            }
            else
            {
                var email = ""
                var password = ""
                if let userEmail = UserDefaults.standard.string(forKey: "email") {
                    email = userEmail
                }
                if let userPassword = UserDefaults.standard.string(forKey: "password") {
                    password = userPassword
                }
                
                let emailPass = "\(email):\(password)"
                let encodedString = emailPass.data(using: String.Encoding.utf8)!
                let base64String = encodedString.base64EncodedString(options: [])
                headers = [
                    "Accept": "application/json",
                    "Authorization" : "Basic \(base64String)",
                    //just add security
                    "Purchase-Code" : Constants.customCodes.purchaseCode,
                    "Custom-Security": Constants.customCodes.securityCode,
                    "Adforest-Request-From" : "ios",
                     "Adforest-Lang-Locale" : langCode
                    ] as! HTTPHeaders
            }
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
            manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON
                { (response) -> Void in
                    print(response)
                if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                    UserDefaults.standard.setValue(userToken, forKey: "userAuthToken")
                    debugPrint("\(UserDefaults.standard.value(forKey: "userAuthToken")!)")
                }
                guard let statusCode = response.response?.statusCode else {
                    var networkError = NetworkError()
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    failure(networkError)
                    return
                }
                if statusCode == 422 {
                    var networkError = NetworkError()
                    let response = response.result.value!
                    let dictionary = response as! [String: AnyObject]
                    
                    guard let message = dictionary["error"] as! String? else {
                        networkError.status = statusCode
                        networkError.message = "Validation Error"
                        
                        failure(networkError)
                        
                        return
                    }
                    networkError.status = statusCode
                    networkError.message = message
                    
                    failure(networkError)
                    
                    
                }else{
                    switch (response.result) {
                    case .success:
                        let response = response.result.value!
                        success(response)
                        break
                    case .failure(let error):
                        var networkError = NetworkError()
                        
                        if error._code == NSURLErrorTimedOut {
                            networkError.status = Constants.NetworkError.timout
                            networkError.message = Constants.NetworkError.timoutError
                            
                            failure(networkError)
                        } else {
                            networkError.status = Constants.NetworkError.generic
                            networkError.message = Constants.NetworkError.genericError
                            
                            failure(networkError)
                        }
                        break
                    }
                }
            }
        } else {
            let networkError = NetworkError(status: Constants.NetworkError.internet, message: Constants.NetworkError.internetError)
            failure(networkError)
        }
    }
    
    class func postDataRequest(url: String, parameters: Parameters?, success: @escaping (Any) -> Void, failure: @escaping (NetworkError) -> Void) {
        
         var langCode = UserDefaults.standard.string(forKey: "langCode")
        
        if Network.isAvailable {
            
            var headers: HTTPHeaders
            
            if UserDefaults.standard.bool(forKey: "isSocial") {
                print("Social Login")
                var email = ""
                var password = ""
                if let userEmail = UserDefaults.standard.string(forKey: "email") {
                    email = userEmail
                }
                if let userPassword = UserDefaults.standard.string(forKey: "password") {
                    password = userPassword
                }
                let emailPass = "\(email):\(password)"
                
                let encodedString = emailPass.data(using: String.Encoding.utf8)!
                let base64String = encodedString.base64EncodedString(options: [])
                
                print(base64String)
                
                headers = [
                    "Accept": "application/json",
                    "Authorization" : "Basic \(base64String)",
                    "AdForest-Login-Type": "social",
                    //just add security
                    "Purchase-Code" : Constants.customCodes.purchaseCode,
                    "Custom-Security": Constants.customCodes.securityCode,
                     "Adforest-Request-From" : "ios",
                      "Adforest-Lang-Locale" : langCode
                    ] as! HTTPHeaders
            }
            
            else {
                var email = ""
                var password = ""
                if let userEmail = UserDefaults.standard.string(forKey: "email") {
                    email = userEmail
                }
                if let userPassword = UserDefaults.standard.string(forKey: "password") {
                    password = userPassword
                }
                print(email, password)
                let emailPass = "\(email):\(password)"
                
                let encodedString = emailPass.data(using: String.Encoding.utf8)!
                let base64String = encodedString.base64EncodedString(options: [])
                
                print(base64String)
                
                headers = [
                    "Accept": "application/json",
                    "Authorization" : "Basic \(base64String)",
                    //just add security
                    "Purchase-Code" : Constants.customCodes.purchaseCode,
                    "Custom-Security": Constants.customCodes.securityCode,
                     "Adforest-Request-From" : "ios",
                      "Adforest-Lang-Locale" : langCode
                    ] as! HTTPHeaders
            }
            print(headers)
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
            print(Parameters.self)
            manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseString { (response) in
                print(response)
            }
            
        } else {
            let networkError = NetworkError(status: Constants.NetworkError.internet, message: Constants.NetworkError.internetError)
            failure(networkError)
        }
    }
    

    
    class func getRequest(url: String, parameters: Parameters?, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        var langCode = UserDefaults.standard.string(forKey: "langCode")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
        
       var headers: HTTPHeaders

       
        if langCode == nil {
            langCode = "en"
        }
        
        if UserDefaults.standard.bool(forKey: "isGuest") {
            headers = [
                "Accept": "application/json",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios",
                "Adforest-Lang-Locale" : langCode
                ] as! HTTPHeaders
        }
        
        if UserDefaults.standard.bool(forKey: "isSocial") {
            print("Social Login")
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            headers = [
                "Accept": "application/json",
                "Authorization" : "Basic \(base64String)",
                "AdForest-Login-Type": "social",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios",
                "Adforest-Lang-Locale" : langCode
                ] as! HTTPHeaders
        }
        else
        {
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            headers = [
                "Accept": "application/json",
                
                "Authorization" : "Basic \(base64String)",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios",
                "Adforest-Lang-Locale" : langCode
                ] as! HTTPHeaders
        }
       
        print(headers)
        
        manager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) -> Void in
      
            debugPrint(response)
            print(response)
            switch response.result{
            //Case 1
            case .success:
                let response = response.result.value!
                success(response)
                break
            case .failure (let error):
                var networkError = NetworkError()
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
                break
            }
        }
    }
    
    class func getDataRequest(url: String, parameters: Parameters?, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
        
        var headers: HTTPHeaders
        
        if UserDefaults.standard.bool(forKey: "isGuest") {
            headers = [
                "Accept": "application/json",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        
        if UserDefaults.standard.bool(forKey: "isSocial") {
            print("Social Login")
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            
            let emailPass = "\(email):\(password)"
            
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            
            print(base64String)
            
            headers = [
                "Accept": "application/json",
                "Authorization" : "Basic \(base64String)",
                "AdForest-Login-Type": "social",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        else {
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            print(email, password)
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            
            print(base64String)
            
            
            headers = [
                "Accept": "application/json",
                
                "Authorization" : "Basic \(base64String)",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        
        print(headers)
        
        manager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
           print(response)
        })
    }
    
    
    // MARK: Upload Multipart File
    
    class func upload(url: String, fileUrl: URL, fileName: String, params: Parameters?, uploadProgress: @escaping (Int) -> Void, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        var headers: HTTPHeaders
        if UserDefaults.standard.bool(forKey: "isGuest") {
            headers = [
                "Accept": "application/json",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        if UserDefaults.standard.bool(forKey: "isSocial") {
            print("Social Login")
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            print(base64String)
            headers = [
                "Accept": "application/json",
                "Authorization" : "Basic \(base64String)",
                "AdForest-Login-Type": "social",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        else {
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            print(email, password)
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            headers = [
                "Accept": "application/json",
                
                "Authorization" : "Basic \(base64String)",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(fileUrl, withName: fileName)
            if let parameters = params {
                for (key, value) in parameters {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    let progress = Int(progress.fractionCompleted * 100)
                    uploadProgress(progress)
                })
                upload.responseJSON { response in
                    let returnValue = response.result.value!
                    if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                        print("User Token is \(userToken)")
                        UserDefaults.standard.set(userToken, forKey: "userAuthToken")
                        UserDefaults.standard.synchronize()
                    }
                    success(returnValue)
                }
            case .failure(let error):
                print(error.localizedDescription)
                var networkError = NetworkError()
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    failure(networkError)
                }
            }
        })
    }
    
    
    class func uploadImageArray(url: String, imagesArray: [UIImage], fileName: String, params: Parameters?, uploadProgress: @escaping (Int) -> Void, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        var headers: HTTPHeaders
        if UserDefaults.standard.bool(forKey: "isSocial") {
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            print(base64String)
            headers = [
                //"Accept": "application/json",
                "Authorization" : "Basic \(base64String)",
                "AdForest-Login-Type": "social",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        else {
            var email = ""
            var password = ""
            if let userEmail = UserDefaults.standard.string(forKey: "email") {
                email = userEmail
            }
            if let userPassword = UserDefaults.standard.string(forKey: "password") {
                password = userPassword
            }
            print(email, password)
            let emailPass = "\(email):\(password)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            headers = [
              //  "Accept": "application/json",
                
                "Authorization" : "Basic \(base64String)",
                //just add security
                "Purchase-Code" : Constants.customCodes.purchaseCode,
                "Custom-Security": Constants.customCodes.securityCode,
                "Adforest-Request-From" : "ios"
            ]
        }
        print(headers)
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            var i = 0
            for image in imagesArray {
          
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                
                print(imageData)
                multipartFormData.append(imageData,  withName: "nverness\(i).jpg", fileName: "Inverness\(i).jpg" , mimeType: "image/jpeg")
                    i = i + 1
                print(fileName)
                print("Reduced..!\(image.description)")
                }
            }
            if let parameters = params {
                for (key, value) in parameters {
                    print("Key \(key), Value\(value)")
                    let valuesStr = String(format: "%d", value as! Int)
                    multipartFormData.append(valuesStr.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    let progress = Int(progress.fractionCompleted * 100)
                    uploadProgress(progress)
                    
                    
                })
                upload.responseJSON { response in
                    let returnValue = response.result.value!
                    if let userToken = response.response?.allHeaderFields["Authorization"] as? String {
                        UserDefaults.standard.set(userToken, forKey: "userAuthToken")
                        UserDefaults.standard.synchronize()
                    }
                    success(returnValue)
                }
            case .failure(let error):
                print(error.localizedDescription)
                var networkError = NetworkError()
                
                if error._code == NSURLErrorTimedOut {
                    networkError.status = Constants.NetworkError.timout
                    networkError.message = Constants.NetworkError.timoutError
                    
                    failure(networkError)
                } else {
                    networkError.status = Constants.NetworkError.generic
                    networkError.message = Constants.NetworkError.genericError
                    
                    failure(networkError)
                }
            }
        })
    }
}

struct NetworkError {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}

struct NetworkSuccess {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}


