//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FeaturedVC: UIViewController
{
    //MARK:- Properties
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblFeatured: UILabel!
    @IBOutlet weak var lblFeaturedDescp: UILabel!
    @IBOutlet weak var lblUrgent: UILabel!
    @IBOutlet weak var lblUrgentText: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var btnSkip: UIButton!

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFeatured.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFeaturedDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUrgent.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUrgentText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblHeading.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnSkip.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
    
    @IBAction func skipBtnACtion(_ sender: Any)
    {
        let thankyouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
        self.navigationController?.pushViewController(thankyouVC, animated: true)
    }
}
