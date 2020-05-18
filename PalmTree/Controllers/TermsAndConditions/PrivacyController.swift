//
//  TermsConditionsController.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PrivacyController: UIViewController {


    //MARK:- Outlets
    @IBOutlet weak var webView: UIWebView!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: "www.google.com")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK:- IBActions
   
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
