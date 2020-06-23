//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AdPostVC: UIViewController
{
    //MARK:- Properties
    var fromVC = ""

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
    
    @IBAction func cancelBtnACtion(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAdBtnACtion(_ sender: Any)
    {
        let featuredVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedVC") as! FeaturedVC
        self.navigationController?.pushViewController(featuredVC, animated: true)
    }
}
