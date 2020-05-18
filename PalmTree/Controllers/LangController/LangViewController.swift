//
//  LangViewController.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 13/06/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SDWebImage
import IQKeyboardManagerSwift

class LangViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NearBySearchDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate {
   
    

    //MARK:- IBOutlets
    
    @IBOutlet weak var lblPick: UILabel!
    @IBOutlet weak var lblLang: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Proporties
    
    var delegate :leftMenuProtocol?
    let defaults = UserDefaults.standard
    var imagesAr = [LangData]()
    var langArr =  [LangData]()
    
    var isAppOpen = false
    var settingBlogArr = [String]()
    var isBlogImg:Bool = false
    var isSettingImg:Bool = false
    var imagesArr = [UIImage]()
    var languageStyle = "2"
    //NAV  HEADER ITEMS
    var barButtonItems = [UIBarButtonItem]()
    let keyboardManager = IQKeyboardManager.sharedManager()
    let searchBarNavigation = UISearchBar()
    var isNavSearchBarShowing = false
    var nearByTitle = ""
     var latitude: Double = 0
     var longitude: Double = 0
     var searchDistance:CGFloat = 0
    var backgroundView = UIView()

    //-->> View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        settingsdata()

        if langArr.count == 0{
                   collectionView.setEmptyMessage("No Data")
               }else{
                    collectionView.setEmptyMessage("")
               }
               print(langArr)
               navigationButtons()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let lang = UserDefaults.standard.string(forKey: "langHeading")
        let isLang = UserDefaults.standard.string(forKey: "langFirst")
        if isLang == "0"{
            self.navigationController?.isNavigationBarHidden = true
            
        }else{
            self.navigationController?.isNavigationBarHidden = false
            self.title = lang
            self.addLeftBarButtonWithImage()
            //addBackButtonToNavigationBar()
        }
         UserDefaults.standard.setValue("1", forKey: "langFirst")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // self.navigationController?.isNavigationBarHidden = false
        
        let isLang = UserDefaults.standard.string(forKey: "langFirst")
        if isLang != "1"{
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    
    //-->> Custome Functions
    
    func addBackButtonToNavigationBar() {
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backbutton"), style: .done, target: self, action: #selector(moveToParentController))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func moveToParentController() {
        self.delegate?.changeViewController(.main)
        self.navigationController?.popViewController(animated: true)
        self.dismissVC(completion: nil)
    }
    
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesAr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LangCollectionViewCell", for: indexPath) as! LangCollectionViewCell
        let url = imagesAr[indexPath.row].flag_url
        cell.imgCountry.sd_setShowActivityIndicatorView(true)
        cell.imgCountry.sd_setIndicatorStyle(.gray)
        cell.imgCountry.sd_setImage(with:URL(string: url!) , completed: nil)
        cell.lblLanguage.text = langArr[indexPath.row].native_name
        cell.btnCode.setTitle(langArr[indexPath.row].code, for: .normal)
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? LangCollectionViewCell {
            print("\(String(describing: cell.btnCode.titleLabel?.text))")
            UserDefaults.standard.set(cell.btnCode.titleLabel?.text, forKey: "langCode")
            UserDefaults.standard.setValue("1", forKey: "langFirst")
            
        }
        self.perform(#selector(self.showHome), with: nil, afterDelay: 2)
    }
    
    @objc func showHome(){
         //appDelegate.moveToLanguageCtrl()
        let ctrl = storyboard?.instantiateViewController(withIdentifier: "Splash")
        self.navigationController?.pushViewController(ctrl!, animated: true)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  0
        let collectionViewSize = collectionView.frame.size.width - padding
        if Constants.isiPadDevice{
            if languageStyle == "1"{
                 return CGSize(width: collectionViewSize, height:65)
            }else{
                 return CGSize(width: collectionViewSize, height:65)
            }
        }
        else{
            if languageStyle == "1"{
                return CGSize(width: collectionViewSize, height:65)
            }else{
                return CGSize(width: collectionViewSize, height:65)
            }
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

        UIView.animate(withDuration: 0.4,
                       animations: {
                        if let cell = collectionView.cellForItem(at: indexPath) as? LangCollectionViewCell {
                            cell.viewBg.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                                cell.viewBg.backgroundColor = UIColor(hex: mainColor)
                            }

                        }
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.4) {
                            if let cell = collectionView.cellForItem(at: indexPath) as? LangCollectionViewCell {
                                cell.viewBg.transform = CGAffineTransform.identity
                                cell.viewBg.backgroundColor = UIColor.white
                            }

                        }
        })
    }
    
