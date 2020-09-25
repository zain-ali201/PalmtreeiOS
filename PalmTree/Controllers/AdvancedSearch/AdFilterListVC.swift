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
    
    @IBOutlet weak var norecordView: UIView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
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
   
    var dataArray = [AdsJSON]()
    
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
            lblMsg.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtSearch.textAlignment = .right
        }
        
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
        let param: [String: Any] = ["cat_id" : catID, "title": searchText, "address" : adDetailObj.location.address, "user_id" : defaults.integer(forKey: "userID")]
        print(param)
        self.searchAds(param: param as NSDictionary)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if adDetailObj.catID > 0
        {
            categoryID = adDetailObj.catID
        }
        
        if adDetailObj.subcatID > 0
        {
            subcategoryID = adDetailObj.subcatID
        }
        
        if adDetailObj.adCategory != ""
        {
            catName = adDetailObj.adCategory
        }
        
        if adDetailObj.adSubCategory != ""
        {
            subcatName = adDetailObj.adSubCategory
        }
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
        let alert = UIAlertController(title: "Search Alert", message: "Save this search and get notified of new results", preferredStyle: .alert)

        let save = UIAlertAction(title: "Save", style: .default, handler: { (okAction) in
            
            if var savedList = UserDefaults.standard.array(forKey: "savedList") as? [[String: Any]]
            {
                let cName = self.subcatName != "" ? self.subcatName : self.catName
                
                savedList.append(["title": "\(cName) in \(userDetail?.locationName ?? "UAE")", "catID": self.subcategoryID > 0 ? self.subcategoryID : self.categoryID, "catName": cName, "locationName": userDetail?.locationName ?? "UAE", "lat": userDetail?.lat ?? 0.0, "lng": userDetail?.lng ?? 0.0])
                UserDefaults.standard.set(savedList, forKey: "savedList")
            }
            else
            {
                let cName = self.subcatName != "" ? self.subcatName : self.catName
                
                var savedList: [[String: Any]] = []
                savedList.append(["title": "\(cName) in \(userDetail?.locationName ?? "UAE")", "catID": self.subcategoryID > 0 ? self.subcategoryID : self.categoryID, "catName": cName, "locationName": userDetail?.locationName ?? "UAE", "lat": userDetail?.lat ?? 0.0, "lng": userDetail?.lng ?? 0.0])
                UserDefaults.standard.set(savedList, forKey: "savedList")
            }
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
            if filter != "All Ads" && filter != "Date Descending" && filter != "Most Recent" && filter != "Nearest to me" && filter != "Cheapest" && filter != "Most expensive" && filter != "Best match" && filter != "Price" && filter != "Make/ Model" && filter != "Year" && filter != "Fuel type"
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
            
            if adDetailObj.motorCatObj.engineSize != ""
            {
                customDictionary.merge(with: ["engineSize" : adDetailObj.motorCatObj.engineSize])
            }
            
            var catID = 0
            if adDetailObj.subcatID > 0
            {
                filtersArray = [adDetailObj.adSubCategory]
                catID = adDetailObj.subcatID
            }
            else if adDetailObj.catID > 0
            {
                filtersArray = [adDetailObj.adCategory]
                catID = adDetailObj.catID
            }
            else
            {
                filtersArray = ["All Ads"]
            }
            
            createFilterView()
            
            let custom = Constants.json(from: customDictionary)
            var param: [String: Any] = ["cat_id" : catID, "address" : adDetailObj.location.address, "custom_fields": custom!, "user_id" : defaults.integer(forKey: "userID")]
            param.merge(with: customDictionary)
            self.searchAds(param: param as NSDictionary)
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
            
            let param: [String: Any] = ["cat_id" : catID, "title": searchText, "address" : adDetailObj.location.address, "user_id" : defaults.integer(forKey: "userID")]
            print(param)
            self.searchAds(param: param as NSDictionary)
        }
    }
    
    @IBAction func crossBtnAction(button: UIButton)
    {
        categoryID = 0
        catName = ""
        adDetailObj = AdDetailObject()
        adDetailObj.sortType = "Date Descending"
        filtersArray = ["All Ads"]
        createFilterView()
        let param: [String: Any] = ["title": "", "user_id" : defaults.integer(forKey: "userID")]
        print(param)
        self.searchAds(param: param as NSDictionary)
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
            let param: [String: Any] = ["title": txtSearch.text!, "user_id" : defaults.integer(forKey: "userID")]
            print(param)
            self.searchAds(param: param as NSDictionary)
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
        
        if objData.images.count > 0
        {
            if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, objData.images[0].url.encodeUrl())) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        if let title = objData.title {
            cell.lblName.text = title
        }
        if let location = objData.address {
            cell.btnLocation.setTitle(location, for: .normal)
        }
        if let price = objData.price {
            cell.lblPrice.text = String(format: "AED %@", price)
        }
        
        if let date = objData.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: date)
            
            cell.lblDate.text = timeAgoSinceShort(date!)
        }
        
        if defaults.bool(forKey: "isLogin") == true
        {
            if objData.isFavorite
            {
                cell.promoteBtn.setImage(UIImage(named: "favourite_active"), for: .normal)
            }
            else
            {
                cell.promoteBtn.setImage(UIImage(named: "favourite"), for: .normal)
            }
        }
        else
        {
            cell.promoteBtn.setImage(UIImage(named: "favourite"), for: .normal)
        }
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblProcess.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.btnLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
//        cell.locationAction = { () in
//            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//            mapVC.address = objData.location.address ?? ""
//            mapVC.latitude = Double(objData.location.lat ?? "0.0")
//            mapVC.longitude = Double(objData.location.longField ?? "0.0")
//            self.navigationController?.pushViewController(mapVC, animated: true)
//        }
        
        cell.favouriteAction = { () in
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                if !objData.isFavorite
                {
                    let parameter: [String: Any] = ["ad_id": objData.id, "user_id": userDetail?.id ?? 0]
                    self.makeAddFavourite(param: parameter as NSDictionary)
                }
                else
                {
                    self.showToast(message: "This Ad is already in your favourites.")
                }
            }
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
    
    func searchAds(param: NSDictionary) {
        self.showLoader()
        AddsHandler.searchAds(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                self.dataArray = successResponse.data
                
                if self.dataArray.count == 0
                {
                    self.norecordView.alpha = 1
                }
                else
                {
                    var index = 0
                    for var obj in self.dataArray
                    {
                        obj.price = obj.price.replacingOccurrences(of: "AED ", with: "")
                        self.dataArray[index] = obj
                        index += 1
                    }
                    
                    if adDetailObj.sortType == "Cheapest"
                    {
                        self.dataArray = self.dataArray.filter( {
                            $0.price < "200"
                        })
                    }
                    else if adDetailObj.sortType == "Most expensive"
                    {
                        self.dataArray = self.dataArray.filter( {
                            $0.price > "1000"
                        })
                    }
                    
                    if self.dataArray.count > 0 && adDetailObj.minPrice != "" && adDetailObj.maxPrice != ""
                    {
                        self.dataArray = self.dataArray.filter( {
                            $0.price > adDetailObj.minPrice && $0.price < adDetailObj.maxPrice
                        })
                    }
                    
                    if self.dataArray.count > 0
                    {
                        self.norecordView.alpha = 0
                    }
                    else
                    {
                        self.norecordView.alpha = 1
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
