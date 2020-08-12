//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CategoryVC: UIViewController, NVActivityIndicatorViewable
{
    //MARK:- Properties
    
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var selectedCatName = ""
    var selectedCat = 0
    var subCatObj:SubCategoryData?
    var subCatArray = [SubCategoryValue]()
    
    var fromVC = ""
    
    let section = ["First Header", "Second Header", "Third Header"]
    //Array for Items in sections
    let items = [["Content", "Content1", "Content2"], ["Content3", "Content4", "Content5"], ["Content6", "Content7", "Content8"]]
    
    var collapaseHandlerArray = [SubCategoryValue]()
    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCategoriesView()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        if categoryArray.count > 0
        {
            selectedCat = categoryArray[0].catId
            selectedCatName = categoryArray[0].name
            getSubCategories(catID: selectedCat)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnACtion(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createCategoriesView()
    {
        for view in categoriesView.subviews
        {
            view.removeFromSuperview()
        }
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: categoriesView.frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        categoriesView.addSubview(scrollView)
        
        var xAxis = 10
        var width = 0
        
        for i in 0..<categoryArray.count
        {
            let objData = categoryArray[i]
            
            let lblWidth = Int((objData.name.html2AttributedString?.width(withConstrainedHeight: 50))!)
            width = lblWidth + 80
            
            let view = UIView()
            view.frame = CGRect(x: Int(xAxis), y: 0, width: Int(width), height: 50)
            
            let imgPicture = UIImageView()
            imgPicture.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
            imgPicture.contentMode = .scaleAspectFit
            
            if let imgUrl = URL(string: objData.img.encodeUrl()) {
                imgPicture.sd_setShowActivityIndicatorView(true)
                imgPicture.sd_setIndicatorStyle(.gray)
                imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            
            let lbl = UILabel()
            lbl.frame = CGRect(x: 44, y: 16, width: lblWidth+20, height: 17)
            lbl.textAlignment = .center
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.backgroundColor = .clear
            
            if languageCode == "ar"
            {
                lbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                lbl.text = objData.name
            }
            else
            {
               lbl.text = objData.name
            }
            
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: Int(width), height: 50)
            btn.tag = i + 1000
            btn.addTarget(self, action: #selector(clickBtnACtion(button:)), for: .touchUpInside)
            
            view.addSubview(imgPicture)
            view.addSubview(lbl)
            view.addSubview(btn)
            scrollView.addSubview(view)
            
            xAxis += (Int(width))
        }
        
        scrollView.contentSize = CGSize(width: xAxis, height: 0)
    }
    
    @IBAction func clickBtnACtion(button: UIButton)
    {
        let objData = categoryArray[button.tag - 1000]
        selectedCat = objData.catId
        selectedCatName = objData.name
        getSubCategories(catID: selectedCat)
    }
    
    func showLoader()
    {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func getSubCategories(catID: Int)
    {
        self.subCategoriesAPI(catID: catID)
    }
    
    func subCategoriesAPI(catID: Int)
    {
        let param: [String: Any] = ["subcat": catID]
        
        self.showLoader()
        
        AddsHandler.adPostSubcategory(parameter: param as NSDictionary, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                
                self.subCatObj = successResponse.data
                
                DispatchQueue.main.async {
//                    self.createCategoriesView()
                    self.tblView.reloadData()
                }
              //UserDefaults.standard.set(successResponse.isBid, forKey: "isBid")
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
    //MARK:- TableView Delegate
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        var count = 0
//
//        if subCatObj?.values.count ?? 0 > 0
//        {
//            count = (subCatObj?.values.count)! + 1
//        }
//
//        return count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
//
//        if languageCode == "ar"
//        {
//            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        }
//
//        if indexPath.row == 0
//        {
//            cell.lblName.text = "All types"
//        }
//        else
//        {
//            let values = subCatObj?.values[indexPath.row - 1]
//            cell.lblName.text = values?.name
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
//        if indexPath.row == 0
//        {
//            if fromVC == "filter" || fromVC == "adPost"
//            {
//                adDetailObj.adCategory = selectedCatName
//                adDetailObj.catID = selectedCat
//                adDetailObj.adSubCategory = ""
//                adDetailObj.subcatID = 0
//                self.navigationController?.popViewController(animated: true)
//            }
//            else
//            {
//                adFilterListVC.categoryID = selectedCat
//                adFilterListVC.catName = selectedCatName
//                self.navigationController?.pushViewController(adFilterListVC, animated: true)
//            }
//        }
//        else
//        {
//            let values = subCatObj?.values[indexPath.row - 1]
//
//            if fromVC == "filter" || fromVC == "adPost"
//            {
//                adDetailObj.adCategory = selectedCatName
//                adDetailObj.catID = selectedCat
//                adDetailObj.adSubCategory = values?.name ?? ""
//                adDetailObj.subcatID = values?.id ?? 0
//                self.navigationController?.popViewController(animated: true)
//            }
//            else
//            {
//
//                adFilterListVC.categoryID = selectedCat
//                adFilterListVC.catName = selectedCatName
//                adFilterListVC.subcategoryID = values?.id ?? 0
//                adFilterListVC.subcatName = values?.name ?? ""
//                self.navigationController?.pushViewController(adFilterListVC, animated: true)
//            }
//        }
//    }
}


extension CategoryVC : UITableViewDataSource,UITableViewDelegate {
    
    //setting number of Sections
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var count = 0

        if subCatObj?.values.count ?? 0 > 0
        {
            count = subCatObj?.values.count ?? 0
        }

        return count
    }
    //Setting headerView Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    //Setting Header Customised View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //Declare cell
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        

        if section == 0
        {
            headerCell.lblName.text = "All types"
            headerCell.ButtonToShowHide.alpha = 0
        }
        else
        {
            let values = subCatObj?.values[section - 1]
            headerCell.lblName.text = values?.name
            headerCell.ButtonToShowHide.tag = section
            
            //Adding a target to button
            headerCell.ButtonToShowHide.addTarget(self, action: #selector(CategoryVC.HandleheaderButton(sender:)), for: .touchUpInside)
        }
        return headerCell.contentView
        
    }
    
    //Setting number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 0
        }
        else
        {
            return 3
        }
    }
    
    //Setting cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        //setting title
        cell.lblName.text = items[indexPath.section][indexPath.row]
        return cell
    }
    
    //Header cell button Action
    @objc func HandleheaderButton(sender: UIButton){
        
        
        //reload section
        self.tblView.reloadSections(IndexSet(integer: sender.tag), with: .none)
    }
}
