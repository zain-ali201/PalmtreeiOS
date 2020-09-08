//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CountryAreasVC: UIViewController
{   
    //MARK:- Properties
    @IBOutlet weak var lblUAE: UILabel!
    @IBOutlet weak var lblDubai: UILabel!
    @IBOutlet weak var lblAbuDhbhi: UILabel!
    @IBOutlet weak var lblSharjah: UILabel!
    @IBOutlet weak var lblAin: UILabel!
    @IBOutlet weak var lblAjmaan: UILabel!
    @IBOutlet weak var lblFujairah: UILabel!
    @IBOutlet weak var lblKhaimah: UILabel!
    @IBOutlet weak var lblQuwain: UILabel!

    var fromInd = ""
    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUAE.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDubai.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblAbuDhbhi.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSharjah.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblAin.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblAjmaan.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFujairah.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblKhaimah.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblQuwain.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickBtnAction(button: UIButton)
    {
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        listVC.fromInd = fromInd
        listVC.countryID = button.tag
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}
