//
//  AddDetailAdRating.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailAdRating {
    
    var adId : String!
    var btn : String!
    var canRate : Bool!
    var canRateMsg : String!
    var isEditable : Bool!
    var loadmoreBtn : String!
    var loadmoreBtnShow : Bool!
    var noRating : String!
    var noRatingMessage : String!
    var pagination : AddDetailPagination!
    var ratingShow : Bool!
    var ratings : [AddDetailRating]!
    var rplyDialog : AddDetailReplyDialogue!
    var sectionTitle : String!
    var tagline : String!
    var textareaText : String!
    var textareaValue : String!
    var title : String!
    
    var adRatingEmojies : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adId = dictionary["ad_id"] as? String
        btn = dictionary["btn"] as? String
        canRate = dictionary["can_rate"] as? Bool
        canRateMsg = dictionary["can_rate_msg"] as? String
        isEditable = dictionary["is_editable"] as? Bool
        loadmoreBtn = dictionary["loadmore_btn"] as? String
        loadmoreBtnShow = dictionary["loadmore_btn_show"] as? Bool
        noRating = dictionary["no_rating"] as? String
        noRatingMessage = dictionary["no_rating_message"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = AddDetailPagination(fromDictionary: paginationData)
        }
        ratingShow = dictionary["rating_show"] as? Bool
        ratings = [AddDetailRating]()
        if let ratingsArray = dictionary["ratings"] as? [[String:Any]]{
            for dic in ratingsArray{
                let value = AddDetailRating(fromDictionary: dic)
                ratings.append(value)
            }
        }
        if let rplyDialogData = dictionary["rply_dialog"] as? [String:Any]{
            rplyDialog = AddDetailReplyDialogue(fromDictionary: rplyDialogData)
        }
        sectionTitle = dictionary["section_title"] as? String
        tagline = dictionary["tagline"] as? String
        textareaText = dictionary["textarea_text"] as? String
        textareaValue = dictionary["textarea_value"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        if btn != nil{
            dictionary["btn"] = btn
        }
        if canRate != nil{
            dictionary["can_rate"] = canRate
        }
        if canRateMsg != nil{
            dictionary["can_rate_msg"] = canRateMsg
        }
        if isEditable != nil{
            dictionary["is_editable"] = isEditable
        }
        if loadmoreBtn != nil{
            dictionary["loadmore_btn"] = loadmoreBtn
        }
        if loadmoreBtnShow != nil{
            dictionary["loadmore_btn_show"] = loadmoreBtnShow
        }
        if noRating != nil{
            dictionary["no_rating"] = noRating
        }
        if noRatingMessage != nil{
            dictionary["no_rating_message"] = noRatingMessage
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if ratingShow != nil{
            dictionary["rating_show"] = ratingShow
        }
        if ratings != nil{
            var dictionaryElements = [[String:Any]]()
            for ratingsElement in ratings {
                dictionaryElements.append(ratingsElement.toDictionary())
            }
            dictionary["ratings"] = dictionaryElements
        }
        if rplyDialog != nil{
            dictionary["rply_dialog"] = rplyDialog.toDictionary()
        }
        if sectionTitle != nil{
            dictionary["section_title"] = sectionTitle
        }
        if tagline != nil{
            dictionary["tagline"] = tagline
        }
        if textareaText != nil{
            dictionary["textarea_text"] = textareaText
        }
        if textareaValue != nil{
            dictionary["textarea_value"] = textareaValue
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
