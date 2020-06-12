//
//  Stats.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class Stats: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
     //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    @IBOutlet weak var lblNoData: UILabel! {
        didSet {
            lblNoData.isHidden = true
        }
    }
    //MARK:- Properties
    var dataArray = [TopBidders]()
    var bidsData = AddsHandler.sharedInstance.objAdBids
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        self.googleAnalytics(controllerName: "Stats Controller")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.populatedata()
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
     func populatedata() {
         self.dataArray = AddsHandler.sharedInstance.TopBiddersArray
        
        if dataArray.count == 0 {
            self.tableView.isHidden = true
            self.lblNoData.isHidden = false
            self.lblNoData.text = AddsHandler.sharedInstance.statsNoDataTitle
        }
        else {
            self.tableView.isHidden = false
            self.dataArray = AddsHandler.sharedInstance.TopBiddersArray
            self.tableView.reloadData()
        }
    }
  
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatsCell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
        let objData = dataArray[indexPath.row]
   
        print(objData.name)
        if let imgUrl = URL(string: objData.profile) {
            cell.imgProfile.sd_setIndicatorStyle(.gray)
            cell.imgProfile.sd_setShowActivityIndicatorView(true)
            cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
        }
        if let name = objData.name {
            cell.lblName.text = name
        }
        if let date = objData.date {
            cell.lblDate.text = date
        }
        if let price = objData.price {
            cell.lblPrice.text = price
        }
        if let offerBy = objData.offerBy {
            cell.lblOffer.text = offerBy
        }
        
        cell.lblNumber.text = String(indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK:- API Calls


}
extension Stats: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let title = AddsHandler.sharedInstance.statTitle
        return IndicatorInfo(title: title)
    }
}
