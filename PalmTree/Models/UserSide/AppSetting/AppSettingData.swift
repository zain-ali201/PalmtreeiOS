//
//  AppSettingData.swift
//  PalmTree
//
//  Created by SprintSols on 9/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AppSettingData {
    
    var about : AppSettingAbout!
    var appRating : AppSettingRating!
    var appShare : AppSettingShare!
    var appVersion : AppSettingVersion!
    var faqs : AppSettingFaq!
    var pageTitle : String!
    var privacyPolicy : AppSettingFaq!
    var sections : AppSettingSection!
    var tandc : AppSettingFaq!
    
    var feedback : AppSettingFeedback!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let aboutData = dictionary["about"] as? [String:Any]{
            about = AppSettingAbout(fromDictionary: aboutData)
        }
        if let appRatingData = dictionary["app_rating"] as? [String:Any]{
            appRating = AppSettingRating(fromDictionary: appRatingData)
        }
        if let appShareData = dictionary["app_share"] as? [String:Any]{
            appShare = AppSettingShare(fromDictionary: appShareData)
        }
        if let appVersionData = dictionary["app_version"] as? [String:Any]{
            appVersion = AppSettingVersion(fromDictionary: appVersionData)
        }
        if let faqsData = dictionary["faqs"] as? [String:Any]{
            faqs = AppSettingFaq(fromDictionary: faqsData)
        }
        pageTitle = dictionary["page_title"] as? String
        if let privacyPolicyData = dictionary["privacy_policy"] as? [String:Any]{
            privacyPolicy = AppSettingFaq(fromDictionary: privacyPolicyData)
        }
        if let sectionsData = dictionary["sections"] as? [String:Any]{
            sections = AppSettingSection(fromDictionary: sectionsData)
        }
        if let tandcData = dictionary["tandc"] as? [String:Any]{
            tandc = AppSettingFaq(fromDictionary: tandcData)
        }
        if let feedbackData = dictionary["feedback"] as? [String:Any]{
            feedback = AppSettingFeedback(fromDictionary: feedbackData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if about != nil{
            dictionary["about"] = about.toDictionary()
        }
        if appRating != nil{
            dictionary["app_rating"] = appRating.toDictionary()
        }
        if appShare != nil{
            dictionary["app_share"] = appShare.toDictionary()
        }
        if appVersion != nil{
            dictionary["app_version"] = appVersion.toDictionary()
        }
        if faqs != nil{
            dictionary["faqs"] = faqs.toDictionary()
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if privacyPolicy != nil{
            dictionary["privacy_policy"] = privacyPolicy.toDictionary()
        }
        if sections != nil{
            dictionary["sections"] = sections.toDictionary()
        }
        if tandc != nil{
            dictionary["tandc"] = tandc.toDictionary()
        }
        if feedback != nil{
            dictionary["feedback"] = feedback.toDictionary()
        }
        return dictionary
    }
    
}
