//
//  OffersonAdsDetailController.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OffersonAdsDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
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
    var ad_id = 0
    var dataArray = [OfferOnAdDetailItem]()
    var currentPage = 0
    var maximumPage = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.refreshButton()
        self.googleAnalytics(controllerName: "OffersonAdsDetailController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let param: [String: Any] = ["ad_id": ad_id]
        print(param)
        self.showLoader()
        self.adForest_getDetailsData(param: param as NSDictionary)
    }
    
    //MARK:- Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    @objc func refreshTableView() {
        let param: [String: Any] = ["ad_id": ad_id]
        print(param)
        self.refreshControl.beginRefreshing()
        self.adForest_getDetailsData(param: param as NSDictionary)
    }
    
    func refreshButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        button.addTarget(self, action: #selector(onClickRefreshButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func onClickRefreshButton() {
        let param: [String: Any] = ["ad_id": ad_id]
        print(param)
        self.showLoader()
        self.adForest_getDetailsData(param: param as NSDictionary)
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
        if let imgUrl = URL(string: objData.messageAdImg) {
            cell.imgPicture.sd_setIndicatorStyle(.gray)
            cell.imgPicture.sd_setShowActivityIndicatorView(true)
            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
        }
        if let name = objData.messageAuthorName {
            cell.lblName.text = name
        }
        if let title = objData.messageAdTitle {
            cell.lblDetail.text = title
        }
        
        if objData.messageReadStatus == true {
            cell.imgBell.image = UIImage(named: "bell")
        } else {
            let image = UIImage(named: "bell")
            let tintImage = image?.tint(with: UIColor.red)
            cell.imgBell.image = tintImage
            cell.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.messageCellColor)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = dataArray[indexPath.row]
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatController") as! ChatController
        chatVC.ad_id = String(objData.adId)
        chatVC.sender_id = objData.messageSenderId
        chatVC.receiver_id = objData.messageReceiverId
        chatVC.messageType = "receive"
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
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            self.showLoader()
            self.adForest_loadMoreData(param: param as NSDictionary)
        }
    }
    
    //MARK:- API Call
    func adForest_getDetailsData(param: NSDictionary) {
        UserHandler.getOfferAddDetail(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.title = successResponse.extra.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.receivedOffers.items
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
    
    func adForest_loadMoreData(param: NSDictionary) {
        UserHandler.getOfferAddDetail(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.receivedOffers.items)
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
