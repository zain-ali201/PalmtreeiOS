//
//  PackagesDataProduct.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackagesDataProduct {
    

    var bumpAdsText : String!
    var bumpAdsValue : String!
    var color : String!
    var daysText : String!
    var daysValue : String!
    var featuredAdsText : String!
    var featuredAdsValue : String!
    var freeAdsText : String!
    var freeAdsValue : String!
    var paymentTypesValue : String!
    var productAmount : PackagesDataProductAmount!
    var productBtn : String!
    var productId : String!
    var productLink : String!
    var productPrice : String!
    var productQty : Int!
    var productTitle : String!
    var allow_bidding_text : String!
    var allow_bidding_value : String!
    var num_of_images_text : String!
    var num_of_images_val : String!
    var video_url_text : String!
    var video_url_val : String!
    var allow_tags_text : String!
    var allow_tags_val : String!
    var allow_cats_text : String!
    var allow_cats_val : String!
    var allow_cats_valArr : [AllowCatsValue]!
    var seeAll : String!
    var isSale : Bool!
    var saleText :String!
    var regularPrice: String!
    
    var productAppCode : PackageDataAppCode!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bumpAdsText = dictionary["bump_ads_text"] as? String
        bumpAdsValue = dictionary["bump_ads_value"] as? String
        color = dictionary["color"] as? String
        daysText = dictionary["days_text"] as? String
        daysValue = dictionary["days_value"] as? String
        featuredAdsText = dictionary["featured_ads_text"] as? String
        featuredAdsValue = dictionary["featured_ads_value"] as? String
        freeAdsText = dictionary["free_ads_text"] as? String
        freeAdsValue = dictionary["free_ads_value"] as? String
        paymentTypesValue = dictionary["payment_types_value"] as? String
        if let productAmountData = dictionary["product_amount"] as? [String:Any]{
            productAmount = PackagesDataProductAmount(fromDictionary: productAmountData)
        }
        productBtn = dictionary["product_btn"] as? String
        productId = dictionary["product_id"] as? String
        productLink = dictionary["product_link"] as? String
        productPrice = dictionary["product_price"] as? String
        productQty = dictionary["product_qty"] as? Int
        productTitle = dictionary["product_title"] as? String
        allow_bidding_text = dictionary["allow_bidding_text"] as? String
        allow_bidding_value = dictionary["allow_bidding_value"] as? String
        num_of_images_text = dictionary["num_of_images_text"] as? String
        num_of_images_val = dictionary["num_of_images_val"] as? String
        video_url_text = dictionary["video_url_text"] as? String
        video_url_val = dictionary["video_url_val"] as? String
        allow_tags_text = dictionary["allow_tags_text"] as? String
        allow_tags_val = dictionary["allow_tags_val"] as? String
        allow_cats_text = dictionary["allow_cats_text"] as? String
        allow_cats_val = dictionary["allow_cats_val"] as? String
        seeAll = dictionary["see_all_cats"] as? String
        isSale = dictionary["is_sale"] as? Bool
        saleText = dictionary["sale_text"] as? String
        regularPrice = dictionary["regular_price"] as? String
        if let productAppCodeData = dictionary["product_appCode"] as? [String:Any]{
            productAppCode = PackageDataAppCode(fromDictionary: productAppCodeData)
        }
        
        allow_cats_valArr = [AllowCatsValue]()
        if let productsArray = dictionary["allow_cats_val_arr"] as? [[String:Any]]{
            for dic in productsArray{
                let value = AllowCatsValue(fromDictionary: dic)
                allow_cats_valArr.append(value)
            }
        }
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bumpAdsText != nil{
            dictionary["bump_ads_text"] = bumpAdsText
        }
        if bumpAdsValue != nil{
            dictionary["bump_ads_value"] = bumpAdsValue
        }
        if color != nil{
            dictionary["color"] = color
        }
        if daysText != nil{
            dictionary["days_text"] = daysText
        }
        if daysValue != nil{
            dictionary["days_value"] = daysValue
        }
        if featuredAdsText != nil{
            dictionary["featured_ads_text"] = featuredAdsText
        }
        if featuredAdsValue != nil{
            dictionary["featured_ads_value"] = featuredAdsValue
        }
        if freeAdsText != nil{
            dictionary["free_ads_text"] = freeAdsText
        }
        if freeAdsValue != nil{
            dictionary["free_ads_value"] = freeAdsValue
        }
        if paymentTypesValue != nil{
            dictionary["payment_types_value"] = paymentTypesValue
        }
        if productAmount != nil{
            dictionary["product_amount"] = productAmount.toDictionary()
        }
        if productBtn != nil{
            dictionary["product_btn"] = productBtn
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if productLink != nil{
            dictionary["product_link"] = productLink
        }
        if productPrice != nil{
            dictionary["product_price"] = productPrice
        }
        if isSale != nil{
            dictionary["is_sale"] = isSale
        }
        if saleText != nil{
            dictionary["sale_text"] = saleText
        }
        if regularPrice != nil{
            dictionary["regular_price"] = regularPrice
        }
        if productQty != nil{
            dictionary["product_qty"] = productQty
        }
        if productTitle != nil{
            dictionary["product_title"] = productTitle
        }
        if productAppCode != nil{
            dictionary["product_appCode"] = productAppCode.toDictionary()
        }
        return dictionary
    }
    
}
