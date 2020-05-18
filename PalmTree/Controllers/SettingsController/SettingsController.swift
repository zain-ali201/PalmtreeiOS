//
//  SettingsController.swift
//  PalmTree
//
//  Created by SprintSols on 9/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import StoreKit
import IQKeyboardManagerSwift

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable,NearBySearchDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLineEtched
            tableView.register(UINib(nibName: AboutAppCell.className, bundle: nil), forCellReuseIdentifier: AboutAppCell.className)
            tableView.register(UINib(nibName: AppShareCell.className, bundle: nil), forCellReuseIdentifier: AppShareCell.className)
            tableView.register(UINib(nibName: CategoryDetailCell.className, bundle: nil), forCellReuseIdentifier: CategoryDetailCell.className)
        }
    }
    
    //MARK:- Properties
    
    let defaults = UserDefaults.standard
    var delegate :leftMenuProtocol?
    var objData : AppSettingData?
    
    var isShowAboutApp = false
    var isShowAppVersion = false
    var isShowAppRating = false
    var isShowAppShare = false
    var isShowFeedback = false
    var isShowFaq = false
    var isShowTerms = false
    var isShowPrivacyPolicy = false
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.adForest_getAppData()
        navigationButtons()
    }

    //MARK:- Custom
    
  
    func addBackButtonToNavigationBar() {
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backbutton"), style: .done, target: self, action: #selector(moveToParentController))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func moveToParentController() {
        self.delegate?.changeViewController(.main)
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func appStorerating(appStoreID: String) {
        let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id\(appStoreID)?mt=8&action=write-review")!
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                print("Open \(url): \(success)")
            }
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0 :
            if isShowAboutApp {
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppCell.className, for: indexPath) as! AboutAppCell
                if let title = objData?.about.title {
                    cell.lblAbout.text = title
                }
                if let desc = objData?.about.desc {
                    cell.lblDetail.text = desc
                }
                return cell
            }
        case 1:
            if isShowAppVersion {
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppCell.className, for: indexPath) as! AboutAppCell
                
                if let title = objData?.appVersion.title {
                    cell.lblAbout.text = title
                }
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    cell.lblDetail.text = version
                }
                return cell
            }
        case 2:
            if isShowAppRating {
                let cell = tableView.dequeueReusableCell(withIdentifier: AppShareCell.className, for: indexPath) as! AppShareCell
                if let rating = objData?.appRating.title {
                    cell.lblName.text = rating
                }
                cell.imgPicture.image = UIImage(named: "star")
                return cell
            }
        case 3:
            if isShowAppShare {
                let cell = tableView.dequeueReusableCell(withIdentifier: AppShareCell.className, for: indexPath) as! AppShareCell
                if let share = objData?.appShare.title {
                    cell.lblName.text = share
                }
                cell.imgPicture.image = UIImage(named: "shareIcon")
                return cell
            }
        case 4:
            if isShowFeedback {
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppCell.className, for: indexPath) as! AboutAppCell
                if let faqs = objData?.feedback.title {
                    cell.lblAbout.text = faqs
                }
                if let detail = objData?.feedback.subline {
                    cell.lblDetail.text = detail
                }
                return cell
            }
        case 5:
            if isShowFaq {
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailCell.className, for: indexPath) as! CategoryDetailCell
                if let faqs = objData?.faqs.title {
                    cell.lblName.text = faqs
                }
                return cell
            }
        case 6:
            if isShowTerms {
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailCell.className, for: indexPath) as! CategoryDetailCell
                if let termsConditions = objData?.tandc.title {
                    cell.lblName.text = termsConditions
                }
                return cell
            }
        case 7:
            if isShowPrivacyPolicy {
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryDetailCell.className, for: indexPath) as! CategoryDetailCell
                if let privacyPolicy = objData?.privacyPolicy.title {
                    cell.lblName.text = privacyPolicy
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 2:
            guard let appID = objData?.appRating.url else {return}
            self.appStorerating(appStoreID: appID)
        case 3:
            guard let shareText = objData?.appShare.text else {return}
            guard let shareUrl = objData?.appShare.url else {return}
            
            let shareVC = UIActivityViewController(activityItems: [shareText, shareUrl], applicationActivities: nil)
            shareVC.popoverPresentationController?.sourceView = self.view
            self.presentVC(shareVC)
        case 4:
           let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: FeedbackController.className) as! FeedbackController
           feedbackVC.formData = objData?.feedback.form
           feedbackVC.modalPresentationStyle = .overCurrentContext
           if let feedbackTitle = objData?.feedback.title {
            feedbackVC.feedbackTitle = feedbackTitle
           }
           view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = .identity
           }) { (success) in
              self.presentVC(feedbackVC)
           }
        case 5:
            if let url = URL(string: (objData?.faqs.url)!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 6:
            if let url = URL(string: (objData?.tandc.url)!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 7:
            if let url = URL(string: (objData?.privacyPolicy.url)!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch  section {
        case 0:
            if isShowAboutApp {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        case 1:
            if isShowAppVersion {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        case 2:
            if isShowAppRating {
                return 50
            } else {
                return 0
            }
        case 3:
            if isShowAppShare {
                return 50
            } else {
                return 0
            }
        case 4:
            if isShowFeedback {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        case 5:
            if isShowFaq {
                return 45
            } else {
                return 0
            }
        case 6:
            if isShowTerms {
                return 45
            } else {
                return 0
            }
        case 7:
            if isShowPrivacyPolicy {
                return 45
            } else {
                return 0
            }
        default:
            return 0
        }
    }
  
    
    //MARK:- API Calls
    func adForest_getAppData() {
        self.showLoader()
        UserHandler.appSettings(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
//                self.title = successResponse.data.pageTitle
                self.isShowAboutApp = successResponse.data.about.isShow
                self.isShowAppVersion = successResponse.data.appVersion.isShow
                self.isShowAppRating = successResponse.data.appRating.isShow
                self.isShowAppShare = successResponse.data.appShare.isShow
                self.isShowFeedback = successResponse.data.feedback.isShow
                self.isShowFaq = successResponse.data.faqs.isShow
                self.isShowTerms = successResponse.data.tandc.isShow
                self.isShowPrivacyPolicy = successResponse.data.privacyPolicy.isShow
                self.objData = successResponse.data
                self.tableView.reloadData()
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
