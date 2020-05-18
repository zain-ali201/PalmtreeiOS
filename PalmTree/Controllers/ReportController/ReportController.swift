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
    @IBOutlet weak var oltCancel: UIButton!{
        didSet{
            oltCancel.roundCornors()
            if let mainColor = defaults.string(forKey: "mainColor"){
                oltCancel.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var txtMessage: HoshiTextField!
    @IBOutlet weak var oltPopUp: UIButton! {
        didSet {
            oltPopUp.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var oltSend: UIButton! {
        didSet {
            oltSend.roundCornors()
            if let mainColor = defaults.string(forKey: "mainColor"){
                oltSend.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    var delegate: ReportPopToHomeDelegate?
    var dropDownArray = [String]()
    var selectedValue = ""
    var adID = 0
    let defaults = UserDefaults.standard
    
    let spamDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.spamDropDown
        ]
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleAnalytics(controllerName: "Report Controller")
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adForest_populateData()
    }

    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func spamPopUp() {
        spamDropDown.anchorView = oltPopUp
        spamDropDown.dataSource = dropDownArray
        spamDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.oltPopUp.setTitle(item, for: .normal)
            self.selectedValue = item
        }
    }
    
    func adForest_populateData() {
        if AddsHandler.sharedInstance.objReportPopUp != nil {
            let objData = AddsHandler.sharedInstance.objReportPopUp
            if let cancelButtonText = objData?.btnCancel {
                self.oltCancel.setTitle(cancelButtonText, for: .normal)
            }
            if let sendButtonText = objData?.btnSend {
                self.oltSend.setTitle(sendButtonText, for: .normal)
            }
            
            if let placeHolderText = objData?.inputTextarea {
                self.txtMessage.placeholder = placeHolderText
            }
            if let popUpButtonText = objData?.select.key {
                self.oltPopUp.setTitle(popUpButtonText, for: .normal)
            }
            if let nameText = objData?.select.name {
                self.dropDownArray = nameText
            }
            
            if defaults.bool(forKey: "isRtl") {
                oltPopUp.contentHorizontalAlignment = .right
                txtMessage.textAlignment = .right
            } else {
                oltPopUp.contentHorizontalAlignment = .left
                txtMessage.textAlignment = .left
            }
            
            self.spamPopUp()
        }
        else {
            print("Empty Data")
        }
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
        
        if message == "" {
             self.txtMessage.shake(6, withDelta: 10, speed: 0.06)
        }
        else if selectedValue == "" {
            
        }
        else {
            let param: [String: Any] = ["ad_id": adID, "option": selectedValue, "comments": message]
            print(param)
            self.adForest_reportAdd(parameter: param as NSDictionary)
        }
    }
    
    //MARK:- API Calls
    func adForest_reportAdd(parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.reportAdd(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.dismissVC(completion: {
                        self.delegate?.moveToHome(isMove: true)
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
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
