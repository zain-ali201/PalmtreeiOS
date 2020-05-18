//
//  ShopHandler.swift
//  PalmTree
//
//  Created by SprintSols on 7/20/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import Alamofire

class ShopHandler {
    
    static let sharedInstance = ShopHandler()
    
    //MARK:- Seller List
    class func sellerList(success: @escaping(SellersRoot)->Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.sellerList
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSeller = SellersRoot(fromDictionary: dictionary)
            success(objSeller)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Seller List Load More
    class func sellerListLoadMore(param: NSDictionary ,success: @escaping(SellersRoot)->Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.sellerList
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSeller = SellersRoot(fromDictionary: dictionary)
            success(objSeller)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
