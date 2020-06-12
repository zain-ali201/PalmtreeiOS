//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController{

    //MARK:- Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var summaryBtn: UIButton!
    @IBOutlet weak var specsBtn: UIButton!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var lblSummary: UILabel!
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.googleAnalytics(controllerName: "Watchlist Controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: 0, height: 900)
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            self.leading.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            summaryBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            specsBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
            
            lblSummary.text = "Renault Megane 1.5dCi FAP Daynmique Tom \n\nBody work is not perfect but its ok hence low price...\n\nAny other information drop me s message"
        }
        else
        {
            leading.constant = screenWidth/2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            specsBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            summaryBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
            lblSummary.text = "Lorem ipsum dolor sit amet."
        }
    }
    
    @IBAction func chatBtnAction(_ button: UIButton)
    {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func callBtnAction(_ button: UIButton)
    {
        if let phoneURL = URL(string: ("tel://0123456789"))
        {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func whatsappBtnAction(_ button: UIButton)
    {
        let whatsappURL = URL(string: "whatsapp://send?text=Hello")
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        }
    }
}
