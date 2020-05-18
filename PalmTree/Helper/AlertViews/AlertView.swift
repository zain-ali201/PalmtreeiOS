//
//  AlertView.swift
//  PalmTree
//
//  Created by SprintSols on 3/28/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    class func prepare(title: String, message: String, okAction: (() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { action in
            okAction?()
        }
        
        alertController.addAction(OKAction)
        
        return alertController
    }
    
    class func prepare(title: String, action1 title1: String, action2 title2: String?, message: String, actionOne: (() -> ())?, actionTwo: (() -> ())?, cancelAction: (() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: title1, style: .default) { action in
            actionOne?()
        }
        
        alertController.addAction(actionOne)
        
        if let _ = title2 {
            let actionTwo = UIAlertAction(title: title2, style: .cancel) { action in
                actionTwo?()
            }
            
            alertController.addAction(actionTwo)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            cancelAction?()
        }
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
