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
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var lblTry: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
    
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
            txtSearch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.textAlignment = .right
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            tblView.alpha = 1
            leading.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            savedView.alpha = 0
            recentBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            savedBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
        }
        else
        {
            tblView.alpha = 0
            savedView.alpha = 1
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
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblAlertType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
