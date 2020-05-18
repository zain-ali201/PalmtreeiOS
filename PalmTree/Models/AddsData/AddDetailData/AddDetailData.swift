//
//  AddDetailData.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailData {
    
    var adDetail : AddDetails!
    var adRatting : AddDetailAdRating!
    var bidPopup : AddDetailBidPopup!
    var callNowPopup : AddDetailCallPopup!
    var isFeatured : AddDetailIsFeatured!
    var messagePopup : AddDetailMessagePopup!
    var notification : String!
    var pageTitle : String!
    var profileDetail : AddDetailProfileDetail!
    var reportPopup : AddDetailReportPopup!
    var shareInfo : AddDetailShareInfo!
    var staticText : AddDetailStaticText!
    
    var cantReportTxt : String!
    var clickHereText : String!
    var editTxt : String!
    var showPhoneToLogin: Bool!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adDetailData = dictionary["ad_detail"] as? [String:Any]{
            adDetail = AddDetails(fromDictionary: adDetailData)
        }
        if let adRattingData = dictionary["ad_ratting"] as? [String:Any]{
            adRatting = AddDetailAdRating(fromDictionary: adRattingData)
        }
        if let bidPopupData = dictionary["bid_popup"] as? [String:Any]{
            bidPopup = AddDetailBidPopup(fromDictionary: bidPopupData)
        }
        if let callNowPopupData = dictionary["call_now_popup"] as? [String:Any]{
            callNowPopup = AddDetailCallPopup(fromDictionary: callNowPopupData)
        }
        if let isFeaturedData = dictionary["is_featured"] as? [String:Any]{
            isFeatured = AddDetailIsFeatured(fromDictionary: isFeaturedData)
        }
        if let messagePopupData = dictionary["message_popup"] as? [String:Any]{
            messagePopup = AddDetailMessagePopup(fromDictionary: messagePopupData)
        }
        notification = dictionary["notification"] as? String
        pageTitle = dictionary["page_title"] as? String
        if let profileDetailData = dictionary["profile_detail"] as? [String:Any]{
            profileDetail = AddDetailProfileDetail(fromDictionary: profileDetailData)
        }
        if let reportPopupData = dictionary["report_popup"] as? [String:Any]{
            reportPopup = AddDetailReportPopup(fromDictionary: reportPopupData)
        }
        if let shareInfoData = dictionary["share_info"] as? [String:Any]{
            shareInfo = AddDetailShareInfo(fromDictionary: shareInfoData)
        }
        if let staticTextData = dictionary["static_text"] as? [String:Any]{
            staticText = AddDetailStaticText(fromDictionary: staticTextData)
        }
        cantReportTxt = dictionary["cant_report_txt"] as? String
        clickHereText = dictionary["click_here_text"] as? String
        editTxt = dictionary["edit_txt"] as? String
        showPhoneToLogin = dictionary["show_phone_to_login"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adDetail != nil{
            dictionary["ad_detail"] = adDetail.toDictionary()
        }
        if adRatting != nil{
            dictionary["ad_ratting"] = adRatting.toDictionary()
        }
        if bidPopup != nil{
            dictionary["bid_popup"] = bidPopup.toDictionary()
        }
        if callNowPopup != nil{
            dictionary["call_now_popup"] = callNowPopup.toDictionary()
        }
        if isFeatured != nil{
            dictionary["is_featured"] = isFeatured.toDictionary()
        }
        if messagePopup != nil{
            dictionary["message_popup"] = messagePopup.toDictionary()
        }
        if notification != nil{
            dictionary["notification"] = notification
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if profileDetail != nil{
            dictionary["profile_detail"] = profileDetail.toDictionary()
        }
        if reportPopup != nil{
            dictionary["report_popup"] = reportPopup.toDictionary()
        }
        if shareInfo != nil{
            dictionary["share_info"] = shareInfo.toDictionary()
        }
        if staticText != nil{
            dictionary["static_text"] = staticText.toDictionary()
        }
        if cantReportTxt != nil{
            dictionary["cant_report_txt"] = cantReportTxt
        }
        if clickHereText != nil{
            dictionary["click_here_text"] = clickHereText
        }
        if editTxt != nil{
            dictionary["edit_txt"] = editTxt
        }
        if showPhoneToLogin != nil {
            dictionary["show_phone_to_login"] = showPhoneToLogin
        }
        return dictionary
    }
    
}
