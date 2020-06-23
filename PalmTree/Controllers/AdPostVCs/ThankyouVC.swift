//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ThankyouVC: UIViewController
{
    //MARK:- Properties
    

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: "languageCode") == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
    
    @IBAction func crossBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAdBtnAction(_ sender: Any)
    {
        let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostVC") as! AdPostVC
        adPostVC.fromVC = "Thankyou"
        self.navigationController?.pushViewController(adPostVC, animated: false)
    }
}
