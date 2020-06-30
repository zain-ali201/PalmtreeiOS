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
    
    //Signout Butotns
    @IBOutlet weak var btnSignin: UILabel!
    @IBOutlet weak var btnShareApp: UILabel!
    @IBOutlet weak var btnHelp: UILabel!
    @IBOutlet weak var btnLang: UILabel!
    @IBOutlet weak var btnPolicy: UILabel!
    @IBOutlet weak var btnTerms: UILabel!
    @IBOutlet weak var btnLegal: UILabel!
    
    //Signout Butotns
    @IBOutlet weak var btnSignout: UILabel!
    @IBOutlet weak var btnShareApp1: UILabel!
    @IBOutlet weak var btnHelp1: UILabel!
    @IBOutlet weak var btnLang1: UILabel!
    @IBOutlet weak var btnPolicy1: UILabel!
    @IBOutlet weak var btnTerms1: UILabel!
    @IBOutlet weak var btnLegal1: UILabel!
    @IBOutlet weak var btnDetails: UILabel!
    @IBOutlet weak var btnAlert: UILabel!
    @IBOutlet weak var btnMessage: UILabel!
    @IBOutlet weak var btnUpdate: UILabel!
    @IBOutlet weak var btnEmails: UILabel!
    
    @IBOutlet weak var logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsVC = self
        
        checkLogin()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        lblVersion.text = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        lblRights.text = String(format: "Copyrights 2000-%@ Palmtree", formatter.string(from: Date()))
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            lblRights.text = String(format: "Palmtree 2000-%@ حقوق النشر", formatter.string(from: Date()))
            lblRights.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLang.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLang1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            logo.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            btnSignin.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnShareApp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnHelp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnLang.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPolicy.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnTerms.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnLegal.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            btnSignout.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnShareApp1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnHelp1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnLang1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPolicy1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnTerms1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnLegal1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnDetails.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnAlert.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnMessage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnUpdate.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnEmails.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        else
        {
//            lblRights.text = String(format: "Copyrights 2000-%@ Palmtree", formatter.string(from: Date()))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if defaults.bool(forKey: "isLogin")
        {
            scrollView.contentSize = CGSize(width: 0, height: 780)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkLogin()
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            signinView.alpha = 1
            signoutView.alpha = 0
        }
        else
        {
            signinView.alpha = 0
            signoutView.alpha = 1
            
            if languageCode == "ar"
            {
                btnSignout.text = "(" + (userDetail?.userEmail ?? "") + ") تسجيل الخروج"
            }
            else
            {
                btnSignout.text = "Sign Out (" + (userDetail?.userEmail ?? "") + ")"
            }
        }
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
        let alert = UIAlertController(title: "Palmtree", message: "Are you sure you want to signout?", preferredStyle: .alert)
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
            let aboutusVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutusVC") as! AboutusVC
            self.navigationController?.pushViewController(aboutusVC, animated: true)
        }
    }
    
    @IBAction func myDetailsBtnAction(_ sender: Any)
    {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
