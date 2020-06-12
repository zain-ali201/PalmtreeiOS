//
//  CategoryDetailController.swift
//  PalmTree
//
//  Created by SprintSols on 9/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CategoryDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UISearchResultsUpdating, UISearchBarDelegate {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "CategoryDetailCell", bundle: nil), forCellReuseIdentifier: "CategoryDetailCell")
        }
    }
    
    //MARK:- Properties
    var dataArray = [LocationDetailTerm]()
    var currentPage = 0
    var maximumPage = 0
    var searchController = UISearchController(searchResultsController: nil)
    var filteredArray = [LocationDetailTerm]()
    var shouldShowSearchResults = false
    var termId = 0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.configureSearchController()
       // self.setupSearchBar()
        let param: [String: Any] = ["term_name":"ad_cats", "term_id": "", "page_number":1]
        print(param)
        self.locationDetails(parameter: param as NSDictionary)
    }

    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = ""
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       searchBar.setValue("Done", forKey: "_cancelButtonText")
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filteredArray = dataArray.filter({ (name) -> Bool in
            let nameText: NSString = name.name as NSString
            let range = nameText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredArray.count == 0 {
            shouldShowSearchResults = false
        } else {
            shouldShowSearchResults = true
        }
        self.tableView.reloadData()
    }
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        } else {
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryDetailCell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell", for: indexPath) as! CategoryDetailCell
         cell.accessoryType = .disclosureIndicator
        
        if shouldShowSearchResults {
            if let name = filteredArray[indexPath.row].name {
                cell.lblName.text = name
            }
        } else {
            if let name = dataArray[indexPath.row].name {
                cell.lblName.text = name
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowSearchResults {
            let objData = filteredArray[indexPath.row]
            if objData.hasChildren {
                let param: [String: Any] = ["term_name":"ad_cats", "term_id": objData.termId, "page_number":1]
                self.locationDetails(parameter: param as NSDictionary)
            } else {
                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                categoryVC.categoryID = objData.termId
                self.navigationController?.pushViewController(categoryVC, animated: true)
            }
        } else {
            let objData = dataArray[indexPath.row]
            if objData.hasChildren {
                let param: [String: Any] = ["term_name":"ad_cats", "term_id": objData.termId, "page_number":1]
                self.locationDetails(parameter: param as NSDictionary)
            } else {
                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                categoryVC.categoryID = objData.termId
                self.navigationController?.pushViewController(categoryVC, animated: true)
            }
        }
        
        termId = dataArray[indexPath.row].termId
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["term_name":"ad_cats", "term_id": termId, "page_number": currentPage]
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
    
    //LoadMore Data
    func loadMoreData(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.locationDetails(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.terms)
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
}
