//
//  AddDetailStaticText.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailStaticText {
    
    var adBids : AddDetailAddBid!
    var adBidsEnable : Bool!
    var bidNowBtn : String!
    var bidStatsBtn : String!
    var bidTabs : AddDetailBidTab!
    var callNowBtn : String!
    var descriptionTitle : String!
    var favBtn : String!
    var editBtn : String!
    var getDirection : String!
    var relatedPostsTitle : String!
    var reportBtn : String!
    var sendMsgBtn : String!
    var sendMsgBtnType : String!
    var shareBtn : String!
    var showCallBtn : Bool!
    var showMegsBtn : Bool!
    var blockUser : AddDetailsBlockUser!
    var viewLink : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adBidsData = dictionary["ad_bids"] as? [String:Any]{
            adBids = AddDetailAddBid(fromDictionary: adBidsData)
        }
        adBidsEnable = dictionary["ad_bids_enable"] as? Bool
        bidNowBtn = dictionary["bid_now_btn"] as? String
        bidStatsBtn = dictionary["bid_stats_btn"] as? String
        if let bidTabsData = dictionary["bid_tabs"] as? [String:Any]{
            bidTabs = AddDetailBidTab(fromDictionary: bidTabsData)
        }
        callNowBtn = dictionary["call_now_btn"] as? String
        descriptionTitle = dictionary["description_title"] as? String
        favBtn = dictionary["fav_btn"] as? String
        getDirection = dictionary["get_direction"] as? String
        relatedPostsTitle = dictionary["related_posts_title"] as? String
        reportBtn = dictionary["report_btn"] as? String
        sendMsgBtn = dictionary["send_msg_btn"] as? String
        sendMsgBtnType = dictionary["send_msg_btn_type"] as? String
        shareBtn = dictionary["share_btn"] as? String
        showCallBtn = dictionary["show_call_btn"] as? Bool
        showMegsBtn = dictionary["show_megs_btn"] as? Bool
        editBtn = dictionary["edit_txt"] as? String
        viewLink = dictionary["click_here_text"] as?String
        if let blockUserData = dictionary["block_user"] as? [String:Any]{
            blockUser = AddDetailsBlockUser(fromDictionary: blockUserData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adBids != nil{
            dictionary["ad_bids"] = adBids.toDictionary()
        }
        if adBidsEnable != nil{
            dictionary["ad_bids_enable"] = adBidsEnable
        }
        if bidNowBtn != nil{
            dictionary["bid_now_btn"] = bidNowBtn
        }
        if bidStatsBtn != nil{
            dictionary["bid_stats_btn"] = bidStatsBtn
        }
        if bidTabs != nil{
            dictionary["bid_tabs"] = bidTabs.toDictionary()
        }
        if callNowBtn != nil{
            dictionary["call_now_btn"] = callNowBtn
        }
        if descriptionTitle != nil{
            dictionary["description_title"] = descriptionTitle
        }
        if favBtn != nil{
            dictionary["fav_btn"] = favBtn
        }
        if getDirection != nil{
            dictionary["get_direction"] = getDirection
        }
        if relatedPostsTitle != nil{
            dictionary["related_posts_title"] = relatedPostsTitle
        }
        if reportBtn != nil{
            dictionary["report_btn"] = reportBtn
        }
        if sendMsgBtn != nil{
            dictionary["send_msg_btn"] = sendMsgBtn
        }
        if sendMsgBtnType != nil{
            dictionary["send_msg_btn_type"] = sendMsgBtnType
        }
        if shareBtn != nil{
            dictionary["share_btn"] = shareBtn
        }
        if showCallBtn != nil{
            dictionary["show_call_btn"] = showCallBtn
        }
        if showMegsBtn != nil{
            dictionary["show_megs_btn"] = showMegsBtn
        }
        if blockUser != nil{
            dictionary["block_user"] = blockUser.toDictionary()
        }
        if editBtn != nil{
            dictionary["edit_txt"] = editBtn
        }
        if viewLink != nil{
            dictionary["click_here_text"] = viewLink
        }
        return dictionary
    }
    
}
