//
//  ViewController.swift
//  ExpandableCellDemo
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit
import ExpandableCell
import NVActivityIndicatorView

var categoryList: [CategoryObject] = [CategoryObject]()

class TblViewController: UIViewController
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet var tableView: ExpandableTableView!
    {
        didSet
        {
            tableView.addSubview(refreshControl)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.expandableDelegate = self
        tableView.animation = .automatic

        tableView.register(UINib(nibName: "ExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandedCell.ID)
        tableView.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell2.ID)
                
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        if categoryList.count == 0
        {
            categoryList = []
            getSubCategories()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnACtion(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func closeBtnAction() {
        tableView.closeAll()
    }
    
    @objc func refreshTableView()
    {
        categoryList = []
        getSubCategories()
        self.refreshControl.endRefreshing()
    }
    
    //MARK:- Get SubCategroies
    
    func getSubCategories()
    {
        for catObj in categoryArray
        {
            self.subCategoriesAPI(catIcon: catObj)
        }
    }
    
    func subCategoriesAPI(catIcon: CatIcon)
    {
        let param: [String: Any] = ["subcat": catIcon.catId]
        
        let adPostVC = AadPostController()
        adPostVC.showLoader()
        AddsHandler.adPostSubcategory(parameter: param as NSDictionary, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                
                print(successResponse.data)
                let catObj = CategoryObject()
                catObj.catId = catIcon.catId
                catObj.name = catIcon.name
                catObj.img = catIcon.img
                catObj.subCatObj = successResponse.data
                
                categoryList.append(catObj)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
}

extension TblViewController: ExpandableDelegate {
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        
        let catObj = categoryList[indexPath.row]
        
        var cellsArray = [UITableViewCell]()
        
        for subcatObj in catObj.subCatObj!.values
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell.catID = catObj.catId
            cell.adCategory = catObj.name
            cell.subcatID = subcatObj.id
            cell.lblName.text = subcatObj.name
            cellsArray.append(cell)
        }
        
        return cellsArray
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [40]
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRow:\(indexPath)")
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
//        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            print("\(cell.lblName.text ?? "")")
            
            adDetailObj.adCategory = cell.adCategory
            adDetailObj.adSubCategory = cell.lblName.text ?? ""
            adDetailObj.catID = cell.catID
            adDetailObj.subcatID = cell.subcatID
            
            self.navigationController?.popViewController(animated: true)
        }
    }

//    func expandableTableView(_ expandableTableView: ExpandableTableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section:\(section)"
//    }
//    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as! ExpandableCell2
        let catObj = categoryList[indexPath.row]
        cell.lblName.text = catObj.name
        
        cell.imgView.contentMode = .scaleAspectFit
        
        if let imgUrl = URL(string: catObj.img.encodeUrl()) {
            cell.imgView.sd_setShowActivityIndicatorView(true)
            cell.imgView.sd_setIndicatorStyle(.gray)
            cell.imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    @objc(expandableTableView:didCloseRowAt:) func expandableTableView(_ expandableTableView: UITableView, didCloseRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        cell?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }
}
