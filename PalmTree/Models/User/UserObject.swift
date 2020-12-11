//
//  UserRegisterData.swift
//  PalmTree
//
//  Created by SprintSols on 3/20/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import CoreLocation

struct UserObject
{
    var displayName : String!
    var id : Int!
    var phone = ""
    var profileImg : String!
    var userEmail : String!
    var currentLocation: CLLocation = CLLocation()
    var currentAddress = ""
    var locationName = "UAE"
    var country = ""
    var isAccountConfirm : Bool!
    var lat = 0.0
    var lng = 0.0
    var joining: String!
    var avatar : UIImage!
}

struct SaveAdObject
{
    var title = ""
    var catID = 0
    var catName = ""
    var locationName = ""
    var lat = 0.0
    var lng = 0.0
}
