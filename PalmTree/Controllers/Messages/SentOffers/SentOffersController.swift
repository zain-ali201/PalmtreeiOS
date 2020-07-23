//
//  SentOffersController.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class SentOffersController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.addSubview(refreshControl)
            tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
        }
    }
    
    //MARK:- Properties
    var dataArray = [SentOffersItem]()
    var defaults = UserDefaults.standard
    var currentPage = 0
    var maximumPage = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        if let mainColor = defaults.string(forKey: "mainColor") {
            refreshControl.tintColor = Constants.hexStringToUIColor(hex: mainColor)
        }
        return refreshControl
    }()
    
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Google Analytics Track data
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Sent Offers")
        guard let builder = GAIDictionaryBuilder.createScreenView() else {return}
        tracker?.send(builder.build() as [NSObject: AnyObject])
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sentOffersData()
        self.showLoader()
    }
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    @objc func refreshTableView() {
        self.refreshControl.beginRefreshing()
        self.sentOffersData()
    }
    
    //MARK:- table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        
        let objData = dataArray[indexPath.row]
        
        
        if let title = objData.messageAuthorName {
            cell.lblName.text = title
        }
        
        if let name = objData.messageAdTitle {
            cell.lblDetail.text = name
        }
        
        for item in objData.messageAdImg {
            if let imgUrl = URL(string: item.thumb) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        if objData.messageReadStatus == true {
            cell.imgBell.isHidden = true
        } else {
            cell.imgBell.image = UIImage(named: "bell")
            cell.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.messageCellColor)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = dataArray[indexPath.row]
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatController") as! ChatController
        chatVC.ad_id = objData.adId
        chatVC.sender_id = objData.messageSenderId
        chatVC.receiver_id = objData.messageReceiverId
        chatVC.messageType = "sent"
        chatVC.isBlocked = objData.is_block
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage += 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            self.loadMoreData(param: param as NSDictionary)
            self.showLoader()
        }
    }
    
    
    //MARK:- API Calls
    func sentOffersData() {
        UserHandler.getSentOffersData(success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.sentOffers.items
                
                if successResponse.message != nil{
                    if self.dataArray.count == 0 {
                        
                        self.tableView.setEmptyMessage(successResponse.message)
                    }else{
                        self.tableView.setEmptyMessage("")
                    }
                }
        
                self.tableView.reloadData()
            } else {
                if successResponse.data.isRedirec == true{
                    let alert  = UIAlertController(title: successResponse.message, message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style:.default, handler: { (ok) in
                    self.appDelegate.moveToProfile()
                        
                    })
                    alert.addAction(okAction)
                    self.presentVC(alert, completion: nil)
                }
                else{
                    let alert = Constants.showBasicAlert(message: successResponse.message)
                    self.presentVC(alert)
                }
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func loadMoreData(param: NSDictionary) {
        UserHandler.moreSentOffersData(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.sentOffers.items)
                self.tableView.reloadData()
            } else {
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

extension SentOffersController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        var pageTitle = ""
        if let title = self.defaults.string(forKey: "sentOffers") {
            pageTitle = title
        }
        return IndicatorInfo(title: pageTitle)
    }
}
