//
//  SearchAutoCompleteTextField.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker


protocol SearchAutoDelegate {
    func searchAutoValue(searchAuto: String, fieldType: String, indexPath: Int,fieldTypeName:String)
}

class SearchAutoCompleteTextField: UITableViewCell, UITextFieldDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var txtAutoComplete: UITextField! {
        didSet {
            txtAutoComplete.delegate = self
        }
    }
    
    //MARK:- Properties
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var fieldName = ""
    var delegate : SearchAutoDelegate?
    var index = 0
    var fieldTypeNam = ""
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        if UserDefaults.standard.bool(forKey: "isRtl") {
           txtAutoComplete.textAlignment = .right
        } else {
            txtAutoComplete.textAlignment = .left
        }
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    //MARK:- Text Field Delegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = GMSAutocompleteViewController()
        searchVC.delegate = self
        self.window?.rootViewController?.present(searchVC, animated: true, completion: nil)
    }
    
    // Google Places Delegate Methods
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place Name : \(place.name)")
        print("Place Address : \(place.formattedAddress ?? "null")")
        txtAutoComplete.text = place.formattedAddress
        self.delegate?.searchAutoValue(searchAuto:txtAutoComplete.text! , fieldType: "glocation_textfield", indexPath: index,fieldTypeName:fieldTypeNam)
        self.appDel.dissmissController()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.appDel.dissmissController()
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.appDel.dissmissController()
    }
}
