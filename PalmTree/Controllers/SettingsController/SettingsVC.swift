//
//  SettingsController.swift
//  PalmTree
//
//  Created by SprintSols on 9/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var signoutView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isLogin") == false
        {
            signinView.alpha = 1
            signoutView.alpha = 0
        }
        else
        {
            signinView.alpha = 0
            signoutView.alpha = 1
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
}
