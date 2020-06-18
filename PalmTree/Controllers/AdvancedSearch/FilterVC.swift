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
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Watchlist Controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
