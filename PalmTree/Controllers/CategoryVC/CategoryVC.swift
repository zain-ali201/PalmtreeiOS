//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CollapseTableView

class CategoryVC: UIViewController, NVActivityIndicatorViewable
{
    //MARK:- Properties
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var tblView: CollapseTableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var selectedCatName = ""
    var selectedCat = 0
    var subCatArray = [SubCategoryObject]()
    
    var fromVC = ""
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
            setupTableView()
            tblView.didTapSectionHeaderView = { (sectionIndex, isOpen) in
                debugPrint("sectionIndex \(sectionIndex), isOpen \(isOpen)")
            }

            
            selectedCat = categoryArray[0].catId
            selectedCatName = categoryArray[0].name
            getSubCategories(catID: selectedCat)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: SectionHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
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
                
                let catArray = successResponse.data.values
                
                if catArray!.count > 0
                {
                    self.subCatArray = [SubCategoryObject]()
                    for obj in catArray!
                    {
                        var subCatObj = SubCategoryObject()
                        subCatObj.id = obj.id
                        subCatObj.name = obj.name
                        subCatObj.hasSub = obj.hasSub
                        
                        if obj.hasSub
                        {
                            DispatchQueue.main.async {
                                self.innerCategoriesAPI(catID: obj.id)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.subCatArray.append(subCatObj)
                        }
                    }
                }
                
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
    
    func innerCategoriesAPI(catID: Int)
    {
        let param: [String: Any] = ["subcat": catID]
        
        self.showLoader()
        
        AddsHandler.adPostSubcategory(parameter: param as NSDictionary, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success
            {
                if successResponse.data.values != nil
                {
                    var index = 0
                    for var obj in self.subCatArray
                    {
                        if obj.name == successResponse.data.title
                        {
                            var catArray = [SubCategoryObject]()
                            for obj in successResponse.data.values
                            {
                                var subCatObj = SubCategoryObject()
                                subCatObj.id = obj.id
                                subCatObj.name = obj.name
                                subCatObj.hasSub = obj.hasSub
                                catArray.append(subCatObj)
                            }
                            
                            obj.subCatArray = catArray
                            self.subCatArray[index] = obj
                        }
                        index += 1
                    }
                }
                
                DispatchQueue.main.async {
                    print(self.subCatArray)
                    self.tblView.reloadData()
                }
              //UserDefaults.standard.set(successResponse.isBid, forKey: "isBid")
            }
            else
            {
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

extension CategoryVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = 0

        if section > 0
        {
            if self.subCatArray.count > 0
            {
                count = self.subCatArray[section - 1].subCatArray.count
                print(count)
            }
        }

        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var count = 0

        if self.subCatArray.count > 0
        {
            count = self.subCatArray.count + 1
        }

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        if indexPath.section > 0
        {
            let category = self.subCatArray[indexPath.section - 1].subCatArray
            let subCat = category[indexPath.row]
            cell.lblName.text = subCat.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) else {
            let view = Bundle.main.loadNibNamed(SectionHeaderView.reuseIdentifier, owner: self, options: nil)?.first as? SectionHeaderView
            
                if languageCode == "ar"
                {
                    view?.lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
        
                if section == 0
                {
                    view?.lblTitle.text = "All types"
                }
                else
                {
                    let values = self.subCatArray[section - 1]
                    view?.lblTitle.text = values.name
                }
            
            return view
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        if indexPath.section == 0
        {
            if fromVC == "filter" || fromVC == "adPost"
            {
                adDetailObj.adCategory = selectedCatName
                adDetailObj.catID = selectedCat
                adDetailObj.adSubCategory = ""
                adDetailObj.subcatID = 0
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                adFilterListVC.categoryID = selectedCat
                adFilterListVC.catName = selectedCatName
                self.navigationController?.pushViewController(adFilterListVC, animated: true)
            }
        }
        else
        {
            let category = self.subCatArray[indexPath.section - 1].subCatArray
            let values = category[indexPath.row]

            if fromVC == "filter" || fromVC == "adPost"
            {
                adDetailObj.adCategory = selectedCatName
                adDetailObj.catID = selectedCat
                adDetailObj.adSubCategory = values.name
                adDetailObj.subcatID = values.id
                self.navigationController?.popViewController(animated: true)
            }
            else
            {

                adFilterListVC.categoryID = selectedCat
                adFilterListVC.catName = selectedCatName
                adFilterListVC.subcategoryID = values.id
                adFilterListVC.subcatName = values.name
                self.navigationController?.pushViewController(adFilterListVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
