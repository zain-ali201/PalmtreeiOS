//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SortVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    //MARK:- Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelect: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Properties
    var dataArray: [String] = [String]()
    
    var fromInd = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = fromInd

        dataArray = ["Date Descending", "Most Recent"/*, "Nearest to me"*/, "Cheapest", "Most expensive"/*, "Best match"*/]
        
        tblView.reloadData()
        self.googleAnalytics(controllerName: "Sort Controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let title = dataArray[indexPath.row]
        
        if languageCode == "ar"
        {
            if title == "Date Descending"
            {
                cell.lblName.text = "التاريخ تنازليا"
            }
        }
        else
        {
            cell.lblName.text = title
        }
        
        cell.tick.alpha = 0
        
        if adDetailObj.sortType == dataArray[indexPath.row]
        {
            cell.tick.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        adDetailObj.sortType = dataArray[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
}
