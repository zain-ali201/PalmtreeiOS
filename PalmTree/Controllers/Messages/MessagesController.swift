//
//  MessagesController.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import Firebase
import FirebaseDatabase

class MessagesController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var postBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
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
    let dataArray = NSMutableArray()
    let dictArray = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        
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
            lblText1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            postBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.showLoader()
        let ref = Database.database().reference()
        ref.child("Chats").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:  { (snapshot) in
            self.stopAnimating()
            if snapshot.exists()
            {
                if let fruitPost = snapshot.value as? Dictionary<String,AnyObject>
                {
                    for(key, value) in fruitPost {
                        if(Auth.auth().currentUser!.uid != key){
                            print("value: \(value)")
                            print("value.lastObject: \(value.lastObject)")
                            let dict = NSMutableDictionary()
                            dict.setObject(key, forKey:"firebaseId" as NSCopying)
//                            dict.setObject(value.lastObject as String, forKey:"message" as NSCopying)
                            self.dataArray.add(dict)
                        }
                    }
                }
                
                if self.dataArray.count == 0
                {
                    self.emptyView.alpha = 1
                }
                else
                {
                    self.emptyView.alpha = 0
                }
                print(self.dataArray)
                self.tableView.reloadData()
            }
            else
            {
                self.emptyView.alpha = 1
            }
        })
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
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        let dict = dataArray.object(at: indexPath.row) as! NSDictionary
        
        let firebaseId = dict.object(forKey: "firebaseId")
        
        Database.database().reference()
            .child("users")
            .child(firebaseId as! String)
            .child("username")
            .queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in
                
                if let dict1 = snapshot.value as? NSMutableDictionary
                {
                    print(dict1)
                    dict1.setObject(firebaseId!, forKey: "firebaseId" as NSCopying)
                    
                    let firstName = dict1["Firstname"] as? String
                    self.dictArray.add(dict1)
                    
                    cell.lblName.text = firstName!
                }
            })
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            cell.lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            cell.btnLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.dict = dictArray.object(at: indexPath.row) as! NSDictionary
        print(vc.dict)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this chat?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
                let dict1 = self.dataArray.object(at: indexPath.row) as! NSDictionary
                
                let userRef = Database.database().reference().child("Chats")
                    .child(Auth.auth().currentUser!.uid).child(dict1.object(forKey: "firebaseId") as! String)
                userRef.removeValue()
                self.dataArray.removeObject(at: indexPath.row)
                
                self.tableView.reloadData()
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
