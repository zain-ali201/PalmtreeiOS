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
        let areasVC = self.storyboard?.instantiateViewController(withIdentifier: "AreasViewController") as! AreasViewController
        
        let lblCountry = view.viewWithTag(button.tag + 1000) as? UILabel
        adDetailObj.location.country = lblCountry?.text ?? ""
        areasVC.fromInd = self.fromInd
        areasVC.countryID = button.tag
        areasVC.country = adDetailObj.location.country
        self.navigationController?.pushViewController(areasVC, animated: true)
    }
}
