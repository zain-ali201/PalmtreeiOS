//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FilterVC: UIViewController{

    //MARK:- Outlets
    
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSortOptions: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var lblSortType: UILabel!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnImages: UIButton!
    @IBOutlet weak var lblRefine: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Refine Filter Controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- IBActions
    
    @IBAction func cancelBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resultBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
