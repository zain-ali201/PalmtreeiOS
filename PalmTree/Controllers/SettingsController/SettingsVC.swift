//
//  SettingsController.swift
//  PalmTree
//
//  Created by SprintSols on 9/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var signoutView: UIView!
    
    @IBOutlet weak var lblRights: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    @IBOutlet weak var lblLang: UILabel!
    @IBOutlet weak var lblLang1: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isLogin") == false
        {
            signinView.alpha = 1
            signoutView.alpha = 0
        }
        else
        {
            signinView.alpha = 0
            signoutView.alpha = 1
            
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        
        lblVersion.text = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        
        if defaults.string(forKey: "languageCode") == "ar"
        {
//            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblRights.text = String(format: "Palmtree %@ حقوق النشر", formatter.string(from: Date()))
        }
        else
        {
            lblRights.text = String(format: "Copyrights %@ Palmtree", formatter.string(from: Date()))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLogin")
        {
            scrollView.contentSize = CGSize(width: 0, height: 780)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signinBtnAction(_ sender: Any)
    {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)
        self.present(navController, animated:true, completion: nil)
    }
    
    @IBAction func signoutBtnAction(_ sender: Any)
    {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to signout?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default) { (action) in
            
            defaults.set(false, forKey: "isLogin")
            defaults.set(false, forKey: "isGuest")
            defaults.set(false, forKey: "isSocial")
            FacebookAuthentication.signOut()
            GoogleAuthenctication.signOut()
            
            self.navigationController?.popToViewController(homeVC, animated: true)
        }
        
        let no = UIAlertAction(title: "NO", style: .cancel) { (action) in
            
        }
        
        alert.addAction(yes)
        alert.addAction(no)
        self.presentVC(alert)
    }
    
    @IBAction func languageBtnAction(_ sender: Any)
    {
        let languageVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        self.present(languageVC, animated:true, completion: nil)
    }
    
    @IBAction func termsBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsController") as! TermsConditionsController
            self.navigationController?.pushViewController(termsVC, animated: true)
        }
        else if button.tag == 1002
        {
            let privacyVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyController") as! PrivacyController
            self.navigationController?.pushViewController(privacyVC, animated: true)
        }
        else if button.tag == 1003
        {
            
        }
    }
}
