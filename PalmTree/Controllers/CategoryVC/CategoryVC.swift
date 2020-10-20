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

class CategoryVC: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate
{
    //MARK:- Properties
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var tblView: CollapseTableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Properties
    var subCatArray = [SubCategoryObject]()
    var filteredArray = [SubCategoryObject]()
    
    var selectedCatName = ""
    var selectedCat = 0
    var selectedIndex = -1
    
    
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
                self.txtSearch.resignFirstResponder()
                let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
                
                if sectionIndex == 0
                {
                    if self.fromVC == "filter" || self.fromVC == "adPost"
                    {
                        adDetailObj.adCategory = self.selectedCatName
                        adDetailObj.catID = self.selectedCat
                        adDetailObj.adSubCategory = ""
                        adDetailObj.subcatID = 0
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        adFilterListVC.categoryID = self.selectedCat
                        adFilterListVC.catName = self.selectedCatName
                        self.navigationController?.pushViewController(adFilterListVC, animated: true)
                    }
                }
                else
                {
                    let values = self.filteredArray[sectionIndex - 1]
                    
                    if values.hasSub == "0"
                    {
                        if self.fromVC == "filter" || self.fromVC == "adPost"
                        {
                            adDetailObj.adCategory = self.selectedCatName
                            adDetailObj.catID = self.selectedCat
                            adDetailObj.adSubCategory = values.name
                            adDetailObj.subcatID = values.id
                            self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {

                            adFilterListVC.categoryID = self.selectedCat
                            adFilterListVC.catName = self.selectedCatName
                            adFilterListVC.subcategoryID = values.id
                            adFilterListVC.subcatName = values.name
                            self.navigationController?.pushViewController(adFilterListVC, animated: true)
                        }
                    }
                }
            }

            selectedCat = categoryArray[0].id
            selectedCatName = categoryArray[0].name
            selectedIndex = 0
            getSubCategories(catID: selectedCat)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView(frame: .zero)
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
            
