//
//  BlockedUserChatViewController.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import XLPagerTabStrip

class BlockedUserChatViewController: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
     var dataArray = [BlockedUserChatListData]()
     var senderId = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         //getBlockedUsersChatList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getBlockedUsersChatList()
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }

    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BlockedUserChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserChatTableViewCell", for: indexPath) as! BlockedUserChatTableViewCell
        let objData = dataArray[indexPath.row]
        
        if let imgUrl = URL(string: objData.userImg) {
            cell.imgProfile.sd_setShowActivityIndicatorView(true)
            cell.imgProfile.sd_setIndicatorStyle(.gray)
            cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if let name = objData.userName {
            cell.lblName.text = name
        }
        cell.lblLocation.text = objData.block_time
        cell.oltUnBlock.tag = Int(objData.recvId)!
        
        cell.oltUnBlock.addTarget(self, action:  #selector(BlockedUserChatViewController.unblock), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    @objc func unblock(_ sender: UIButton){
        
        let parameter : [String: Any] = ["sender_id":senderId , "recv_id": sender.tag]
        print(parameter)
        UnblockUserChat(parameters: parameter as NSDictionary)

    }
    
    func UnblockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.UnblockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //self.getBlockedUsersChatList()
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func getBlockedUsersChatList() {
        self.showLoader()
        UserHandler.blockedUsersChatList(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success{
                if successResponse.success == true{
                    for ob in successResponse.data{
                        self.senderId = ob.senderId
                    }
                    self.dataArray = successResponse.data
                }
                
                if self.dataArray.count == 0 {
                    self.tableView.setEmptyMessage(successResponse.message)
                }else{
                    self.tableView.setEmptyMessage("")
                }
            
                self.tableView.reloadData()
            }
            else {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
}

extension BlockedUserChatViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let pageTitle = "Blocked"
        return IndicatorInfo(title: pageTitle)
    }
}
