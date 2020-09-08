//
//  MessagesController.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SlideMenuControllerSwift
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class MessagesController: ButtonBarPagerTabStripViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    //MenuButtons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPalmtree: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    //MARK:- Properties
    var isFromAdDetail = false
    var barButtonItems = [UIBarButtonItem]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        self.customizePagerTabStrip()
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: topView)
        self.view.bringSubview(toFront: bottomView)
        
        self.googleAnalytics(controllerName: "Messages Controller")
       
        if isFromAdDetail
        {
            btnBack.alpha = 1
        } else
        {
            btnBack.alpha = 0
        }
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            changeMenuButtons()
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.bringSubview(toFront: topView)
        self.view.bringSubview(toFront: bottomView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func customizePagerTabStrip()
    {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0.0
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {return}
            oldCell?.label.textColor = UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1)
            newCell?.label.textColor = UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1)
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let sentOffers = SB.instantiateViewController(withIdentifier: "SentOffersController") as! SentOffersController
        sentOffers.sentOffersData()
        sentOffers.showLoader()
        let addsOffer = SB.instantiateViewController(withIdentifier: "OffersOnAdsController") as! OffersOnAdsController
//        let blockedController = SB.instantiateViewController(withIdentifier: "BlockedUserChatViewController") as! BlockedUserChatViewController
        
        
        let childVC = [sentOffers, addsOffer]
        return childVC
    }
    
    func changeMenuButtons()
    {
        btnHome.setImage(UIImage(named: "home_" + languageCode ), for: .normal)
        btnPalmtree.setImage(UIImage(named: "mypalmtree_" + languageCode), for: .normal)
        btnPost.setImage(UIImage(named: "post_" + languageCode), for: .normal)
        btnWishlist.setImage(UIImage(named: "wishlist_active_" + languageCode), for: .normal)
        btnMessages.setImage(UIImage(named: "messages_" + languageCode ), for: .normal)
        
        btnHome.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPalmtree.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnWishlist.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnMessages.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    @IBAction func backBtnAction(_ button: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            self.navigationController?.popToViewController(homeVC, animated: false)
        }
        else if button.tag == 1002
        {
            let myAdsVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAdsController") as! MyAdsController
            self.navigationController?.pushViewController(myAdsVC, animated: false)
        }
        else if button.tag == 1003
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                if defaults.bool(forKey: "isLogin") == false
                {
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let navController = UINavigationController(rootViewController: loginVC)
                    self.present(navController, animated:true, completion: nil)
                }
                else
                {
                    adDetailObj = AdDetailObject()
                    let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostVC") as! AdPostVC
                    let navController = UINavigationController(rootViewController: adPostVC)
                    navController.navigationBar.isHidden = true
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated:true, completion: nil)
                }
            }
        }
        else if button.tag == 1004
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                let favouritesVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
                self.navigationController?.pushViewController(favouritesVC, animated: false)
            }
        }
    }
}
