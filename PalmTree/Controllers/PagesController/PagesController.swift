//
//  PagesController.swift
//  PalmTree
//
//  Created by SprintSols on 6/1/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import WebKit
import NVActivityIndicatorView
import WebKit
import IQKeyboardManagerSwift

class PagesController: UIViewController, NVActivityIndicatorViewable, UIWebViewDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,WKUIDelegate,WKNavigationDelegate {

    //MARK:- Outlets
    @IBOutlet weak var webView: UIWebView!{
        didSet {

            webView.delegate =  self
            webView.isOpaque = false
            webView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var wkWebView: WKWebView!
    
    //MARK:- Properties
    var delegate :leftMenuProtocol?
    var page_id = 0
    var type = ""
    var pageUrl = ""
    
    
    
    let defaults = UserDefaults.standard
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
    
    
    //MARK:- View Life Cycle
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        //        wkWebView == WKWebView(frame: .zero, configuration: webConfiguration)
        //        wkWebView.backgroundColor = UIColor.clear
        //        wkWebView.isOpaque = false
        //        wkWebView.navigationDelegate = self
        //        wkWebView.uiDelegate = self
        ////        view = wkWebView
        //        self.view.addSubview(wkWebView)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pages"
        self.addBackButtonToNavigationBar()
        self.googleAnalytics(controllerName: "Pages Controller")
        if type == "simple" {
            let param:[String: Any] = ["page_id": page_id]
            print(param)
            self.adForest_pagesData(param: param as NSDictionary)
        } else if type == "simple" || type != "simple" {
           // guard let userEmail = UserDefaults.standard.string(forKey: "email") else {return}
            //guard let userPassword = UserDefaults.standard.string(forKey: "password") else {return}

            let userEmail = UserDefaults.standard.string(forKey: "email")
            let userPassword = UserDefaults.standard.string(forKey: "password")
            
            let emailPass = "\(userEmail):\(userPassword)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            print(base64String)
            let url = URL(string: pageUrl)
            var request = URLRequest(url: url!)
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
            if UserDefaults.standard.bool(forKey: "isSocial") {
                request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
            }
            self.wkWebView.load(request)
        }
        
        navigationButtons()
    }
    
    //MARK:- Custom
   
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func addBackButtonToNavigationBar() {
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backbutton"), style: .done, target: self, action: #selector(moveToParentController))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func moveToParentController() {
        self.delegate?.changeViewController(.main)
    }
    
    //MARK:- API Call
    func adForest_pagesData(param: NSDictionary) {
        self.showLoader()
        UserHandler.termsConditions(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
               
                
                if let htmlString = successResponse.data.pageContent {
                     self.title = successResponse.data.pageTitle
                    self.wkWebView.loadHTMLString(htmlString, baseURL: nil)
                    
                }
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
    //MARK:- Near by search Delaget method
              func nearbySearchParams(lat: Double, long: Double, searchDistance: CGFloat, isSearch: Bool) {
                  self.latitude = lat
                  self.longitude = long
                  self.searchDistance = searchDistance
                  if isSearch {
                      let param: [String: Any] = ["nearby_latitude": lat, "nearby_longitude": long, "nearby_distance": searchDistance]
                      print(param)
                      self.adForest_nearBySearch(param: param as NSDictionary)
                  } else {
                      let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
                      print(param)
                      self.adForest_nearBySearch(param: param as NSDictionary)
                  }
              }
              
              
              func navigationButtons() {
                  
                  //Home Button
                  let HomeButton = UIButton(type: .custom)
                  let ho = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
                  HomeButton.setBackgroundImage(ho, for: .normal)
                  HomeButton.tintColor = UIColor.white
                  HomeButton.setImage(ho, for: .normal)
                  if #available(iOS 11, *) {
                      searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
                      searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
                  } else {
                      HomeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                  }
                  HomeButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
                  let homeItem = UIBarButtonItem(customView: HomeButton)
                  if defaults.bool(forKey: "showHome") {
                      barButtonItems.append(homeItem)
                      //self.barButtonItems.append(homeItem)
                  }
                  
                  //Location Search
                  let locationButton = UIButton(type: .custom)
                  if #available(iOS 11, *) {
                      locationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
                      locationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                  }
                  else {
                      locationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                  }
                  let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
                  locationButton.setBackgroundImage(image, for: .normal)
                  locationButton.tintColor = UIColor.white
                  locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
                  let barButtonLocation = UIBarButtonItem(customView: locationButton)
                  if defaults.bool(forKey: "showNearBy") {
                      self.barButtonItems.append(barButtonLocation)
                  }
                  //Search Button
                let searchButton = UIButton(type: .custom)
                if defaults.bool(forKey: "advanceSearch") == true{
                    let con = UIImage(named: "controls")?.withRenderingMode(.alwaysTemplate)
                    searchButton.setBackgroundImage(con, for: .normal)
                    searchButton.tintColor = UIColor.white
                    searchButton.setImage(con, for: .normal)
                }else{
                    let con = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
                    searchButton.setBackgroundImage(con, for: .normal)
                    searchButton.tintColor = UIColor.white
                    searchButton.setImage(con, for: .normal)
                }
                  if #available(iOS 11, *) {
                      searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
                      searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
                  } else {
                      searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                  }
                  searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
                  let searchItem = UIBarButtonItem(customView: searchButton)
                  if defaults.bool(forKey: "showSearch") {
                      barButtonItems.append(searchItem)
                      //self.barButtonItems.append(searchItem)
                  }
                  
                  self.navigationItem.rightBarButtonItems = barButtonItems
                  
              }
              
