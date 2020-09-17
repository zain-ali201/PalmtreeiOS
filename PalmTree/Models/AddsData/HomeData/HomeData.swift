//
//  HomeData.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeData {
    
    var adsPosition : [String]!
    var adsPositionSorter : Bool!
    var catIcons : [CatIcon]!
    var catIconsColumn : String!
    var catLocations : [CatLocation]!
    var catLocationsColumn : Int!
    var catLocationsTitle : String!
    var catLocationsType : String!
    var featuredAds : HomeFeaturedAdd!
    var featuredPosition : String!
    var fieldTypeName : String!
    var isShowBlog : Bool!
    var isShowFeatured : Bool!
    var isShowLatest : Bool!
    var isShowNearby : Bool!
    var latestAds : HomeFeaturedAdd!
    var latestBlog : HomeLatestBlog!
    var menu : HomeMenu!
    var nearbyAds : HomeFeaturedAdd!
    var pageTitle : String!
    var sliders : [HomeSlider]!
    var viewAll : String!
    
    var searchSection : HomeSearchSection!
    var catIconsColumnBtn : CatIconsColumnBtn!
    var catLocationsBtn : CatIconsColumnBtn!
    
    var appTopLocation : Bool!
    var appTopLocationList : [HomeAppTopLocation]!
    var ad_post : HomeAdpost!
    

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adsPosition = dictionary["ads_position"] as? [String]
        adsPositionSorter = dictionary["ads_position_sorter"] as? Bool
        catIcons = [CatIcon]()
        if let catIconsArray = dictionary["cat_icons"] as? [[String:Any]]{
            for dic in catIconsArray{
                let value = CatIcon(fromDictionary: dic)
                catIcons.append(value)
            }
        }
        catIconsColumn = dictionary["cat_icons_column"] as? String
        catLocations = [CatLocation]()
        if let catLocationsArray = dictionary["cat_locations"] as? [[String:Any]]{
            for dic in catLocationsArray{
                let value = CatLocation(fromDictionary: dic)
                catLocations.append(value)
            }
        }
        catLocationsColumn = dictionary["cat_locations_column"] as? Int
        catLocationsTitle = dictionary["cat_locations_title"] as? String
        catLocationsType = dictionary["cat_locations_type"] as? String
        if let featuredAdsData = dictionary["featured_ads"] as? [String:Any]{
            featuredAds = HomeFeaturedAdd(fromDictionary: featuredAdsData)
        }
        featuredPosition = dictionary["featured_position"] as? String
        fieldTypeName = dictionary["field_type_name"] as? String
        isShowBlog = dictionary["is_show_blog"] as? Bool
        isShowFeatured = dictionary["is_show_featured"] as? Bool
        isShowLatest = dictionary["is_show_latest"] as? Bool
        isShowNearby = dictionary["is_show_nearby"] as? Bool
        if let latestAdsData = dictionary["latest_ads"] as? [String:Any]{
            latestAds = HomeFeaturedAdd(fromDictionary: latestAdsData)
        }
        if let latestBlogData = dictionary["latest_blog"] as? [String:Any]{
            latestBlog = HomeLatestBlog(fromDictionary: latestBlogData)
        }
        if let menuData = dictionary["menu"] as? [String:Any]{
            menu = HomeMenu(fromDictionary: menuData)
        }
        if let nearbyAdsData = dictionary["nearby_ads"] as? [String:Any]{
            nearbyAds = HomeFeaturedAdd(fromDictionary: nearbyAdsData)
        }
        pageTitle = dictionary["page_title"] as? String
        sliders = [HomeSlider]()
        if let slidersArray = dictionary["sliders"] as? [[String:Any]]{
            for dic in slidersArray {
                let value = HomeSlider(fromDictionary: dic)
                sliders.append(value)
            }
        }
        viewAll = dictionary["view_all"] as? String
        
        if let searchSectionData = dictionary["search_section"] as? [String:Any]{
            searchSection = HomeSearchSection(fromDictionary: searchSectionData)
        }
        
        if let catIconsColumnBtnData = dictionary["cat_icons_column_btn"] as? [String:Any]{
            catIconsColumnBtn = CatIconsColumnBtn(fromDictionary: catIconsColumnBtnData)
        }
        if let catLocationsBtnData = dictionary["cat_locations_btn"] as? [String:Any]{
            catLocationsBtn = CatIconsColumnBtn(fromDictionary: catLocationsBtnData)
        }
        appTopLocation = dictionary["app_top_location"] as? Bool
        print(appTopLocation)
        appTopLocationList = [HomeAppTopLocation]()
        if let appTopLocationListArray = dictionary["app_top_location_list"] as? [[String:Any]]{
            for dic in appTopLocationListArray{
                let value = HomeAppTopLocation(fromDictionary: dic)
                appTopLocationList.append(value)
            }
        }
        
        if let ad_pos = dictionary["ad_post"] as? [String:Any]{
            ad_post = HomeAdpost(fromDictionary: ad_pos)
        }
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adsPosition != nil{
            dictionary["ads_position"] = adsPosition
        }
        if adsPositionSorter != nil{
            dictionary["ads_position_sorter"] = adsPositionSorter
        }
        
        if catIcons != nil{
            var dictionaryElements = [[String:Any]]()
            for catIconsElement in catIcons {
                dictionaryElements.append(catIconsElement.toDictionary())
            }
            dictionary["cat_icons"] = dictionaryElements
        }
        
        if catIconsColumn != nil{
            dictionary["cat_icons_column"] = catIconsColumn
        }
        if catLocations != nil{
            var dictionaryElements = [[String:Any]]()
            for catLocationsElement in catLocations {
                dictionaryElements.append(catLocationsElement.toDictionary())
            }
            dictionary["cat_locations"] = dictionaryElements
        }
        if catLocationsColumn != nil{
            dictionary["cat_locations_column"] = catLocationsColumn
        }
        if catLocationsTitle != nil{
            dictionary["cat_locations_title"] = catLocationsTitle
        }
        if catLocationsType != nil{
            dictionary["cat_locations_type"] = catLocationsType
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds.toDictionary()
        }
        if featuredPosition != nil{
            dictionary["featured_position"] = featuredPosition
        }
        if fieldTypeName != nil{
            dictionary["field_type_name"] = fieldTypeName
        }
        if isShowBlog != nil{
            dictionary["is_show_blog"] = isShowBlog
        }
        if isShowFeatured != nil{
            dictionary["is_show_featured"] = isShowFeatured
        }
        if isShowLatest != nil{
            dictionary["is_show_latest"] = isShowLatest
        }
        if isShowNearby != nil{
            dictionary["is_show_nearby"] = isShowNearby
        }
        if latestAds != nil{
            dictionary["latest_ads"] = latestAds.toDictionary()
        }
        if latestBlog != nil{
            dictionary["latest_blog"] = latestBlog.toDictionary()
        }
        if menu != nil{
            dictionary["menu"] = menu.toDictionary()
        }
        if nearbyAds != nil{
            dictionary["nearby_ads"] = nearbyAds.toDictionary()
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if sliders != nil{
            var dictionaryElements = [[String:Any]]()
            for slidersElement in sliders {
                dictionaryElements.append(slidersElement.toDictionary())
            }
            dictionary["sliders"] = dictionaryElements
        }
        if viewAll != nil{
            dictionary["view_all"] = viewAll
        }
        if searchSection != nil{
            dictionary["search_section"] = searchSection.toDictionary()
        }
        if catIconsColumnBtn != nil{
            dictionary["cat_icons_column_btn"] = catIconsColumnBtn.toDictionary()
        }
        if catLocationsBtn != nil{
            dictionary["cat_locations_btn"] = catLocationsBtn.toDictionary()
        }
        if appTopLocation != nil{
            dictionary["app_top_location"] = appTopLocation
        }
        if appTopLocationList != nil{
            var dictionaryElements = [[String:Any]]()
            for appTopLocationListElement in appTopLocationList {
                dictionaryElements.append(appTopLocationListElement.toDictionary())
            }
            dictionary["app_top_location_list"] = dictionaryElements
        }
        return dictionary
    }
}


