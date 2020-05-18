//
//  HomeMenu.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeMenu {

    var blog : String!
    var favAds : String!
    var featuredAds : String!
    var home : String!
    var inactiveAds : String!
    var isShowMenu : HomeIsShowMenu!
    var login : String!
    var logout : String!
    var menuIsShowPackages : Bool!
    var messages : String!
    var myAds : String!
    var others : String!
    var packages : String!
    var profile : String!
    var register : String!
    var search : String!
    var submenu : HomeSubMenu!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        blog = dictionary["blog"] as? String
        favAds = dictionary["fav_ads"] as? String
        featuredAds = dictionary["featured_ads"] as? String
        home = dictionary["home"] as? String
        inactiveAds = dictionary["inactive_ads"] as? String
        if let isShowMenuData = dictionary["is_show_menu"] as? [String:Any]{
            isShowMenu = HomeIsShowMenu(fromDictionary: isShowMenuData)
        }
        login = dictionary["login"] as? String
        logout = dictionary["logout"] as? String
        menuIsShowPackages = dictionary["menu_is_show_packages"] as? Bool
        messages = dictionary["messages"] as? String
        myAds = dictionary["my_ads"] as? String
        others = dictionary["others"] as? String
        packages = dictionary["packages"] as? String
        profile = dictionary["profile"] as? String
        register = dictionary["register"] as? String
        search = dictionary["search"] as? String
        if let submenuData = dictionary["submenu"] as? [String:Any]{
            submenu = HomeSubMenu(fromDictionary: submenuData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if blog != nil{
            dictionary["blog"] = blog
        }
        if favAds != nil{
            dictionary["fav_ads"] = favAds
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds
        }
        if home != nil{
            dictionary["home"] = home
        }
        if inactiveAds != nil{
            dictionary["inactive_ads"] = inactiveAds
        }
        if isShowMenu != nil{
            dictionary["is_show_menu"] = isShowMenu.toDictionary()
        }
        if login != nil{
            dictionary["login"] = login
        }
        if logout != nil{
            dictionary["logout"] = logout
        }
        if menuIsShowPackages != nil{
            dictionary["menu_is_show_packages"] = menuIsShowPackages
        }
        if messages != nil{
            dictionary["messages"] = messages
        }
        if myAds != nil{
            dictionary["my_ads"] = myAds
        }
        if others != nil{
            dictionary["others"] = others
        }
        if packages != nil{
            dictionary["packages"] = packages
        }
        if profile != nil{
            dictionary["profile"] = profile
        }
        if register != nil{
            dictionary["register"] = register
        }
        if search != nil{
            dictionary["search"] = search
        }
        if submenu != nil{
            dictionary["submenu"] = submenu.toDictionary()
        }
        return dictionary
    }
    
}
