//
//  ReportController.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import TextFieldEffects
import DropDown
import NVActivityIndicatorView
import UITextField_Shake

protocol ReportPopToHomeDelegate {
    func moveToHome(isMove: Bool)
}

class ReportController: UIViewController , NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var containerViewImg: UIView! {
        didSet {
            containerViewImg.circularView()
        }
    }
    @IBOutlet weak var oltCancel: UIButton!
    @IBOutlet weak var txtMessage: HoshiTextField!
    @IBOutlet weak var oltPopUp: UIButton! {
        didSet {
            oltPopUp.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var oltSend: UIButton! 
    
    //MARK:- Properties
    var delegate: ReportPopToHomeDelegate?
    var dropDownArray = ["Spam", "Offensive", "Duplicate", "Fake"]
    var selectedIndex = -1
    var adID = 0
    let defaults = UserDefaults.standard
    
    let spamDropDown = DropDown()
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleAnalytics(controllerName: "Report Controller")
        self.hideKeyboard()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.populateData()
    }

    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func spamPopUp() {
    
        if languageCode == "ar"
        {
            dropDownArray = ["بريد مؤذي", "هجومي", "مكرر", "مزورة"]
        }
        
        spamDropDown.anchorView = oltPopUp
        spamDropDown.bottomOffset = CGPoint(x: 0, y:(spamDropDown.anchorView?.plainView.bounds.height)!)
        spamDropDown.dataSource = dropDownArray
        
        spamDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.oltPopUp.setTitle(item, for: .normal)
            self.selectedIndex = index
        }
    }
    
    func populateData() {
        self.spamPopUp()
    }
    
    //MARK:- IBActions
    @IBAction func actionPopUp(_ sender: Any) {
        spamDropDown.show()
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func actionSend(_ sender: Any) {
        
        guard let message = txtMessage.text else {
            return
        }
        
        if message == ""
        {
             self.txtMessage.shake(6, withDelta: 10, speed: 0.06)
        }
        else if selectedIndex < 0
        {
            var msg = "Please select option"
            
            if languageCode == "ar"
            {
                msg = "يرجى تحديد الخيا"
            }
            
            self.showToast(message: msg)
        }
        else
        {
            var selectedValue = ""
            
            if selectedIndex == 0
            {
                selectedValue = "Spam"
            }
            else if selectedIndex == 1
            {
                selectedValue = "Offensive"
            }
            else if selectedIndex == 2
            {
                selectedValue = "Duplicate"
            }
            else if selectedIndex == 3
            {
                selectedValue = "Fake"
            }
            
            let param: [String: Any] = ["ad_id": adID, "type": selectedValue, "message": message, "user_id" : userDetail?.id ?? 0]
            print(param)
            self.reportAdd(parameter: param as NSDictionary)
        }
    }
    
    //MARK:- API Calls
    func reportAdd(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.reportAdd(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.dismissVC(completion: {
                        self.navigationController?.popToViewController(homeVC, animated: true)
                    })
                })
                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: NSLocalizedString(String(format: "something_%@", languageCode), comment: ""))
            self.presentVC(alert)
        }
    }
}
