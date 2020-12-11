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
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var engImg: UIImageView!
    @IBOutlet weak var arabicImg: UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnEnglish: UILabel!
    @IBOutlet weak var btnArabic: UILabel!
    
    var langCode = "en"
    
    //MARK:- Properties
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Language Controller")
        
        langCode = languageCode
        
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- IBActions
    
    @IBAction func languageBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            langCode = "en"
            
            engImg.alpha = 1
            arabicImg.alpha = 0
        }
        else
        {
            langCode = "ar"
            
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
        languageCode = langCode
        defaults.set(languageCode, forKey: "languageCode")
        
        Bundle.setLanguage(languageCode)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
