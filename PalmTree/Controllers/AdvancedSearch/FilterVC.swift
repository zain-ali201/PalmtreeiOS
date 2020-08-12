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
    @IBOutlet weak var lblRefine: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    
    @IBOutlet weak var lblMotors: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var txtMinPrice: UITextField!
    @IBOutlet weak var txtMaxPrice: UITextField!
    
    @IBOutlet weak var motorsView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var lblMake: UILabel!
    @IBOutlet weak var lblBodyType: UILabel!
    @IBOutlet weak var lblFuelType: UILabel!
    @IBOutlet weak var lblTransmission: UILabel!
    @IBOutlet weak var lblColour: UILabel!
    
    @IBOutlet weak var tradeBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    
    var adFilterVC: AdFilterListVC!
    
    var categoryName = ""
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Refine Filter Controller")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lblLocation.text = userDetail?.locationName
        
        if adDetailObj.adCategory == "For Sale"
        {
            motorsView.alpha = 0
            lblMotors.alpha = 1
            resetBtn.alpha = 1
            priceView.alpha = 1
            top.constant = 100
        }
        else if adDetailObj.adCategory == "Motors"
        {
            motorsView.alpha = 1
            lblMotors.alpha = 1
            resetBtn.alpha = 0
            priceView.alpha = 1
            top.constant = 100
        }
        else
        {
            top.constant = 20
            priceView.alpha = 0
            motorsView.alpha = 0
            lblMotors.alpha = 0
            resetBtn.alpha = 1
        }
        
        if adDetailObj.sortType != ""
        {
            lblSortType.text = adDetailObj.sortType
        }
        
        if adDetailObj.adSubCategory != ""
        {
            lblCategory.text = adDetailObj.adSubCategory
        }
        else
        {
            lblCategory.text = adDetailObj.adCategory
        }
        
        if adDetailObj.motorCatObj.make != ""
        {
            lblMake.text = adDetailObj.motorCatObj.make
        }
        
        if adDetailObj.motorCatObj.bodyType != ""
        {
             lblBodyType.text = adDetailObj.motorCatObj.bodyType
        }
        
        if adDetailObj.motorCatObj.fuelType != ""
        {
             lblFuelType.text = adDetailObj.motorCatObj.fuelType
        }
        
        if adDetailObj.motorCatObj.transmission != ""
        {
             lblTransmission.text = adDetailObj.motorCatObj.transmission
        }
        
        if adDetailObj.motorCatObj.colour != ""
        {
             lblColour.text = adDetailObj.motorCatObj.colour
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- IBActions
    
    @IBAction func cancelBtnAction(_ sender: Any)
    {
        adDetailObj = AdDetailObject()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resultBtnAction(_ sender: Any)
    {
        if priceView != nil
        {
            if txtMinPrice.text != ""
            {
                adDetailObj.minPrice = txtMinPrice.text!
            }
            
            if txtMinPrice.text != ""
            {
                adDetailObj.maxPrice = txtMaxPrice.text!
            }
        }
        
        if adDetailObj.adCategory != ""
        {
            adFilterVC.catName = adDetailObj.adCategory
            adFilterVC.categoryID = adDetailObj.catID
        }
        
        if adDetailObj.adSubCategory != ""
        {
            adFilterVC.subcatName = adDetailObj.adSubCategory
            adFilterVC.subcategoryID = adDetailObj.subcatID
        }
        
        adFilterVC.getFilteredData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sellerBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            tradeBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            privateBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            adDetailObj.motorCatObj.sellerType = "Trade"
        }
        else
        {
            privateBtn.setTitleColor(UIColor(red: 73.0/255.0, green: 207.0/255.0, blue: 5.0/255.0, alpha: 1), for: .normal)
            tradeBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            adDetailObj.motorCatObj.sellerType = "Private"
        }
    }
    
    @IBAction func sortBtnAction(_ sender: Any)
    {
        let sortVC = self.storyboard?.instantiateViewController(withIdentifier: "SortVC") as! SortVC
        self.navigationController?.pushViewController(sortVC, animated: true)
    }
    
    @IBAction func locationBtnAction(_ sender: Any)
    {
        let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @IBAction func refineBtnAction(_ sender: Any)
    {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        categoryVC.fromVC = "filter"
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @IBAction func listBtnAction(button: UIButton)
    {
        var fromInd = ""
        
        if button.tag == 1001
        {
            fromInd = "Make"
        }
        else if button.tag == 1002
        {
            fromInd = "Body type"
        }
        else if button.tag == 1003
        {
            fromInd = "Fuel Type"
        }
        else if button.tag == 1004
        {
            fromInd = "Transmission"
        }
        else if button.tag == 1005
        {
            fromInd = "Colour"
        }
        
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        listVC.fromInd = fromInd
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func resetBtnAction(_ sender: Any)
    {
        adDetailObj = AdDetailObject()
        
        if priceView != nil
        {
            txtMinPrice.text = ""
            txtMaxPrice.text = ""
        }
        
        lblSortType.text = ""
        lblCategory.text = ""
        lblMake.text = ""
        lblBodyType.text = ""
        lblFuelType.text = ""
        lblTransmission.text = ""
        lblColour.text = ""
        
    }
}
