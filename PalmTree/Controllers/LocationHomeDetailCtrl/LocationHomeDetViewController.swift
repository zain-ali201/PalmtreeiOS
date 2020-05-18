//
//  LocationHomeDetViewController.swift
//  PalmTree
//
//  Created by SprintSols on 10/14/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol refreshdata {
    func tableRef(name:String)
}


class LocationHomeDetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, /*UISearchResultsUpdating, UISearchBarDelegate,*/UITextFieldDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var viewBlur: UIView!
    
    @IBOutlet weak var txtFieldSearch: UITextField!
    
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
    
    //var dataArray = [LocationDetailTerm]()
    //var dataArray = AddsHandler.sharedInstance.topLocationArray
    var currentPage = 0
    var maximumPage = 0
    var searchController = UISearchController(searchResultsController: nil)
    var filteredArray = [CatLocation]()//AddsHandler.sharedInstance.topLocationArray
    var shouldShowSearchResults = false
    var termId = 0
    var dataArray = [CatLocation]()
    var delegate : refreshdata?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.showBackButton()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewBlur.addSubview(blurEffectView)
        
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        
        if dataArray.count == 0{
            tableView.setEmptyMessage("No Data")
        }else{
             tableView.setEmptyMessage("")
        }
        
    }

    //MARK:- IBAction
    
    @IBAction func btnDisMissClicked(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
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
            if let id = filteredArray[indexPath.row].catId {
                cell.tag = id
            }
        } else {
            if let name = dataArray[indexPath.row].name {
                cell.lblName.text = name
            }
            
            if let id = dataArray[indexPath.row].catId {
                cell.tag = id
            }
//            if let count = dataArray[indexPath.row].count{
//                cell.lblName.text = count
//            }
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPat = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPat!) as! CategoryDetailCell
        print(currentCell.tag)
        UserDefaults.standard.set(currentCell.tag, forKey: "locId")
        currentCell.backgroundColor = UIColor.gray
        if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
            currentCell.backgroundColor = UIColor(hex: mainColor)
        }
        delegate?.tableRef(name: currentCell.lblName.text!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismissVC(completion: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 66))
        let txtField = UITextField(frame: CGRect(x: 10, y: 15, width: self.tableView.frame.width - 20 , height: 30))
        
        headerView.backgroundColor = UIColor.white
        txtField.placeholder = "Search Location.."
        txtField.delegate = self
        txtField.textAlignment = .left
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        txtField.layer.cornerRadius = 10
        txtField.addTarget(self, action: #selector(LocationHomeDetViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        let imageView = UIImageView()
        let image = UIImage(named: "search")
        imageView.image = image
        txtField.leftViewMode = UITextFieldViewMode.always
        txtField.leftViewMode = .always
        txtField.leftView = imageView
        txtField.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height:25)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.lightGray
        
        headerView.addSubview(txtField)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
     
        print("Change Selection \(textField.text!)")
        let searchString = textField.text
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
 
    //MARK:- API Calls
    func adForest_locationDetails(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.locationDetails(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
               // self.dataArray = successResponse.data.terms
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
    func adForest_loadMoreData(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.locationDetails(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //self.dataArray.append(contentsOf: successResponse.data.terms)
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
