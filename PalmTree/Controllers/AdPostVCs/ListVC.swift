//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    //MARK:- Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelect: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Properties
    var dataArray: [String] = [String]()
    var filteredArray = [String]()
    
    var fromInd = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = fromInd
        
        if fromInd == "Make"
        {
            dataArray = ["Abarth", "AC", "Aixam", "Alfa Romeo", "Asia", "Aston Martin", "Audi", "Austin", "Bedford", "Bentley", "BMC", "BMW", "Bristol", "Caterham", "Chevrolet", "Chrysler", "Citroen", "Coleman Milne", "Corvette", "Dacia", "Daewoo", "DAF Trucks", "Daihatsu", "Daimler", "DE Tomaso", "Dodge", "Eagle", "Ebro", "EF", "F.S.O.", "Farbio", "FBS", "Ferrari", "Fiat", "Foden", "Ford", "Great Wall", "Honda", "Hummer", "Hundai", "Infiniti", "Invicta", "Isuzu", "Isuzu Trucks", "Iveco", "Jaguar", "Jeep", "Jensen", "Kia", "KTM", "Lada", "Lamborghini", "Lancia", "Land Rover", "LDV", "Lexus", "Ligier", "Lotus", "LTI", "MAN", "Marcos", "Marlin", "Maserati", "Maybach", "Mazda", "Mclaren", "Mercedes-Benz", "MG", "MG Motor UK", "MIA", "Microcar", "Mini", "Mitsubishi", "Mitsubishi CV", "Mitsubishi Fuso", "Norgan", "Nissan", "Noble", "Opel", "Perodua", "Peugeot", "PGO", "Piaggio", "Porche", "Prindiville", "Proton", "Reliant", "Renault", "Renault Trucks", "Rolls-Royce", "Rover", "Saab", "SAN", "Scania", "Seat", "Seddon Atkinson", "Skoda", "Smart", "Ssangyong", "Subaru", "Suzuki", "Talbot", "Tata", "TD Cars", "Tesla", "Toyota", "TVR", "Vauxhall", "Volkswagen", "Volvo", "Westfield", "Yugo", "Other"]
        }
        else if fromInd == "Body type"
        {
            dataArray = ["Any", "Car Derived Van", "Convertible", "Coupe", "Estate", "Hatchback", "Light 4x4 Utility", "Minibus", "Motor Caravan", "MPV", "Panel Van", "Saloon", "Sports", "Window Van", "3 Door Hatchback", "2 Door Hatchback", "5 Door Hatchback", "4 Door Hatchback", "Other"]
        }
        else if fromInd == "Fuel Type"
        {
            dataArray = ["Any", "Diesel", "Electric", "Gas", "Gas Bi Fuel", "Hybrid Electric", "Petrol", "Petrol/Gas", "Other"]
        }
        else if fromInd == "Transmission"
        {
            dataArray = ["Any", "Automatic", "Manual", "Semi-Auto", "Other"]
        }
        else if fromInd == "Colour"
        {
            dataArray = ["Any", "Biege", "Black", "Blue", "Bronze", "Brown", "Cream", "Gold", "Green", "Grey", "Maroon", "Mauve", "Multi-Coloured", "Orange", "Pink", "Purple", "Red", "Silver", "White", "Yellow", "Other"]
        }
        else if fromInd == "Property type"
        {
            dataArray = ["Apartment", "Barn", "Boat", "Bungalow", "Cabin", "Carvan", "Castle", "Chalet", "Cottage", "Farmhouse", "Home", "Lodge", "Mobile Home", "Villa", "Yacht"]
        }
        
        filteredArray = dataArray
        
        tblView.reloadData()
        self.googleAnalytics(controllerName: "List Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSelect.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
    
    @IBAction func textFiledDidChange(_ textFiled : UITextField)
    {
        if textFiled.text != ""
        {
            filteredArray = dataArray.filter({$0.contains(String(format: "%@",textFiled.text!))})
        }
        else
        {
            filteredArray = dataArray
        }
        
        tblView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtSearch.resignFirstResponder()
    }
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let title = filteredArray[indexPath.row]
        cell.lblName.text = title
        cell.tick.alpha = 0
        
        if fromInd == "Make"
        {
            if adDetailObj.motorCatObj.make == dataArray[indexPath.row]
            {
                cell.tick.alpha = 1
            }
        }
        else if fromInd == "Body type"
        {
            if adDetailObj.motorCatObj.bodyType == dataArray[indexPath.row]
            {
                cell.tick.alpha = 1
            }
        }
        else if fromInd == "Fuel Type"
        {
            if adDetailObj.motorCatObj.fuelType == dataArray[indexPath.row]
            {
                cell.tick.alpha = 1
            }
        }
        else if fromInd == "Transmission"
        {
            if adDetailObj.motorCatObj.transmission == dataArray[indexPath.row]
            {
                cell.tick.alpha = 1
            }
        }
        else if fromInd == "Colour"
        {
            if adDetailObj.motorCatObj.colour == dataArray[indexPath.row]
            {
                cell.tick.alpha = 1
            }
        }
        else if fromInd == "Property type"
        {
            if adDetailObj.propertyCatObj.propertyType == dataArray[indexPath.row]
            {
                cell.tick.alpha = 1
            }
        }
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fromInd == "Make"
        {
            adDetailObj.motorCatObj.make = dataArray[indexPath.row]
        }
        else if fromInd == "Body type"
        {
            adDetailObj.motorCatObj.bodyType = dataArray[indexPath.row]
        }
        else if fromInd == "Fuel Type"
        {
            adDetailObj.motorCatObj.fuelType = dataArray[indexPath.row]
        }
        else if fromInd == "Transmission"
        {
            adDetailObj.motorCatObj.transmission = dataArray[indexPath.row]
        }
        else if fromInd == "Colour"
        {
            adDetailObj.motorCatObj.colour = dataArray[indexPath.row]
        }
        else if fromInd == "Property type"
        {
            adDetailObj.propertyCatObj.propertyType = dataArray[indexPath.row]
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}