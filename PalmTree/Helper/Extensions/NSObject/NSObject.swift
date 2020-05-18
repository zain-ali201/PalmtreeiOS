//
//  NSObject.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
