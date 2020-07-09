//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LocationContactVC: UIViewController
{   
    //MARK:- Properties
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLocText: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var locFlag = false
    var numberFlag = false

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPhone.text = userDetail?.phone
        lblLocation.text = userDetail?.currentAddress
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLocText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPhone.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPhone.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnSave.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtPhone.textAlignment = .right
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        if locFlag
        {
            AddsHandler.sharedInstance.address = userDetail?.currentAddress ?? ""
            self.navigationController?.popViewController(animated: true)
        }
        else if numberFlag
        {
            if !txtPhone.text!.isEmpty
            {
                AddsHandler.sharedInstance.address = txtPhone.text!
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                let alert = Constants.showBasicAlert(message: "")
                
                if languageCode == "ar"
                {
                    alert.message = "يرجى إدخال رقم الهاتف الخاص بك"
                }
                else
                {
                    alert.message = "Please enter your contact number"
                }
                
                self.presentVC(alert)
            }
        }
    }
    
    @IBAction func switchAction(switchC: UISwitch)
    {
        if switchC.tag == 1001
        {
            if switchC.isOn
            {
                locFlag = true
            }
            else
            {
                locFlag = false
            }
        }
        else
        {
            if switchC.isOn
            {
                numberFlag = true
            }
            else
            {
                numberFlag = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtPhone.resignFirstResponder()
    }
}
