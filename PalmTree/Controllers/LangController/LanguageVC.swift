//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController{

    //MARK:- Outlets
    
    @IBOutlet weak var engImg: UIImageView!
    @IBOutlet weak var arabicImg: UIImageView!
    
    var languageCode = "en"
    
    //MARK:- Properties
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Language Controller")
        
        if defaults.string(forKey: "languageCode") != nil
        {
            languageCode = defaults.string(forKey: "languageCode")!
            
            if languageCode == "en"
            {
                engImg.alpha = 1
                arabicImg.alpha = 0
            }
            else
            {
                engImg.alpha = 0
                arabicImg.alpha = 1
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- IBActions
    
    @IBAction func languageBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            languageCode = "en"
            
            engImg.alpha = 1
            arabicImg.alpha = 0
        }
        else
        {
            languageCode = "ar"
            
            engImg.alpha = 0
            arabicImg.alpha = 1
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: Any)
    {
        defaults.set(languageCode, forKey: "languageCode")
        
        if languageCode == "en"
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        
        let objStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let rootNav = objStoryboard.instantiateViewController(withIdentifier: "HomeNavController") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = rootNav
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        let settingsVC = objStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        rootNav.pushViewController(settingsVC, animated: true)
    }
}
