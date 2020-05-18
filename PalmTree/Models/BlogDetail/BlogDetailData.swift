//
//  BlogDetailData
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogDetailData{
   
    var post : BlogDetailPost!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let postData = dictionary["post"] as? [String:Any]{
            post = BlogDetailPost(fromDictionary: postData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if post != nil{
            dictionary["post"] = post.toDictionary()
        }
        return dictionary
    }
    
}
