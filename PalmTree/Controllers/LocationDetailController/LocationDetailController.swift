//
//  LocationDetailController.swift
//  PalmTree
//
//  Created by SprintSols on 9/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class LocationDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable, UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = ""
            searchBar.delegate = self
            searchBar.sizeToFit()
        }
    }
    
    //MARK:- Properties
    var dataArray = [LocationDetailTerm]()
    var currentPage = 0
    var maximumPage = 0
    
    var filteredArray = [LocationDetailTerm]()
    var shouldShowSearchResults = false
    
    
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var defaults = UserDefaults.standard
    var barButtonItems = [UIBarButtonItem]()
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        let param: [String: Any] = ["term_name":"ad_country", "term_id": "", "page_number":1]
        print(param)
        self.locationDetails(parameter: param as NSDictionary)
        navigationButtons()
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
   
    //MARK:- Collection View Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        } else {
            return dataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LocationDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationDetailCell", for: indexPath) as! LocationDetailCell
        
        if shouldShowSearchResults {
            let objData = filteredArray[indexPath.row]
            if let imgUrl = URL(string: objData.termImg) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.name {
                cell.lblName.text = name
            }
            if let count = objData.count {
                cell.lblAds.text = String(count)
            }
        } else {
            let objData = dataArray[indexPath.row]
            if let imgUrl = URL(string: objData.termImg) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.name {
                cell.lblName.text = name
            }
            if let count = objData.count {
                cell.lblAds.text = String(count)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objData = dataArray[indexPath.row]
        if objData.hasChildren {
            let param: [String: Any] = ["term_name":"ad_country", "term_id": objData.termId, "page_number":1]
            print(param)
            self.locationDetails(parameter: param as NSDictionary)
        } else {
            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
            categoryVC.categoryID = objData.termId
            categoryVC.isFromLocation = true
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if Constants.isiPadDevice {
            let width = collectionView.bounds.width/3.0
            return CGSize(width: width, height: 140)
        }
        let width = collectionView.bounds.width/2.0
        return CGSize(width: width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["term_name":"ad_country", "term_id": "", "page_number": currentPage]
            print(param)
            self.loadMoreData(parameter: param as NSDictionary)
        }
    }
    
    //MARK:- API Calls
    
    func locationDetails(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.locationDetails(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.terms
                self.collectionView.reloadData()
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
    
    //LoadMore Data
    func loadMoreData(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.locationDetails(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.terms)
                self.collectionView.reloadData()
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
              self.nearBySearch(param: param as NSDictionary)
          } else {
              let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
              print(param)
              self.nearBySearch(param: param as NSDictionary)
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
       func nearBySearch(param: NSDictionary) {
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
