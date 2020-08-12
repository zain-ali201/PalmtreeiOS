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
        
//        if fromInd == "Sort Type"
//        {
            dataArray = ["Date Descending", "Price Ascending", "Price Descending"]
//        }
//        else if fromInd == "Year"
//        {
//            dataArray = ["Up to 1 year", "Up to 2 year", "Up to 3 year", "Up to 4 year", "Up to 5 year", "Up to 6 year", "Up to 7 year", "Up to 8 year", "Up to 9 year", "Up to 1 year", "Up to 10 year"]
//        }
//        else if fromInd == "Fuel Type"
//        {
//            dataArray = ["" , "", "", "", ""]
//        }
//        else if fromInd == "Transmission"
//        {
//            dataArray = ["Any", "Automatic", "Manual", "Semi-Auto", "Other"]
//        }
//        else if fromInd == "Colour"
//        {
//            dataArray = ["Any", "Biege", "Black", "Blue", "Bronze", "Brown", "Cream", "Gold", "Green", "Grey", "Maroon", "Mauve", "Multi-Coloured", "Orange", "Pink", "Purple", "Red", "Silver", "White", "Yellow", "Other"]
//        }
        
        tblView.reloadData()
        self.googleAnalytics(controllerName: "Sort Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSelect.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
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
        cell.lblName.text = title
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
