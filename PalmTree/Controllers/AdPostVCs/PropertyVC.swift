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
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Property Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            flatBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            houseBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            otherBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            agencyBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            privateBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblRequired.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblProperty.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSeller.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtBedrooms.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtBedrooms.textAlignment = .right
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtBedrooms.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
