//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FeaturedVC: UIViewController
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func skipBtnACtion(_ sender: Any)
    {
        let thankyouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
        self.navigationController?.pushViewController(thankyouVC, animated: true)
    }
}