            if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, objData.imgUrl.encodeUrl())) {
                imgPicture.sd_setShowActivityIndicatorView(true)
                imgPicture.sd_setIndicatorStyle(.gray)
                imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            
            let lbl = UILabel()
            lbl.frame = CGRect(x: 44, y: 16, width: lblWidth+40, height: 17)
            lbl.textAlignment = .center
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.backgroundColor = .clear
            
            if languageCode == "ar"
            {
                lbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                lbl.text = objData.arabicName
            }
            else
            {
               lbl.text = objData.name
            }
            
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: Int(width), height: 50)
            btn.tag = i + 1000
            btn.addTarget(self, action: #selector(clickBtnACtion(button:)), for: .touchUpInside)
            
            let lineView = UIView()
            lineView.frame = CGRect(x: 10, y: Int(view.frame.height - 3.0), width: Int(view.frame.width) - 10, height: 3)
            lineView.backgroundColor = UIColor(red: 58.0/255.0, green: 171.0/255.0, blue: 51.0/255.0, alpha: 1)
            lineView.tag = i + 2000
            
            if i == 0
            {
                lineView.alpha = 1
            }
            else
            {
                lineView.alpha = 0
            }
            
            view.addSubview(imgPicture)
            view.addSubview(lbl)
            view.addSubview(lineView)
            view.addSubview(btn)
            scrollView.addSubview(view)
            
            xAxis += (Int(width))
        }
        
        scrollView.contentSize = CGSize(width: xAxis + 10, height: 0)
    }
    
    @IBAction func clickBtnACtion(button: UIButton)
    {
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        
        let objData = categoryArray[button.tag - 1000]
        selectedCat = objData.id;
        selectedCatName = objData.name
        selectedIndex = button.tag - 1000
        
        hideLines()
        let view = self.view.viewWithTag(button.tag + 1000)
        view?.alpha = 1
        
        filteredArray = [SubCategoryObject]()
        tblView.reloadData()
        getSubCategories(catID: selectedCat)
    }
    
    func hideLines()
    {
        for i in 0..<categoryArray.count
        {
            let view = self.view.viewWithTag(i + 2000)
            view?.alpha = 0
        }
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
        let parameters: [String: Any] = ["id": String(format: "%d", catID)]
        
        self.showLoader()
        
        AddsHandler.getSubCategories(parameter: parameters as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            
            if successResponse.success {
                
                let catArray = successResponse.categories
                print(catArray)
                self.subCatArray = [SubCategoryObject]()
                if catArray!.count > 0
                {
                    var index = 0
                    for obj in catArray!
                    {
                        var subCatObj = SubCategoryObject()
                        subCatObj.id = obj.id
                        subCatObj.name = obj.name
                        subCatObj.hasSub = obj.hasSub
                        subCatObj.hasParent = obj.hasParent
//                        subCatObj.arabicName = obj.arabicName
//                        subCatObj.status = obj.status

                        
                        DispatchQueue.main.async {
                            self.subCatArray.append(subCatObj)
                            self.filteredArray = self.subCatArray
                            
                            if obj.hasSub == "1"
                            {
                                DispatchQueue.main.async {
                                    self.innerCategoriesAPI(catID: obj.id)
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.tblView.reloadData()
                }
                
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
    
    func innerCategoriesAPI(catID: Int)
    {
        self.showLoader()

        let parameters: [String: Any] = ["id": String(format: "%d", catID)]
        
        AddsHandler.getSubCategories(parameter: parameters as NSDictionary,success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success
            {
                let catArray = successResponse.categories
                print(catArray)
                
                if catArray!.count > 0
                {
                    var catArray = [SubCategoryObject]()
                    for obj in successResponse.categories
                    {
                        var subCatObj = SubCategoryObject()
                        subCatObj.id = obj.id
                        subCatObj.name = obj.name
                        subCatObj.hasSub = obj.hasSub
//                        subCatObj.hasParent = obj.hasParent
//                        subCatObj.arabicName = obj.arabicName
//                        subCatObj.status = obj.status
                        catArray.append(subCatObj)
                    }
                    
                    if let index = self.subCatArray.firstIndex(where: { $0.id == catID})
                    {
                        var obj: SubCategoryObject = self.subCatArray[index]
                        obj.subCatArray = catArray
                        self.subCatArray[index] = obj
                    }
                    
                    self.filteredArray = self.subCatArray
                    
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                }
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
    
    @IBAction func textFiledDidChange(_ textFiled : UITextField)
    {
        if textFiled.text != ""
        {
            filteredArray = subCatArray.filter({$0.name.localizedCaseInsensitiveContains(String(format: "%@",textFiled.text!))})
        }
        else
        {
            filteredArray = subCatArray
        }
        
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
}

extension CategoryVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = 0

        if section > 0
        {
            if self.filteredArray.count > 0
            {
                count = self.filteredArray[section - 1].subCatArray.count
                print(count)
            }
        }

        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var count = 0

        if self.filteredArray.count > 0
        {
            count = self.filteredArray.count + 1
        }
        else
        {
            count = 1
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
            let category = self.filteredArray[indexPath.section - 1].subCatArray
            let subCat = category[indexPath.row]
            cell.lblName.text = subCat.name
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 44))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 44))
        label.textColor = UIColor.black
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        let arrow = UIImageView(frame: CGRect(x: tableView.frame.size.width - 30, y: 15, width: 15, height: 15))
        arrow.image = UIImage(named: "drop_arrow")
        arrow.contentMode = .scaleAspectFit
        
        let lineview = UIView(frame: CGRect(x: 10, y: 43.5, width: tableView.frame.size.width - 10, height: 0.5))
        lineview.backgroundColor = .lightGray
        lineview.alpha = 0.5
        
        view.addSubview(label)
        view.addSubview(lineview)
    
        if languageCode == "ar"
        {
            label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }

        if section == 0
        {
            label.text = "All types"
        }
        else
        {
            let values = self.filteredArray[section - 1]
            if values.hasSub == "1"
            {
                view.addSubview(arrow)
            }
            
            label.text = values.name
        }

        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        txtSearch.resignFirstResponder()
        
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
            let category = self.filteredArray[indexPath.section - 1].subCatArray
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
