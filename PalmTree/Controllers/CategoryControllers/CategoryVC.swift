//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable
{
    //MARK:- Properties
    
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var categoryTitle = ""
    
    var subCatObj:SubCategoryData?
    
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
            getSubCategories(catID: categoryArray[0].catId)
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
//                lbl.text = NSLocalizedString(objData.name, comment: "")
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
        
        scrollView.contentSize = CGSize(width: 850, height: 0)
    }
    
    @IBAction func clickBtnACtion(button: UIButton)
    {
        let objData = categoryArray[button.tag - 1000]
        getSubCategories(catID: objData.catId)
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
        
        let adPostVC = AadPostController()
        adPostVC.showLoader()
        AddsHandler.adPostSubcategory(parameter: param as NSDictionary, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                
                self.subCatObj = successResponse.data
                
                DispatchQueue.main.async {
                    self.createCategoriesView()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCatObj?.values.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        if indexPath.row == 0
        {
            cell.lblName.text = "All"
        }
        else
        {
            let values = subCatObj?.values[indexPath.row - 1]
            cell.lblName.text = values?.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        self.navigationController?.pushViewController(adFilterListVC, animated: true)
    }
}
