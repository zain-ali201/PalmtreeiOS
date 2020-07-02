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
    var objHomeData: HomeData?
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
    
    var objSearchCategory: SubCategoryData?
  
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
    class func homeData(success: @escaping(HomeRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.homeData
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objHome = HomeRoot(fromDictionary: dictionary)
            success(objHome)
            
       
            
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

    //MARK:- Category Data
    class func categoryData(param: NSDictionary, success: @escaping(CategoryRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.category
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (SuccessResponse) in
            let dictionary = SuccessResponse as! [String: Any]
            let objCategory = CategoryRoot(fromDictionary: dictionary)
            success(objCategory)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
   
    //MARK:- Get My Adds Data
    
    class func myAds(success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getMyAds
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
    
    //MARK:- Get Inactive Ads Data
    
    class func inactiveAds(success: @escaping(InactiveAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getInactiveAds
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objInactiveAds = InactiveAdsRoot(fromDictionary: dictionary)
            success(objInactiveAds)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func getmyExpiredAds(success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getExpAds
        print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func getmyMoreExpiredAds(param: NSDictionary ,success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
           let url = Constants.URL.baseUrl+Constants.URL.getExpAds
           print(url)
           NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
               let dictionary = successResponse as! [String: Any]
               let objAds = MyAdsRoot(fromDictionary: dictionary)
               success(objAds)
           }) { (error) in
                failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
           }
       }
    
    
    //MARK:- Get MostViewedAds data
    class func getmyMostViewedAds(success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
           let url = Constants.URL.baseUrl+Constants.URL.getMostViewedAd
           print(url)
           
           NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
               let dictionary = successResponse as! [String: Any]
               let objAds = MyAdsRoot(fromDictionary: dictionary)
               success(objAds)
           }) { (error) in
               failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
           }
       }
       
       class func getmyMoreMostViewedAds(param: NSDictionary ,success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
              let url = Constants.URL.baseUrl+Constants.URL.getMostViewedAd
              print(url)
              NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
                  let dictionary = successResponse as! [String: Any]
                  let objAds = MyAdsRoot(fromDictionary: dictionary)
                  success(objAds)
              }) { (error) in
                   failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
              }
          }
    //MARK:- More Inactive Ads data
    class func moreInactiveAdsdata(param: NSDictionary ,success: @escaping(InactiveAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getInactiveAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objInactiveAds = InactiveAdsRoot(fromDictionary: dictionary)
            success(objInactiveAds)
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
    class func favouriteAds(success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getFavouriteAds
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAds = MyAdsRoot(fromDictionary: dictionary)
            success(objAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Load More Favourite Data
    
    class func moreFavouriteData(param: NSDictionary ,success: @escaping(MyAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
       let url = Constants.URL.baseUrl+Constants.URL.getFavouriteAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
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
    
    //MARK:- Change Add Status
    class func changeAddStatus(parameter: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.addStatusChange
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAdd = AdRemovedRoot(fromDictionary: dictionary)
            success(objAdd)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Rejected Ads
    class func rejectedAds(success: @escaping(RejectedAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.rejectedAds
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAdd = RejectedAdsRoot(fromDictionary: dictionary)
            success(objAdd)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- More Rejected Ads Data
    class func moreRejectedAds(params: [String:Any], success: @escaping(RejectedAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.rejectedAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAdd = RejectedAdsRoot(fromDictionary: dictionary)
            success(objAdd)
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
    
    //MARK:- Rating To Add on Add Detail
    class func ratingToAdd(parameter: NSDictionary, success : @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adNewReply
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objRating = AdRemovedRoot(fromDictionary: dictionary)
            success(objRating)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    //MARK:- Bids Data
    class func bidsData(param: NSDictionary, success: @escaping(BidsDataRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getBidsData
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objBid = BidsDataRoot(fromDictionary: dictionary)
            success(objBid)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Post Bid
    class func postBid(param: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.postBid
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = AdRemovedRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Reply Comment
    class func replyComment(parameters: NSDictionary, success: @escaping(ReplyCommentRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adNewReply
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameters as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objReply = ReplyCommentRoot(fromDictionary: dictionary)
            success(objReply)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Add Detail Popup Message Reply
    class func popMsgReply(param: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adDetailPopUpMsg
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objResp = AdRemovedRoot(fromDictionary: dictionary)
            success(objResp)
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
    
    //MARK:- Ad Post Dynamic Fields
    class func adPostDynamicFields(parameter: NSDictionary, success: @escaping(AdPostRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPostDynamicField
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: Any]
            let objSubCat = AdPostRoot(fromDictionary: dictionary)
            success(objSubCat)
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
    
    //MARK:- Ad Post Sub Locations
    class func adPostSubLocations(param: NSDictionary, success: @escaping(SubCategoryRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.adPostSubLocations
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSub = SubCategoryRoot(fromDictionary: dictionary)
            success(objSub)
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
    
    //MARK:- Advance Search Dynamic Search
    
    class func dynamicSearch(parameter: NSDictionary, success: @escaping(SearchRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.searchDynamic
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = SearchRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Near By Adds Search
    
    class func nearbyAddsSearch(params: NSDictionary, success: @escaping(NearByAddSearchRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.nearByLocation
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSearch = NearByAddSearchRoot(fromDictionary: dictionary)
            success(objSearch)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func nearbyAddRequest(params: NSDictionary, success: @escaping(NearByAddSearchRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.nearByLocation
        print(url)
        NetworkHandler.postDataRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSearch = NearByAddSearchRoot(fromDictionary: dictionary)
            success(objSearch)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
   
    //MARK:- Add Detail Rating Detail
    class func addDetailRating(parameter: NSDictionary, success: @escaping(AddRatingRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.addDetailRating
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objAdd = AddRatingRoot(fromDictionary: dictionary)
            success(objAdd)
        }) { (error) in
            
        }
    }
    
    //MARK:- Rating to Public User
    class func ratingToPublicUser(parameter: NSDictionary, success: @escaping(UserPublicRatingRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.publicUserRating
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String:Any]
            let objRate = UserPublicRatingRoot(fromDictionary: dictionary)
            success(objRate)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Post User Rating
    class func postUserRating(param: NSDictionary, success: @escaping(UserPublicRatingRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.postRating
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objRate = UserPublicRatingRoot(fromDictionary: dictionary)
            success(objRate)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Locations Details Data
    class func locationDetails(parameter: NSDictionary, success: @escaping(LocationDetailRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.locationDetail
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objDetail = LocationDetailRoot(fromDictionary: dictionary)
            success(objDetail)
        }) { (error) in
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- user Top Location
    class func topLocation(parameter: [String:Any], success: @escaping(UserForgot)->Void, failure: @escaping(NetworkError)->Void) {
        let url = Constants.URL.baseUrl+Constants.URL.topLocation
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objDetail = UserForgot(fromDictionary: dictionary)
            success(objDetail)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- React Emojis
    class func reactEmojis(parameter: [String:Any], success: @escaping(UserForgot)->Void, failure: @escaping(NetworkError)->Void) {
        let url = Constants.URL.baseUrl+Constants.URL.reactEmojis
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objDetail = UserForgot(fromDictionary: dictionary)
            success(objDetail)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
