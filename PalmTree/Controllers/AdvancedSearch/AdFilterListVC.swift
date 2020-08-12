//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AdFilterListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NVActivityIndicatorViewable{

    //MARK:- Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    //MARK:- Properties
   
    var dataArray = [CategoryAd]()
    
    var filtersArray = [String]()
    
    var searchText = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var categoryID = 0
    var catName = ""
    
    var subcategoryID = 0
    var subcatName = ""
    
    var fromVC = ""
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Advance Search Controller")
        
        adDetailObj.sortType = "Date Descending"
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.textAlignment = .right
        }
        
        if fromVC == "advance"
        {
            self.dataArray = AddsHandler.sharedInstance.objCategoryArray
            self.tableView.reloadData()
        }
        else if fromVC == "nearby"
        {
            let param: [String: Any] = ["nearby_latitude": latitude, "nearby_longitude": longitude, "nearby_distance": 1000, "page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
        else if fromVC == "home"
        {
            createFilterView()
            let param: [String: Any] = ["ad_title": searchText ,"ad_country":0 ,"page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
        else if fromVC == "location"
        {
            let param: [String: Any] = ["ad_country" : categoryID]
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
        else
        {
            var catID = 0
            if subcatName != ""
            {
                filtersArray.append(subcatName)
                catID = subcategoryID
            }
            else
            {
                filtersArray.append(catName)
                catID = categoryID
            }
            createFilterView()
            let param: [String: Any] = ["ad_cats1" : catID, "page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("zain")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ button: UIButton)
    {
//        let alert = UIAlertController(title: "Search Alert", message: "Save this search and get notified of new results", preferredStyle: .alert)
//
//        let save = UIAlertAction(title: "Save", style: .default, handler: { (okAction) in
//        })
//
//        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        alert.addAction(save)
//        alert.addAction(cancel)
//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ button: UIButton)
    {
        adDetailObj = AdDetailObject()
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        filterVC.adFilterVC = self
        adDetailObj.sortType = "Date Descending"
        adDetailObj.adCategory = catName
        adDetailObj.catID = categoryID
        adDetailObj.adSubCategory = subcatName
        adDetailObj.subcatID = subcategoryID
        let navController = UINavigationController(rootViewController: filterVC)
        navController.navigationBar.isHidden = true
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK:- Custom Functions
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func createFilterView()
    {
        for view in filtersView.subviews
        {
            view.removeFromSuperview()
        }
        
        if catName == "Motors"
        {
            filtersArray.append("Price")
            filtersArray.append("Make/ Model")
            filtersArray.append("Year")
            filtersArray.append("Fuel type")
//            filtersArray.append("Mileage")
        }
        
        filtersArray.append(adDetailObj.sortType)
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: filtersView.frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        filtersView.addSubview(scrollView)
        
        var xAxis = 10
        var width = 0
        
        for i in 0..<filtersArray.count
        {
            let filter: String = filtersArray[i]
            
            width = Int((filter.html2AttributedString?.width(withConstrainedHeight: 36))!)
            width += 70
            
            let view = UIView()
            view.frame = CGRect(x: Int(xAxis), y: 7, width: Int(width), height: 36)
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1.0
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            
            
            let lbl = UILabel()
            lbl.frame = CGRect(x: 0, y: 0, width: width, height: 36)
            lbl.textAlignment = .center
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.backgroundColor = .clear
            lbl.text = filter
            
            let crossBtn = UIButton()
            crossBtn.frame = CGRect(x: view.frame.width - 18, y: 13, width: 10, height: 10)
            crossBtn.setImage(UIImage(named: "cross_grey"), for: .normal)
            crossBtn.tag = i
            crossBtn.addTarget(self, action: #selector(crossBtnAction(button:)), for: .touchUpInside)
            
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 36)
        
          
            view.addSubview(lbl)
            view.addSubview(btn)
            if filter != "All Ads" && filter != "Date Descending" && filter != "Date Ascending" && filter != "Price Ascending" && filter != "Price Descending" && filter != "Price" && filter != "Make/ Model" && filter != "Year" && filter != "Fuel type"
            {
                view.addSubview(crossBtn)
            }
            scrollView.addSubview(view)
            
            xAxis += (Int(width) + 10)
        }
        
        scrollView.contentSize = CGSize(width: xAxis, height: 0)
    }
    
    func getFilteredData()
    {
        var customDictionary: [String: Any] = [String: Any]()
        
        if adDetailObj.adCategory == "Motors"
        {
            if adDetailObj.motorCatObj.sellerType != ""
            {
                customDictionary.merge(with: ["sellerType" : adDetailObj.motorCatObj.sellerType])
            }
            
            if adDetailObj.motorCatObj.make != ""
            {
                customDictionary.merge(with: ["make" : adDetailObj.motorCatObj.make])
            }
            
            if adDetailObj.motorCatObj.model != ""
            {
                customDictionary.merge(with: ["model" : adDetailObj.motorCatObj.model])
            }
            
            if adDetailObj.motorCatObj.year != ""
            {
                customDictionary.merge(with: ["year" : adDetailObj.motorCatObj.year])
            }
            
            if adDetailObj.motorCatObj.mileage != ""
            {
                customDictionary.merge(with: ["mileage" : adDetailObj.motorCatObj.mileage])
            }
            
            if adDetailObj.motorCatObj.bodyType != ""
            {
                customDictionary.merge(with: ["bodyType" : adDetailObj.motorCatObj.bodyType])
            }
            
            if adDetailObj.motorCatObj.fuelType != ""
            {
                customDictionary.merge(with: ["fuelType" : adDetailObj.motorCatObj.fuelType])
            }
            
            if adDetailObj.motorCatObj.transmission != ""
            {
                customDictionary.merge(with: ["transmission" : adDetailObj.motorCatObj.transmission])
            }
            
            if adDetailObj.motorCatObj.colour != ""
            {
                customDictionary.merge(with: ["colour" : adDetailObj.motorCatObj.colour])
            }
            
            if adDetailObj.motorCatObj.engineSize != ""
            {
                customDictionary.merge(with: ["engineSize" : adDetailObj.motorCatObj.engineSize])
            }
            
            if adDetailObj.subcatID > 0
            {
                filtersArray = [adDetailObj.adSubCategory]
            }
            else
            {
                filtersArray = [adDetailObj.adCategory]
            }
            
            let custom = Constants.json(from: customDictionary)
            var param: [String: Any] = ["custom_fields": custom!]
            param.merge(with: customDictionary)
            
            self.postData(parameter: param as NSDictionary)
        }
        else
        {
            var catID = 0
            if subcatName != ""
            {
                filtersArray = [subcatName]
                catID = subcategoryID
            }
            else if catName != ""
            {
                filtersArray = [catName]
                catID = categoryID
            }
            else
            {
                filtersArray = ["All Ads"]
            }
            createFilterView()
            
            var param: [String: Any] = ["ad_cats1" : catID, "page_number": 1]
            
            if userDetail?.currentLocation.coordinate != nil
            {
                param = ["ad_cats1" : catID, "nearby_latitude": adDetailObj.location.lat, "nearby_longitude": adDetailObj.location.lng, "nearby_distance": 1000, "page_number": 1]
            }
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
    }
    
    @IBAction func crossBtnAction(button: UIButton)
    {
        categoryID = 0
        catName = ""
        filtersArray = ["All Ads"]
        createFilterView()
        let param: [String: Any] = ["ad_cats1" : 0, "page_number": 1]
        print(param)
        self.categoryData(param: param as NSDictionary)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.text != nil && textField.text!.count > 0
        {
            textField.resignFirstResponder()
            categoryID = 0
            catName = ""
            filtersArray = ["All Ads"]
            createFilterView()
            let param: [String: Any] = ["ad_title": txtSearch.text! ,"ad_country":0, "page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
        
        return true
    }
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        let objData = dataArray[indexPath.row]
        
        for image in objData.images {
            if let imgUrl = URL(string: image.thumb) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        if let title = objData.adTitle {
            cell.lblName.text = title
        }
        if let location = objData.location.address {
            cell.btnLocation.setTitle(location, for: .normal)
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        
        if let date = objData.adDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            let date = formatter.date(from: date)
            
            cell.lblDate.text = timeAgoSinceShort(date!)
        }
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblProcess.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.btnLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        cell.locationAction = { () in
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            mapVC.address = objData.adLocation.address ?? ""
            mapVC.latitude = Double(objData.adLocation.lat ?? "0.0")
            mapVC.longitude = Double(objData.adLocation.longField ?? "0.0")
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        cell.favouriteAction = { () in
            let parameter: [String: Any] = ["ad_id": objData.adId]
            self.makeAddFavourite(param: parameter as NSDictionary)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let AdDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AdDetailVC") as! AdDetailVC
//        self.navigationController?.pushViewController(AdDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    //MARK:- API Call
    
    func postData(parameter : NSDictionary) {
        self.showLoader()
        AddsHandler.searchData(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                
                self.dataArray = successResponse.data.ads
                adDetailObj = AdDetailObject()
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
    
    func categoryData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.categoryData(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                AddsHandler.sharedInstance.objCategory = successResponse
                AddsHandler.sharedInstance.isShowFeatureOnCategory = successResponse.extra.isShowFeatured
                self.dataArray = successResponse.data.ads
                
                if adDetailObj.sortType == "Price Ascending"
                {
                    self.dataArray.sort {
                        $0.adPrice.price > $1.adPrice.price
                    }
                }
                else if adDetailObj.sortType == "Price Descending"
                {
                    self.dataArray.sort {
                        $0.adPrice.price < $1.adPrice.price
                    }
                }
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
    
    func makeAddFavourite(param: NSDictionary) {
        self.showLoader()
        AddsHandler.makeAddFavourite(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension NSAttributedString
{
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}
