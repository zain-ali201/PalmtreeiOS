//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AreasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{   
    //MARK:- Properties
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    var dataArray: [String] = [String]()
    var filteredArray = [String]()
    
    var country = ""
    var countryID = 0
    var fromInd = ""
    var cLat: Double = 0.0
    var cLong: Double = 0.0
    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearch.becomeFirstResponder()
        
        if countryID > 0
        {
            cLat = Double(NSLocalizedString(String(format: "Country%d_lat",countryID), comment: "")) ?? 0.0
            cLong = Double(NSLocalizedString(String(format: "Country%d_lng",countryID), comment: "")) ?? 0.0
            
            let areaCount: Int = Int(NSLocalizedString(String(format: "Country%d_count",countryID), comment: "")) ?? 0
            
            for i in 1...areaCount
            {
                dataArray.append(NSLocalizedString(String(format: "Country%d_area%d", countryID, i), comment: ""))
            }
            filteredArray = dataArray
            tblView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    @IBAction func cnacelBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFiledDidChange(_ textFiled : UITextField)
    {
        if textFiled.text != ""
        {
            filteredArray = dataArray.filter({$0.localizedCaseInsensitiveContains(String(format: "%@",textFiled.text!))})
        }
        else
        {
            filteredArray = dataArray
        }
        
        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        let title = filteredArray[indexPath.row]
        cell.lblName.text = title
        cell.lblLocation.text = country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if fromInd == "AdPost"
        {
            adDetailObj.location.lat = cLat
            adDetailObj.location.lat = cLong
            adDetailObj.location.address = filteredArray[indexPath.row]
            self.navigationController?.popToViewController(adPostVC, animated: true)
        }
        else if fromInd == "Filter"
        {
            adDetailObj.location.address = filteredArray[indexPath.row]
            self.navigationController?.popToViewController(filterVC, animated: true)
        }
    }
}
