//
//  AddsHandler.swift
//  PalmTree
//
//  Created by SprintSols on 3/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import Alamofire
import  JGProgressHUD
import UIKit

class AddsHandler {
    
    static let sharedInstance = AddsHandler()
    
    var objMyAds: MyAdsData?
    var objInactiveAds: InactiveAdsData?
    var objAds: MyAdsAd?
    var objDropDownStatus : MyAdsText?
    var objReportPopUp : AddDetailReportPopup?
    var objAddDetails: AddDetailData?
    var objAdBids : BidsDataRoot?
    var objLatestAds: HomeFeaturedAdd?
    var objCategory : CategoryRoot?
    var objAddDetailImage: AddDetailImage?
    var objAdPost : AdPostRoot?
    var adBidTime: AddDetailAdTimer?
    var ratingsAdds: AddDetailAdRating?
    var userRatingForm: UserPublicRatingForm?
    
    var isShowFeatureOnCategory = false
    var isFromHomeFeature = false
    var isFromTextSearch = false
    
    var objCategoryArray = [CategoryAd]()
    var objCategotyAdArray = [CategoryAd]()
  
    var searchFieldType = ""
    var objSearchData : [SearchData]?
  
    var objSearchArray = [SearchData]()
    
    var TopBiddersArray = [TopBidders]()
    var biddersArray = [BidsBid]()
    
    var adPostImagesArray = [AdPostImageArray]()
    var objAdPostData = [AdPostField]()
    
    var descTitle = ""
    var phone = ""
    var address = ""
    var htmlText = ""
    var bidTitle = ""
    var statTitle = ""
    var statsNoDataTitle = ""
    var adIdBidStat = 0
    
    var isCategoeyTempelateOn = false
    var adPostAdId = 0
    
    var topLocationArray = [HomeAppTopLocation]()
    
    private lazy var uploadingProgressBar: JGProgressHUD = {
        let progressBar = JGProgressHUD(style: .dark)
        progressBar.indicatorView = JGProgressHUDRingIndicatorView()
        progressBar.textLabel.text = "Uploading"
        return progressBar
    }()
    
    //MARK:- Get Home Data
    class func homeData(parameter: NSDictionary, success: @escaping(HomeRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.homeData
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as! Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objHome = HomeRoot(fromDictionary: dictionary)
            success(objHome)
            
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get All Categories
    class func getAllCategories(parameter: NSDictionary, success: @escaping(SubCategoryRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getAllCategories
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as! Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objHome = SubCategoryRoot(fromDictionary: dictionary)
            success(objHome)
            
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get SubCategories
    class func getSubCategories(parameter: NSDictionary, success: @escaping(SubCategoryRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPostSubCategory+"/"+(parameter.value(forKey: "id") as! String)
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objHome = SubCategoryRoot(fromDictionary: dictionary)
            success(objHome)
            
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    //MARK:- Category Data
    class func searchAds(param: NSDictionary, success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.searchAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (SuccessResponse) in
            let dictionary = SuccessResponse as! [String: Any]
            let objCategory = MyAdsRoot(fromDictionary: dictionary)
            success(objCategory)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
   
    //MARK:- Get My Adds Data
    
    class func myAds(parameter: NSDictionary, success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getMyAds+"/"+(parameter.value(forKey: "user_id") as! String)
        print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get More My Ads Data
    class func moreMyAdsData(param: NSDictionary ,success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getMyAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get Featured Ads Data
    
    class func featuredAds(success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getFeaturedAds
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- More Featured Ads Data
    class func moreFeaturedAdsData(param: NSDictionary ,success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getFeaturedAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
     //MARK:- Get Favourite Ads Data
    class func favouriteAds(parameter: NSDictionary, success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getFavouriteAds+"/"+(parameter.value(forKey: "id") as! String)
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Remove Favourite Add
    class func removeFavAdd(parameter: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.removeFavouriteAd
        print(url)
      
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = AdRemovedRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Delete My Ad
    class func deleteAdd(param: NSDictionary, success: @escaping(AddDeleteRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.deleteAdd
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = AddDeleteRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func deleteImage(param: NSDictionary, success: @escaping(AddDeleteRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.deleteImage
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = AddDeleteRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Feature My Ad
    class func featureAd(param: NSDictionary, success: @escaping(ResponseRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.featureAdd
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = ResponseRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    //MARK:- Add Detail
    class func addDetails(parameter: NSDictionary ,success: @escaping(AddDetailRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.addDetail
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAdd = AddDetailRoot(fromDictionary: dictionary)
            success(objAdd)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Make Add Feature
    
    class func makeAddFeature(parameter: NSDictionary, success : @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.makeAddFeature
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objFeature = AdRemovedRoot(fromDictionary: dictionary)
            success(objFeature)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Make Add Favourite
    class func makeAddFavourite(parameter: NSDictionary, success : @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.makeAddFavourite
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objFeature = AdRemovedRoot(fromDictionary: dictionary)
            success(objFeature)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Report Add
    class func reportAdd(parameter: NSDictionary, success : @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.reportAdd
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objFeature = AdRemovedRoot(fromDictionary: dictionary)
            success(objFeature)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Ad Post
    class func adPost(parameter: NSDictionary, success: @escaping(AdPostRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPost
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPost = AdPostRoot(fromDictionary: dictionary)
            success(objPost)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Ad Post Sub Category
    class func adPostSubcategory(parameter: NSDictionary, success: @escaping(SubCategoryRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPostSubCategory
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objCategory = SubCategoryRoot(fromDictionary: dictionary)
            success(objCategory)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- AdPost Upload Images
    class func adPostUploadImages(parameter: NSDictionary , imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.adPostUploadImages
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
           
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objImg = AdPostImagesRoot(fromDictionary: dictionary)
            success(objImg)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
     //MARK:- AdPost Delete Images
    class func adPostDeleteImages (param: NSDictionary, success: @escaping(AdPostImageDeleteRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPostDeleteImage
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objImage = AdPostImageDeleteRoot(fromDictionary: dictionary)
            success(objImage)
        }) { (error) in
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Ad Post Live
    class func adPostLive(parameter: NSDictionary, success: @escaping(AdPostLiveRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPostLive
        print(url)
        print(parameter)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAd = AdPostLiveRoot(fromDictionary: dictionary)
            success(objAd)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Advance Search Get data
    class func advanceSearch(success: @escaping(SearchRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.advanceSearch
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSearch = SearchRoot(fromDictionary: dictionary)
            success(objSearch)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Advance Search Post Data
    class func searchData(parameter: NSDictionary, success: @escaping(CategoryRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.advanceSearch
        print(url)
        print(parameter)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSearch = CategoryRoot(fromDictionary: dictionary)
            success(objSearch)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Sub Category Data
    class func subCategory(url: String ,parameter: NSDictionary, success: @escaping(SubCategoryRoot)-> Void,  failure: @escaping(NetworkError)-> Void) {
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objResp = SubCategoryRoot(fromDictionary: dictionary)
            success(objResp)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Send Firebase Token To Server
    class func sendFirebaseToken(parameter: NSDictionary, success: @escaping(FirebaseTokenRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.homeData
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objFirebase = FirebaseTokenRoot(fromDictionary: dictionary)
            success(objFirebase)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Send Firebase Chat Token To Server
    class func sendFirebaseChatToken(parameter: NSDictionary, success: @escaping(FirebaseTokenRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.updateChatToken
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objFirebase = FirebaseTokenRoot(fromDictionary: dictionary)
            success(objFirebase)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
