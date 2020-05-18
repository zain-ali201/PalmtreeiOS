//
//  MyAdsAdVideo.swift
//  PalmTree
//
//  Created by SprintSols on 3/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct MyAdsAdVideo {
    
    var videoId : String!
    var videoUrl : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        videoId = dictionary["video_id"] as? String
        videoUrl = dictionary["video_url"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if videoId != nil{
            dictionary["video_id"] = videoId
        }
        if videoUrl != nil{
            dictionary["video_url"] = videoUrl
        }
        return dictionary
    }
    
}
