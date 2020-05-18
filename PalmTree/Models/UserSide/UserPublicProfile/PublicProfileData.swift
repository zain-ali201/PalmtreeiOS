//
//  PublicProfileData.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PublicProfileData {
    
    var ads : [PublicProfileAdd]!
    var id : Int!
    var introduction : PublicProfileIntro!
    var isShowSocial : Bool!
    var pageTitle : String!
    var pagination : PublicProfilePagination!
    var profileExtra : PublicProfileExtra!
    var socialIcons : [PublicProfileIntro]!
    var text : PublicProfileText!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        ads = [PublicProfileAdd]()
        if let adsArray = dictionary["ads"] as? [[String:Any]]{
            for dic in adsArray{
                let value = PublicProfileAdd(fromDictionary: dic)
                ads.append(value)
            }
        }
        id = dictionary["id"] as? Int
        if let introductionData = dictionary["introduction"] as? [String:Any]{
            introduction = PublicProfileIntro(fromDictionary: introductionData)
        }
        isShowSocial = dictionary["is_show_social"] as? Bool
        pageTitle = dictionary["page_title"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = PublicProfilePagination(fromDictionary: paginationData)
        }
        if let profileExtraData = dictionary["profile_extra"] as? [String:Any]{
            profileExtra = PublicProfileExtra(fromDictionary: profileExtraData)
        }
        socialIcons = [PublicProfileIntro]()
        if let socialIconsArray = dictionary["social_icons"] as? [[String:Any]]{
            for dic in socialIconsArray{
                let value = PublicProfileIntro(fromDictionary: dic)
                socialIcons.append(value)
            }
        }
        if let textData = dictionary["text"] as? [String:Any]{
            text = PublicProfileText(fromDictionary: textData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if ads != nil{
            var dictionaryElements = [[String:Any]]()
            for adsElement in ads {
                dictionaryElements.append(adsElement.toDictionary())
            }
            dictionary["ads"] = dictionaryElements
        }
        if id != nil{
            dictionary["id"] = id
        }
        if introduction != nil{
            dictionary["introduction"] = introduction.toDictionary()
        }
        if isShowSocial != nil{
            dictionary["is_show_social"] = isShowSocial
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if profileExtra != nil{
            dictionary["profile_extra"] = profileExtra.toDictionary()
        }
        if socialIcons != nil{
            var dictionaryElements = [[String:Any]]()
            for socialIconsElement in socialIcons {
                dictionaryElements.append(socialIconsElement.toDictionary())
            }
            dictionary["social_icons"] = dictionaryElements
        }
        if text != nil{
            dictionary["text"] = text.toDictionary()
        }
        return dictionary
    }
    
}
