//
//  SearchCategoryDetail.swift
//  PalmTree
//
//  Created by SprintSols on 5/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

protocol SubCategoryDelegate {
    func subCategoryDetails(name: String, id: Int, hasSubType: Bool, hasTempelate: Bool, hasCatTempelate: Bool)
}

class SearchCategoryDetail: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable,NearBySearchDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var oltSubmit: UIButton! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltSubmit.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
                let DialoSubmit = UserDefaults.standard.string(forKey: "dialogSend")
                oltSubmit.setTitle(DialoSubmit, for: .normal)

            }
        }
    }
    @IBOutlet weak var oltCancel: UIButton! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltCancel.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
                let DialoCancel = UserDefaults.standard.string(forKey: "dialgCancel")
                oltCancel.setTitle(DialoCancel, for: .normal)
        }
    }
}
   // @IBOutlet weak var cstTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewTopLabel: UIView!{
        didSet{
            viewTopLabel.layer.borderWidth = 0.3
            viewTopLabel.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    //MARK:- Properties
    var delegate: SubCategoryDelegate?
    var dataArray = [SubCategoryValue]()
    
    var hasCatTemp = false
    
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
    
    
    //MARK:- view Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adForest_populateData()
        self.googleAnalytics(controllerName: "Search Category Detail")
        navigationButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_populateData() {
        if AddsHandler.sharedInstance.objSearchCategory != nil {
            let data = AddsHandler.sharedInstance.objSearchCategory
            if let title = data?.title {
                self.lblName.text = title
            }
            if let hasCatTempelate = data?.hasCatTemplate{
                self.hasCatTemp = hasCatTempelate
            }
        }
    }
    
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCategoryDetailCell = tableView.dequeueReusableCell(withIdentifier: "SearchCategoryDetailCell", for: indexPath) as! SearchCategoryDetailCell
        let objdata = dataArray[indexPath.row]
        
        if let name = objdata.name {
            cell.lblName.text = name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = dataArray[indexPath.row]
    
        self.dismissVC {
            self.delegate?.subCategoryDetails(name: objData.name, id: objData.id, hasSubType: objData.hasSub, hasTempelate: objData.hasTemplate, hasCatTempelate: self.hasCatTemp)
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func actionSubmit(_ sender: Any) {
        
        self.dismissVC(completion: nil)
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismissVC(completion: nil)
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

//MARK:- Cell Class
class SearchCategoryDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}




