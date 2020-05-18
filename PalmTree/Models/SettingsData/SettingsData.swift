//
//  SettingsData.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsData {
  
    var adsPositionSorter : Bool!
    var alertDialog : SettingsAlertDialog!
    var appRating : SettingsAppRating!
    var appShare : SettingsAppShare!
    var appShowLanguages : Bool!
    var catInput : String!
    var dialog : SettingsDialog!
    var featuredScrollEnabled : Bool!
    var gmapCountries : String!
    var gmapHasCountries : Bool!
    var gmapLang : String!
    var gpsPopup : SettingsGpsPopup!
    var guestImage : String!
    var guestName : String!
    var heading : String!
    var internetDialog : SettingsInternetDialogue!
    var isAppOpen : Bool!
    var isRtl : Bool!
    var locationPopup : SettingsLocationPopup!
    var locationType : String!
    var mainColor : String!
    var menu : SettingsMenu!
    var message : String!
    var messagesScreen : SettingsMessagesScreen!
    var notLoginMsg : String!
    var registerBtnShow : SettingsRegisterbuttonShow!
    var search : SettingsSearch!
    var showNearby : Bool!
    
    var allowBlock : Bool!
    var featuredScroll : SettingsFeaturedScroll!
    var shopMenu : [SettingsShopMenu]!
    var appPageTestUrl: String!
    var wpml_logo: String!
    var wpml_header_title_1: String!
    var wpml_header_title_2: String!
    var language_style: String!
    var is_wpml_active: Bool!
    var is_Top_Location: Bool!
    var wpml_menu_text: String!
    var langData : [LangData]!
    var location_text: String!
    var notVerified: String!
    var ImgReqMessage: String!
    var ImgUplaoding: String!
    var InValidUrl: String!
    var buyText:String!
    var showHome :Bool!
    var advanceIcon :Bool!
    var homescreenLayout:String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adsPositionSorter = dictionary["ads_position_sorter"] as? Bool
        if let alertDialogData = dictionary["alert_dialog"] as? [String:Any]{
            alertDialog = SettingsAlertDialog(fromDictionary: alertDialogData)
        }
        if let appRatingData = dictionary["app_rating"] as? [String:Any]{
            appRating = SettingsAppRating(fromDictionary: appRatingData)
        }
        if let appShareData = dictionary["app_share"] as? [String:Any]{
            appShare = SettingsAppShare(fromDictionary: appShareData)
        }
        appShowLanguages = dictionary["app_show_languages"] as? Bool
        catInput = dictionary["cat_input"] as? String
        if let dialogData = dictionary["dialog"] as? [String:Any]{
            dialog = SettingsDialog(fromDictionary: dialogData)
        }
        featuredScrollEnabled = dictionary["featured_scroll_enabled"] as? Bool
        gmapCountries = dictionary["gmap_countries"] as? String
        gmapHasCountries = dictionary["gmap_has_countries"] as? Bool
        gmapLang = dictionary["gmap_lang"] as? String
        if let gpsPopupData = dictionary["gps_popup"] as? [String:Any]{
            gpsPopup = SettingsGpsPopup(fromDictionary: gpsPopupData)
        }
        guestImage = dictionary["guest_image"] as? String
        guestName = dictionary["guest_name"] as? String
        heading = dictionary["heading"] as? String
        if let internetDialogData = dictionary["internet_dialog"] as? [String:Any]{
            internetDialog = SettingsInternetDialogue(fromDictionary: internetDialogData)
        }
        isAppOpen = dictionary["is_app_open"] as? Bool
        isRtl = dictionary["is_rtl"] as? Bool
        if let locationPopupData = dictionary["location_popup"] as? [String:Any]{
            locationPopup = SettingsLocationPopup(fromDictionary: locationPopupData)
        }
        locationType = dictionary["location_type"] as? String
        mainColor = dictionary["main_color"] as? String
        if let menuData = dictionary["menu"] as? [String:Any]{
            menu = SettingsMenu(fromDictionary: menuData)
        }
        message = dictionary["message"] as? String
        if let messagesScreenData = dictionary["messages_screen"] as? [String:Any]{
            messagesScreen = SettingsMessagesScreen(fromDictionary: messagesScreenData)
        }
        notLoginMsg = dictionary["notLogin_msg"] as? String
        if let registerBtnShowData = dictionary["registerBtn_show"] as? [String:Any]{
            registerBtnShow = SettingsRegisterbuttonShow(fromDictionary: registerBtnShowData)
        }
        if let searchData = dictionary["search"] as? [String:Any]{
            search = SettingsSearch(fromDictionary: searchData)
        }
        showNearby = dictionary["show_nearby"] as? Bool
        showHome = dictionary["show_home_icon"] as? Bool
        advanceIcon = dictionary["show_adv_search_icon"] as? Bool
        
        allowBlock = dictionary["allow_block"] as? Bool
        if let featuredScrollData = dictionary["featured_scroll"] as? [String:Any]{
            featuredScroll = SettingsFeaturedScroll(fromDictionary: featuredScrollData)
        }
        
        shopMenu = [SettingsShopMenu]()
        if let shopMenuArray = dictionary["shop_menu"] as? [[String:Any]]{
            for dic in shopMenuArray{
                let value = SettingsShopMenu(fromDictionary: dic)
                shopMenu.append(value)
            }
        }
        
        langData = [LangData]()
        if let langArr = dictionary["site_languages"] as? [[String:Any]]{
            for dic in langArr{
                let value = LangData(fromDictionary: dic)
                langData.append(value)
            }
        }
        
        
        buyText = dictionary["app_paid_cat_text"] as? String
        appPageTestUrl = dictionary["app_page_test_url"] as? String
        wpml_logo = dictionary["wpml_logo"] as? String
        wpml_header_title_1 = dictionary["wpml_header_title_1"] as? String
        wpml_header_title_2 = dictionary["wpml_header_title_2"] as? String
        language_style = dictionary["language_style"] as? String
        is_wpml_active = dictionary["is_wpml_active"] as? Bool
        is_Top_Location = dictionary["is_top_location"] as? Bool
        wpml_menu_text = dictionary["wpml_menu_text"] as? String
        location_text = dictionary["app_location_text"] as? String
        notVerified = dictionary["verified_msg"] as? String
        ImgReqMessage = dictionary["required_img"] as? String
        ImgUplaoding = dictionary["uploading_label"] as? String
        homescreenLayout = dictionary["homescreen_layout"] as? String
        InValidUrl = dictionary["invalid_url"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adsPositionSorter != nil{
            dictionary["ads_position_sorter"] = adsPositionSorter
        }
        if alertDialog != nil{
            dictionary["alert_dialog"] = alertDialog.toDictionary()
        }
        if appRating != nil{
            dictionary["app_rating"] = appRating.toDictionary()
        }
        if appShare != nil{
            dictionary["app_share"] = appShare.toDictionary()
        }
        if appShowLanguages != nil{
            dictionary["app_show_languages"] = appShowLanguages
        }
        if catInput != nil{
            dictionary["cat_input"] = catInput
        }
        if dialog != nil{
            dictionary["dialog"] = dialog.toDictionary()
        }
        if featuredScrollEnabled != nil{
            dictionary["featured_scroll_enabled"] = featuredScrollEnabled
        }
        if gmapCountries != nil{
            dictionary["gmap_countries"] = gmapCountries
        }
        if gmapHasCountries != nil{
            dictionary["gmap_has_countries"] = gmapHasCountries
        }
        if gmapLang != nil{
            dictionary["gmap_lang"] = gmapLang
        }
        if gpsPopup != nil{
            dictionary["gps_popup"] = gpsPopup.toDictionary()
        }
        if guestImage != nil{
            dictionary["guest_image"] = guestImage
        }
        if guestName != nil{
            dictionary["guest_name"] = guestName
        }
        if heading != nil{
            dictionary["heading"] = heading
        }
        if internetDialog != nil{
            dictionary["internet_dialog"] = internetDialog.toDictionary()
        }
        if isAppOpen != nil{
            dictionary["is_app_open"] = isAppOpen
        }
        if isRtl != nil{
            dictionary["is_rtl"] = isRtl
        }
        if locationPopup != nil{
            dictionary["location_popup"] = locationPopup.toDictionary()
        }
        if locationType != nil{
            dictionary["location_type"] = locationType
        }
        if mainColor != nil{
            dictionary["main_color"] = mainColor
        }
        if menu != nil{
            dictionary["menu"] = menu.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if messagesScreen != nil{
            dictionary["messages_screen"] = messagesScreen.toDictionary()
        }
        if notLoginMsg != nil{
            dictionary["notLogin_msg"] = notLoginMsg
        }
        if registerBtnShow != nil{
            dictionary["registerBtn_show"] = registerBtnShow.toDictionary()
        }
        if search != nil{
            dictionary["search"] = search.toDictionary()
        }
        if showNearby != nil{
            dictionary["show_nearby"] = showNearby
        }
        if allowBlock != nil{
            dictionary["allow_block"] = allowBlock
        }
        if featuredScroll != nil{
            dictionary["featured_scroll"] = featuredScroll.toDictionary()
        }
        if shopMenu != nil{
            var dictionaryElements = [[String:Any]]()
            for shopMenuElement in shopMenu {
                dictionaryElements.append(shopMenuElement.toDictionary())
            }
            dictionary["shop_menu"] = dictionaryElements
        }
        
        
        
        if appPageTestUrl != nil {
            dictionary["app_page_test_url"] = appPageTestUrl
        }
        
        if notVerified != nil {
            dictionary["verified_msg"] = notVerified
        }
        if ImgReqMessage != nil {
            dictionary["required_img"] = ImgReqMessage
        }
        if is_Top_Location != nil{
            dictionary["is_top_location"] = is_Top_Location
        }
        if ImgUplaoding != nil{
            dictionary["uploading_label"] = ImgUplaoding
        }
        if homescreenLayout != nil {
            dictionary["homescreen_layout"] = homescreenLayout
        }
        if InValidUrl != nil {
            dictionary["invalid_url"] = InValidUrl
        }

        return dictionary
    }
    
}
