//
//  PackagesCell.swift
//  PalmTree
//
//  Created by SprintSols on 7/20/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown
import Popover

class PackagesCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var lblregularPrice: UILabel!
    @IBOutlet weak var imgSale: UIImageView!
    @IBOutlet weak var lblOfferName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var lblSale: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblFreeAds: UILabel!
    @IBOutlet weak var lblFeaturedAds: UILabel!
    @IBOutlet weak var lblBumpUpAds: UILabel!
    @IBOutlet weak var viewButton: UIView! {
        didSet {
            viewButton.layer.borderWidth = 0.5
            viewButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var buttonSelectOption: UIButton! {
        didSet {
            buttonSelectOption.contentHorizontalAlignment = .left
        }
    }

    @IBOutlet weak var lblAllowBidValue: UILabel!
    @IBOutlet weak var lblNumOfImgValue: UILabel!
    @IBOutlet weak var lblVidUrlVal: UILabel!
    @IBOutlet weak var lblAllowTagVal: UILabel!
    @IBOutlet weak var lblAllowCatVal: UILabel!
    
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var heightConstValid: NSLayoutConstraint!
    @IBOutlet weak var img1HeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img2HeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstFree: NSLayoutConstraint!
    
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img3HeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstFeature: NSLayoutConstraint!
    
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img4HeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstBump: NSLayoutConstraint!
    
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var heightConstBid: NSLayoutConstraint!
    @IBOutlet weak var img5HeightConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img6HeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstNumImg: NSLayoutConstraint!
    
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img7HeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstVideo: NSLayoutConstraint!
    
    
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img8HeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstTag: NSLayoutConstraint!
    
    @IBOutlet weak var img9: UIImageView!
    @IBOutlet weak var img9HightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstAllCat: NSLayoutConstraint!
    
    
    
    //MARK:- Properties
    var delegate : PaymentTypeDelegate?
    let categoryDropDown = DropDown()
    
    lazy var dropDown : [DropDown] = {
        return [
            self.categoryDropDown
        ]
    }()
    
    var dropShow: (()->())?
    var dropDownValueArray = [String]()
    var dropDownKeyArray = [String]()
    
    
    var defaults = UserDefaults.standard
    var settingObject = [String: Any]()
    var popUpMsg = ""
    var popUpText = ""
    var popUpCancelButton = ""
    var popUpOkButton = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedInAppPackage = ""
    var package_id = ""
    var catArr = [String]()
    var catNewArr = [AllowCatsValue]()
    
    
    var popover: Popover!
    var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.settingsData()
        buttonWithRtl()
        print(catNewArr)
    }
    
    @IBAction func btnMoreClicked(_ sender: UIButton) {
      
        let tableView = UITableView()
        
        let height = catNewArr.count * 47
        
        tableView.frame = CGRect(x: 0, y: 0, width: lblAllowCatVal.frame.width, height:tableView.contentSize.height + CGFloat(height))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.willShowHandler = {
            print("willShowHandler")
        }
        self.popover.didShowHandler = {
            print("didDismissHandler")
        }
        self.popover.willDismissHandler = {
            print("willDismissHandler")
        }
        self.popover.didDismissHandler = {
            print("didDismissHandler")
        }
        self.popover.show(tableView, fromView: self.btnMore)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catNewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let ob = catNewArr[indexPath.row]
        cell.textLabel?.text = ob.cat_name  // self.catArr[(indexPath as NSIndexPath).row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let allowText = UserDefaults.standard.string(forKey: "allowText")
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        
        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect.init(x: 5, y: 10, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = allowText
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    //MARK:- Custom
    
    func buttonWithRtl(){
        if UserDefaults.standard.bool(forKey: "isRtl") {
            buttonSelectOption.contentHorizontalAlignment = .right
        } else {
            buttonSelectOption.contentHorizontalAlignment = .left
        }
    }
    
    func selectCategory() {
        categoryDropDown.anchorView = buttonSelectOption
        categoryDropDown.dataSource = dropDownValueArray
        categoryDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonSelectOption.setTitle(item, for: .normal)
            let cashTypeKey = self.dropDownKeyArray[index]
            //send data to main class to send to server in alert controller action
            let alert = UIAlertController(title: self.popUpMsg, message: self.popUpText, preferredStyle: .alert)
            let okAction = UIAlertAction(title: self.popUpOkButton, style: .default, handler: { (okAction) in
                self.delegate?.paymentMethod(methodName: cashTypeKey, inAppID: self.selectedInAppPackage, packageID: self.package_id)
            })
            let cancelAction = UIAlertAction(title: self.popUpCancelButton, style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.appDelegate.presentController(ShowVC: alert)
        }
    }
    
    func settingsData() {
        if let settingsInfo = defaults.object(forKey: "settings") {
            settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
            
            let model = SettingsRoot(fromDictionary: settingObject)
            
            if let dialogMSg = model.data.dialog.confirmation.title {
                self.popUpMsg = dialogMSg
            }
            if let dialogText = model.data.dialog.confirmation.text {
                self.popUpText = dialogText
            }
            if let cancelText = model.data.dialog.confirmation.btnNo {
                self.popUpCancelButton = cancelText
            }
            if let confirmText = model.data.dialog.confirmation.btnOk {
                self.popUpOkButton = confirmText
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionSelectOption(_ sender: Any) {
        dropShow?()
    }
}

