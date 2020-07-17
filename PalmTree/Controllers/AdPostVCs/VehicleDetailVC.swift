//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class VehicleDetailVC: UIViewController, UITextFieldDelegate
{

    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtRegNo: UITextField!
    @IBOutlet weak var txtModel: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtMileage: UITextField!
    @IBOutlet weak var txtEngineSize: UITextField!
    
    @IBOutlet weak var tradeBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    @IBOutlet weak var makeBtn: UIButton!
    @IBOutlet weak var bodyBtn: UIButton!
    @IBOutlet weak var fuelBtn: UIButton!
    @IBOutlet weak var transmissionBtn: UIButton!
    @IBOutlet weak var colourBtn: UIButton!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var lblOptional: UILabel!
    @IBOutlet weak var lblSeller: UILabel!
    
    @IBOutlet weak var lblMake: UILabel!
    @IBOutlet weak var lblBodyType: UILabel!
    @IBOutlet weak var lblFuelType: UILabel!
    @IBOutlet weak var lblTransmission: UILabel!
    @IBOutlet weak var lblColour: UILabel!
    
    var sellerType = ""
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Vehicle Detail Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtRegNo.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtModel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtYear.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtMileage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtEngineSize.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            tradeBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            privateBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            makeBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            bodyBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            fuelBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transmissionBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            colourBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblRequired.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblOptional.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSeller.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtRegNo.textAlignment = .right
            txtModel.textAlignment = .right
            txtYear.textAlignment = .right
            txtMileage.textAlignment = .right
            txtEngineSize.textAlignment = .right
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 750)
        
        if adDetailObj.motorCatObj.make != ""
        {
            lblMake.text = adDetailObj.motorCatObj.make
        }
        
        if adDetailObj.motorCatObj.bodyType != ""
        {
             lblBodyType.text = adDetailObj.motorCatObj.bodyType
        }
        
        if adDetailObj.motorCatObj.fuelType != ""
        {
             lblFuelType.text = adDetailObj.motorCatObj.fuelType
        }
        
        if adDetailObj.motorCatObj.transmission != ""
        {
             lblTransmission.text = adDetailObj.motorCatObj.transmission
        }
        
        if adDetailObj.motorCatObj.colour != ""
        {
             lblColour.text = adDetailObj.motorCatObj.colour
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sellerBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            tradeBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            privateBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            sellerType = "Trade"
        }
        else
        {
            privateBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            tradeBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            sellerType = "Private"
        }
    }
    
    @IBAction func clickBtnAction(button: UIButton)
    {
        var fromInd = ""
        
        if button.tag == 1001
        {
            fromInd = "Make"
        }
        else if button.tag == 1002
        {
            fromInd = "Body type"
        }
        else if button.tag == 1003
        {
            fromInd = "Fuel Type"
        }
        else if button.tag == 1004
        {
            fromInd = "Transmission"
        }
        else if button.tag == 1005
        {
            fromInd = "Colour"
        }
        
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        listVC.fromInd = fromInd
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func doneBtnAction(button: UIButton)
    {
        hideKeypad()
        var flag = true
        
        if txtRegNo.text == ""
        {
            txtRegNo.shake(6, withDelta: 10, speed: 0.06)
            flag = false
        }
        if txtModel.text == ""
        {
            txtModel.shake(6, withDelta: 10, speed: 0.06)
            flag = false
        }
        
        if txtYear.text == ""
        {
            txtYear.shake(6, withDelta: 10, speed: 0.06)
            flag = false
        }
        
        if txtMileage.text == ""
        {
            txtMileage.shake(6, withDelta: 10, speed: 0.06)
            flag = false
        }
        
        if adDetailObj.motorCatObj.make == ""
        {
            flag = false
        }
        
        if sellerType == ""
        {
            flag = false
        }
        
        if flag
        {
            adDetailObj.propertyCatObj.propertyType = ""
            adDetailObj.propertyCatObj.bedrooms = ""
            adDetailObj.propertyCatObj.sellerType = ""
            
            adDetailObj.motorCatObj.regNo = txtRegNo.text!
            adDetailObj.motorCatObj.model = txtModel.text!
            adDetailObj.motorCatObj.year = txtYear.text!
            adDetailObj.motorCatObj.mileage = txtMileage.text!
            adDetailObj.motorCatObj.engineSize = txtEngineSize.text ?? ""
            adDetailObj.motorCatObj.sellerType = sellerType
            
            var detailStr = adDetailObj.motorCatObj.regNo + ", " + adDetailObj.motorCatObj.sellerType + ", " + adDetailObj.motorCatObj.model + ", " + adDetailObj.motorCatObj.year + ", " + adDetailObj.motorCatObj.mileage + ", " + adDetailObj.motorCatObj.engineSize
            
            if adDetailObj.motorCatObj.bodyType != ""
            {
                detailStr = detailStr + ", " + adDetailObj.motorCatObj.bodyType
            }
            
            if adDetailObj.motorCatObj.fuelType != ""
            {
                detailStr = detailStr + ", " + adDetailObj.motorCatObj.fuelType
            }
            
            if adDetailObj.motorCatObj.transmission != ""
            {
                detailStr = detailStr + ", " + adDetailObj.motorCatObj.transmission
            }
            
            if adDetailObj.motorCatObj.colour != ""
            {
                detailStr = detailStr + ", " + adDetailObj.motorCatObj.colour
            }
            
            if adDetailObj.motorCatObj.engineSize != ""
            {
                detailStr = detailStr + ", " + adDetailObj.motorCatObj.engineSize
            }
            
            adDetailObj.specs = detailStr
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.showToast(message: "Please fillup required fields")
        }
    }
    
    @IBAction func hideKeypadBtnAction(_ sender: Any)
    {
        hideKeypad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeypad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func hideKeypad()
    {
        txtEngineSize.resignFirstResponder()
        txtRegNo.resignFirstResponder()
        txtModel.resignFirstResponder()
        txtYear.resignFirstResponder()
        txtMileage.resignFirstResponder()
    }
}
