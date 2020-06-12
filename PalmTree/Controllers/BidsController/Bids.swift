//
//  Bids.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import TextFieldEffects
import NVActivityIndicatorView

class Bids: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.isHidden = true
            tableView.backgroundColor = UIColor.groupTableViewBackground
        }
    }

    @IBOutlet weak var lblNoData: UILabel! {
        didSet {
            lblNoData.isHidden = true
        }
    }
    
    @IBOutlet weak var viewBid: UIView!
    @IBOutlet weak var lblBid: UILabel!
    
    
    //MARK:- Properties
    var dataArray = [BidsBid]()
    var isBid = true
    var defaults = UserDefaults.standard
    let bgColor = UserDefaults.standard.string(forKey: "mainColor")
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Bids Controller")
        view.backgroundColor = UIColor.groupTableViewBackground
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.NotificationName.updateBidsStats), object: nil, queue: nil) { (notification) in
            
            let data = AddsHandler.sharedInstance.objAdBids
            
            if let canBid = data?.canBid {
                self.isBid = canBid
            }
            
            self.dataArray = AddsHandler.sharedInstance.biddersArray
            
            if self.dataArray.count == 0 && self.isBid {
            
                self.tableView.isHidden = false
                self.lblNoData.isHidden = false
                self.lblNoData.text = data?.message
                self.tableView.translatesAutoresizingMaskIntoConstraints = false
                self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
                self.tableView.reloadData()
            }
                
            else if self.dataArray.count == 0 && self.isBid == false {
                self.tableView.isHidden = true
                self.lblNoData.isHidden = false
                self.lblNoData.text = data?.message
                
            }
            else {
                self.tableView.isHidden = false
                
                self.tableView.reloadData()
            }
            
            if self.isBid == true{
                self.viewBid.isHidden = true
            }else{
                
                self.viewBid.isHidden = false
                self.viewBid.backgroundColor = UIColor(hex: self.bgColor!)
                self.lblBid.text = data?.message
            }
            
            
        }
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
  
    
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
             return 1
        }
       return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell: BidsCell = tableView.dequeueReusableCell(withIdentifier: "BidsCell", for: indexPath) as! BidsCell
            let objData = dataArray[indexPath.row]
            if let imgUrl = URL(string: objData.profile) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.name {
                cell.lblName.text = name
            }
            if let date = objData.date {
                cell.lblDate.text = date
            }
            if let price = objData.price.price {
                cell.lblPrice.text = price
            }
            
            let phone = objData.phone
            if phone == "" {
                cell.imgPhone.isHidden = true
            }
            else {
                cell.imgPhone.isHidden = false
                cell.lblPhone.text = phone
            }
            
            if let msg = objData.comment {
                cell.lblMsg.text = msg
            }
            return cell
        }
        else if section == 1 {
            if self.defaults.bool(forKey: "isGuest") {
                
            }
            else {
                let cell: PostBidCell = tableView.dequeueReusableCell(withIdentifier: "PostBidCell", for: indexPath) as! PostBidCell
                
                let objData =  AddsHandler.sharedInstance.objAdBids
                
                if let bidText = objData?.data.form.bidAmount {
                    cell.txtBid.placeholder = bidText
                }
                if let commentText = objData?.data.form.bidTextarea {
                    cell.txtComment.placeholder = commentText
                }
                if let submitText = objData?.data.form.bidBtn {
                    cell.oltSubmit.setTitle(submitText, for: .normal)
                }
                
                if let infoText = objData?.data.form.bidInfo {
                    cell.lblDescription.text = infoText
                }
                
                cell.btnSubmit = { () in
                    
                    guard let bidAmount = cell.txtBid.text else {
                        return
                    }
                    guard let bidText = cell.txtComment.text else {
                        return
                    }
                    
                    if bidAmount == "" {
                        
                    }
                    else if bidText == "" {
                        
                    }
                    else {
                        let adID = AddsHandler.sharedInstance.adIdBidStat
                        print(adID)
                        let param: [String: Any] = ["ad_id": adID, "bid_amount": bidAmount  ,"bid_comment": bidText]
                        print(param)
                        self.submitBid(param: param as NSDictionary)
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat = 0.0
        if section == 0 {
            if dataArray.count == 0 && isBid == true {
                height = 0
            }
            else {
                  height =  UITableViewAutomaticDimension
            }
        }
        else if section == 1 {
            let objData =  AddsHandler.sharedInstance.objAdBids
            if objData?.canBid == false {
                height = 0
            }
            else {
            height = 300
        }
    }
        return height
    }
    
    //MARK:- API Calls
    func submitBid(param:NSDictionary) {
        self.showLoader()
        AddsHandler.postBid(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = Constants.showBasicAlert(message: successResponse.message)
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

extension Bids: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let title = AddsHandler.sharedInstance.bidTitle
        return IndicatorInfo(title: title)
    }
}



