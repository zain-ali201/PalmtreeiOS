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
    var currentLocation: CLLocation! = CLLocation()
    var currentAddress = ""
    var country = ""
    var isAccountConfirm : Bool!
}
