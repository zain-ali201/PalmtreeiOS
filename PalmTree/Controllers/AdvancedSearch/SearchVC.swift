//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NVActivityIndicatorViewable{

    //MARK:- Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var recentBtn: UIButton!
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var savedTableView: UITableView!
    @IBOutlet weak var recentView: UIView!
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var lblTry: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblRecent: UILabel!
    @IBOutlet weak var lblRecentText: UILabel!
    
    //MARK:- Properties
    var recentArray = [SaveAdObject]()
    var savedArray = [SaveAdObject]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Search Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            recentBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            savedBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTry.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblRecent.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblRecentText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.textAlignment = .right
        }
        
        getData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- Customs
    func getData()
    {
        if let recentList = UserDefaults.standard.array(forKey: "recentList") as? [[String: Any]] {
            
            for item in recentList {
                var savedObj = SaveAdObject()
                savedObj.title = item["title"] as! String
                savedObj.catID = item["catID"] as! Int
                savedObj.catName = item["catName"] as! String
                savedObj.locationName = item["locationName"] as! String
                savedObj.lat = item["lat"] as! Double
                savedObj.lng = item["lng"] as! Double
                recentArray.append(savedObj)
            }
            recentTableView.reloadData()
        }
        else
        {
            recentView.alpha = 1
        }
        
        if let savedList = UserDefaults.standard.array(forKey: "savedList") as? [[String: Any]] {
            
            for item in savedList
            {
//                ["title": "All Ads", "catID": objData.catId, "catName": objData.name, "locationName": "", "lat": "", "lng": ""]
                var savedObj = SaveAdObject()
                savedObj.title = item["title"] as! String
                savedObj.catID = item["catID"] as! Int
                savedObj.catName = item["catName"] as! String
                savedObj.locationName = item["locationName"] as! String
                savedObj.lat = item["lat"] as! Double
                savedObj.lng = item["lng"] as! Double
                savedArray.append(savedObj)
            }
            savedTableView.reloadData()
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func crossBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func clickBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            recentTableView.alpha = 1
            savedTableView.alpha = 0
            leading.constant = 0
            savedView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            if recentArray.count == 0
            {
                recentView.alpha = 1
            }
            
            recentBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            savedBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
        }
        else
        {
            recentTableView.alpha = 0
            savedTableView.alpha = 1
            recentView.alpha = 0
            if savedArray.count == 0
            {
                savedView.alpha = 1
            }
            leading.constant = screenWidth/2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            savedBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            recentBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
        }
    }
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1001
        {
            return recentArray.count
        }
        else
        {
            return savedArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        if tableView.tag == 1001
        {
            let savedObj = recentArray[indexPath.row]
            
            cell.lblName.text = savedObj.title
            cell.lblAlertType.text = "\(savedObj.catName) - \(savedObj.locationName)"
        }
        else
        {
            let savedObj = savedArray[indexPath.row]
            
            cell.lblName.text = savedObj.title
            cell.lblAlertType.text = "\(savedObj.catName) - \(savedObj.locationName)"
        }
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblAlertType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        if tableView.tag == 1001
        {
            let savedObj = recentArray[indexPath.row]
            adFilterListVC.categoryID = savedObj.catID
            adFilterListVC.catName = savedObj.catName
        }
        else
        {
            let savedObj = savedArray[indexPath.row]
            adFilterListVC.categoryID = savedObj.catID
            adFilterListVC.catName = savedObj.catName
            
        }
        self.navigationController?.pushViewController(adFilterListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            if tableView.tag == 1001
            {
                if var recentList = UserDefaults.standard.array(forKey: "recentList") as? [[String: Any]]
                {
                    self.recentArray.remove(at: indexPath.row)
                    recentList.remove(at: indexPath.row)
                    UserDefaults.standard.set(recentList, forKey: "recentList")
                }
            }
            else
            {
                if var savedList = UserDefaults.standard.array(forKey: "savedList") as? [[String: Any]]
                {
                    self.savedArray.remove(at: indexPath.row)
                    savedList.remove(at: indexPath.row)
                    UserDefaults.standard.set(savedList, forKey: "savedList")
                }
            }
            
            tableView.reloadData()
        }

        return [delete]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != ""
        {
            let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
            adFilterListVC.searchText = textField.text!
            self.navigationController?.pushViewController(adFilterListVC, animated: true)
            textField.resignFirstResponder()
        }
        else
        {
            self.showToast(message: "Please enter ad title")
        }
        
        return true
    }
}
