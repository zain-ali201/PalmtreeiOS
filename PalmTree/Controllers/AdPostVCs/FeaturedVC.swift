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
    @IBOutlet weak var imgView: UIImageView!
    
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
    
    @IBOutlet weak var packageView: UIView!
    
    var amount = ""
    var days = ""

    //MARK:- Cycle
    
    override func viewDidLoad()
    {
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
            packageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        if adDetailObj.images.count > 0
        {
            imgView.image = adDetailObj.images[0]
        }
        
        lblName.text = adDetailObj.adTitle
        lblDescp.text = adDetailObj.adDesc
        lblType.text = adDetailObj.location.address
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        adDetailObj = AdDetailObject()
        let thankyouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
        self.navigationController?.pushViewController(thankyouVC, animated: true)
    }
    
    @IBAction func clickBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            packageView.alpha = 1
        }
        else
        {
            let checkoutVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            self.navigationController?.pushViewController(checkoutVC, animated: true)
        }
    }
    
    @IBAction func packageBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            amount = "3.9"
            days = "3"
        }
        else if button.tag == 1002
        {
            amount = "5.9"
            days = "5"
        }
        else if button.tag == 1003
        {
            amount = "7.9"
            days = "7"
        }
        
        let checkoutVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
    
    @IBAction func crossBtnAction(button: UIButton)
    {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        packageView.alpha = 0
    }
}