    //-->> Api Calls
    
    func settingsdata() {
       // self.showLoader()
        UserHandler.settingsdata(success: { (successResponse) in
           // self.stopAnimating()
            if successResponse.success {
                self.defaults.set(successResponse.data.mainColor, forKey: "mainColor")
                self.appDelegate.customizeNavigationBar(barTintColor: Constants.hexStringToUIColor(hex: successResponse.data.mainColor))
                self.defaults.set(successResponse.data.isRtl, forKey: "isRtl")
                self.defaults.set(successResponse.data.notLoginMsg, forKey: "notLogin")
                self.defaults.set(successResponse.data.isAppOpen, forKey: "isAppOpen")
                self.defaults.set(successResponse.data.showNearby, forKey: "showNearBy")
                self.defaults.set(successResponse.data.appPageTestUrl, forKey: "shopUrl")
                //Save Shop title to show in Shop Navigation Title
                self.defaults.set(successResponse.data.menu.shop, forKey: "shopTitle")
                self.isAppOpen = successResponse.data.isAppOpen
                //Offers title
                self.defaults.set(successResponse.data.messagesScreen.mainTitle, forKey: "message")
                self.defaults.set(successResponse.data.messagesScreen.sent, forKey: "sentOffers")
                self.defaults.set(successResponse.data.messagesScreen.receive, forKey: "receiveOffers")
                self.defaults.synchronize()
                UserHandler.sharedInstance.objSettings = successResponse.data
                UserHandler.sharedInstance.objSettingsMenu = successResponse.data.menu.submenu.pages
                UserHandler.sharedInstance.menuKeysArray = successResponse.data.menu.dynamicMenu.keys
                UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                if successResponse.data.menu.isShowMenu.blog == true{
                    self.settingBlogArr.append(successResponse.data.menu.blog)
                    UserDefaults.standard.set(true, forKey: "isBlog")
                    self.imagesArr.append(UIImage(named: "blog")!)
                }
                if successResponse.data.menu.isShowMenu.settings == true{
                    UserDefaults.standard.set(true, forKey: "isSet")
                    self.imagesArr.append(UIImage(named: "settings")!)
                    self.settingBlogArr.append(successResponse.data.menu.appSettings)
                }
                
                UserDefaults.standard.set(self.settingBlogArr, forKey: "setArr")
                UserDefaults.standard.set(self.imagesArr, forKey: "setArrImg")
                print(self.imagesArr)
            
                self.imagesAr = successResponse.data.langData
                self.langArr = successResponse.data.langData
                self.lblPick.text = successResponse.data.wpml_header_title_1
                self.lblLang.text = successResponse.data.wpml_header_title_2
                self.imgLogo.sd_setImage(with: URL(string: successResponse.data.wpml_logo), completed: nil)
               // self.languageStyle = successResponse.data.language_style
//                self.title = successResponse.data.wpml_menu_text
               
                self.collectionView.reloadData()
            
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
           // self.stopAnimating()
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
                tap.delegate = self as? UIGestureRecognizerDelegate
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
        searchBarNavigation.delegate = self as! UISearchBarDelegate
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
//        self.showLoader()
        AddsHandler.nearbyAddsSearch(params: param, success: { (successResponse) in
//            self.stopAnimating()
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
//            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
