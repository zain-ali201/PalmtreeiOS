//
//  AdPostImagesData.swift
//  PalmTree
//
//  Created by SprintSols on 4/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostImagesData {
    
    var adImages : [AdPostImageArray]!
    var images : AdPostImages!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adImages = [AdPostImageArray]()
        if let adImagesArray = dictionary["ad_images"] as? [[String:Any]]{
            for dic in adImagesArray{
                let value = AdPostImageArray(fromDictionary: dic)
                adImages.append(value)
            }
        }
        if let imagesData = dictionary["images"] as? [String:Any]{
            images = AdPostImages(fromDictionary: imagesData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adImages != nil{
            var dictionaryElements = [[String:Any]]()
            for adImagesElement in adImages {
                dictionaryElements.append(adImagesElement.toDictionary())
            }
            dictionary["ad_images"] = dictionaryElements
        }
        if images != nil{
            dictionary["images"] = images.toDictionary()
        }
        return dictionary
    }
    
}