              @objc func actionHome() {
                  appDelegate.moveToHome()
              }
              
              @objc func onClicklocationButton() {
                  let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearch
                  locationVC.delegate = self
                  view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
                  UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                      self.view.transform = .identity
                  }) { (success) in
                      self.navigationController?.pushViewController(locationVC, animated: true)
                  }
              }
              
              
              //MARK:- Search Controller
              
              @objc func actionSearch(_ sender: Any) {
                  
                  if defaults.bool(forKey: "advanceSearch") == true{
                      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                      let proVc = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchController") as! AdvancedSearchController
                      self.pushVC(proVc, completion: nil)
                  }else{
                      
                      //setupNavigationBar(title: "okk...")
                      
                      keyboardManager.enable = true
                      if isNavSearchBarShowing {
                          navigationItem.titleView = nil
                          self.searchBarNavigation.text = ""
                          self.backgroundView.removeFromSuperview()
                          self.addTitleView()
                          
                      } else {
                          self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                          self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                          self.backgroundView.isOpaque = true
                          let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                          tap.delegate = self
                          self.backgroundView.addGestureRecognizer(tap)
                          self.backgroundView.isUserInteractionEnabled = true
                          self.view.addSubview(self.backgroundView)
                          self.adNavSearchBar()
                      }
                  }
                  
              }
              
              @objc func handleTap(_ gestureRocognizer: UITapGestureRecognizer) {
                  self.actionSearch("")
              }
              
              func adNavSearchBar() {
                  searchBarNavigation.placeholder = "Search Ads"
                  searchBarNavigation.barStyle = .default
                  searchBarNavigation.isTranslucent = false
                  searchBarNavigation.barTintColor = UIColor.groupTableViewBackground
                  searchBarNavigation.backgroundImage = UIImage()
                  searchBarNavigation.sizeToFit()
                  searchBarNavigation.delegate = self
                  self.isNavSearchBarShowing = true
                  searchBarNavigation.isHidden = false
                  navigationItem.titleView = searchBarNavigation
                  searchBarNavigation.becomeFirstResponder()
              }
              
              func addTitleView() {
                  self.searchBarNavigation.endEditing(true)
                  self.isNavSearchBarShowing = false
                  self.searchBarNavigation.isHidden = true
                  self.view.isUserInteractionEnabled = true
              }
              
              //MARK:- Search Bar Delegates
              func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
                  
              }
              
              func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
                  //self.searchBarNavigation.endEditing(true)
                  searchBar.endEditing(true)
                  self.view.endEditing(true)
              }
              
              func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                  searchBar.endEditing(true)
                  self.searchBarNavigation.endEditing(true)
                  guard let searchText = searchBar.text else {return}
                  if searchText == "" {
                      
                  } else {
                      let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                      categoryVC.searchText = searchText
                      categoryVC.isFromTextSearch = true
                      self.navigationController?.pushViewController(categoryVC, animated: true)
                  }
              }
              
              
              
              //MARK:- Near By Search
              func adForest_nearBySearch(param: NSDictionary) {
                  self.showLoader()
                  AddsHandler.nearbyAddsSearch(params: param, success: { (successResponse) in
                      self.stopAnimating()
                      if successResponse.success {
                          let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                          categoryVC.latitude = self.latitude
                          categoryVC.longitude = self.longitude
                          categoryVC.nearByDistance = self.searchDistance
                          categoryVC.isFromNearBySearch = true
                          self.navigationController?.pushViewController(categoryVC, animated: true)
                      } else {
                          let alert = Constants.showBasicAlert(message: successResponse.message)
                          self.presentVC(alert)
                      }
                  }) { (error) in
                      self.stopAnimating()
                      let alert = Constants.showBasicAlert(message: error.message)
                      self.presentVC(alert)
                  }
              }
      
    
}
