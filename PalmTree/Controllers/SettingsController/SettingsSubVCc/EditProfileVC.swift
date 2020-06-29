//
//  TermsConditionsController.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {


    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmailText: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPwdText: UILabel!
    
    @IBOutlet weak var lblContactDetails: UILabel!
    @IBOutlet weak var lblNumberText: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblEmail1Text: UILabel!
    @IBOutlet weak var lblEmail1: UILabel!
    @IBOutlet weak var lblNameText: UILabel!
    @IBOutlet weak var lblDisplayName: UILabel!
    
    @IBOutlet weak var editBtn1: UIButton!
    @IBOutlet weak var editBtn2: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmailText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPwdText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblContactDetails.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblNumberText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail1Text.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblNameText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            editBtn1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            editBtn2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
           
            lblName.textAlignment = .right
            lblNumber.textAlignment = .right
            lblEmail.textAlignment = .right
            lblEmail1.textAlignment = .right
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- IBActions
   
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
