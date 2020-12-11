//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PropertyVC: UIViewController, UITextFieldDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var txtBedrooms: UITextField!
    @IBOutlet weak var flatBtn: UIButton!
    @IBOutlet weak var houseBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var agencyBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var lblProperty: UILabel!
    @IBOutlet weak var lblSeller: UILabel!
    
    var sellerType = ""
    var propertyType = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Property Controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func propertyBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            flatBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            houseBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            otherBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            propertyType = "Flat"
        }
        else if button.tag == 1002
        {
            houseBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            flatBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            otherBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            propertyType = "House"
        }
        else
        {
            otherBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            houseBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            flatBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            propertyType = "Other"
        }
    }
    
    @IBAction func sellerBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            agencyBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            privateBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            sellerType = "Agency"
        }
        else
        {
            privateBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            agencyBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            sellerType = "Private"
        }
    }
    
    @IBAction func listBtnAction(_ sender: Any)
    {
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        listVC.fromInd = "Property type"
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func doneBtnAction(_ sender: Any)
    {
        var flag = true
        
        if txtBedrooms.text == ""
        {
            txtBedrooms.shake(6, withDelta: 10, speed: 0.06)
            flag = false
        }
        
        if propertyType == ""
        {
            flag = false
        }
        
        if sellerType == ""
        {
            flag = false
        }
        
        if flag
        {
            adDetailObj.motorCatObj.regNo = ""
            adDetailObj.motorCatObj.model = ""
            adDetailObj.motorCatObj.year = ""
            adDetailObj.motorCatObj.mileage = ""
            adDetailObj.motorCatObj.engineSize = ""
            adDetailObj.motorCatObj.sellerType = ""
            
            adDetailObj.propertyCatObj.propertyType = propertyType
            adDetailObj.propertyCatObj.bedrooms = txtBedrooms.text ?? ""
            adDetailObj.propertyCatObj.sellerType = sellerType
            
            let detailStr = adDetailObj.propertyCatObj.propertyType + ", " + adDetailObj.propertyCatObj.bedrooms + ", " + adDetailObj.propertyCatObj.sellerType
            
            adDetailObj.specs = detailStr
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.showToast(message: "Please fillup required fields")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtBedrooms.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
