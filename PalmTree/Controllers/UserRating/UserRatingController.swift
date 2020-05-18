//
//  UserRatingController.swift
//  PalmTree
//
//  Created by SprintSols on 3/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos
import NVActivityIndicatorView

class UserRatingController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: ReplyCell.className, bundle: nil), forCellReuseIdentifier: ReplyCell.className)
            tableView.register(UINib(nibName: CommentCell.className, bundle: nil), forCellReuseIdentifier: CommentCell.className)
        }
    }
    
    @IBOutlet weak var lblNoData: UILabel! {
        didSet {
            lblNoData.isHidden = true
        }
    }
    
    
    //MARK:- Properties
    
   // var dataArray = [UserRatingData]()
    var ratingArray = [UserRatings]()
    var replyArray = [UserRatingReply]()
    var noRatingTitle = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.googleAnalytics(controllerName: "User Rating Controller")
        self.adForest_userRatingData()
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
        var rows = 0
        
        if ratingArray.count == 0 {
            self.tableView.isHidden = true
            self.lblNoData.isHidden = false
            self.lblNoData.text = self.noRatingTitle
        }
        else {
            if section == 0 {
                self.tableView.isHidden = false
                rows = ratingArray.count
            }
            else if section == 1 {
                if replyArray.isEmpty {
                    rows = 0
                }
                else {
                    self.tableView.isHidden = false
                    rows = replyArray.count
                }
            }
        }
       return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let section = indexPath.section
        if section == 0 {
            let cell: ReplyCell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
            let objData = ratingArray[indexPath.row]
            
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.name {
                cell.lblName.text = name
            }
            if let rating = objData.stars {
                cell.ratingBar.rating = Double(rating)!
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.settings.fillMode = .precise
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: "#ffcc00")
            }
            if let date = objData.date {
                cell.lblDate.text = date
            }
            if let message = objData.comments {
                cell.lblReply.text = message
            }
            if let replyButtonText = objData.replyTxt {
                cell.oltReply.setTitle(replyButtonText, for: .normal)
            }
            if objData.canReply {
                cell.oltReply.isHidden = false
                cell.btnReplyAction = { () in
                    let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyCommentController") as! ReplyCommentController
                    commentVC.modalPresentationStyle = .overCurrentContext
                    commentVC.modalTransitionStyle = .flipHorizontal
                    commentVC.isFromReplyComment = true
                    self.presentVC(commentVC)
                }
            }
            else {
                cell.oltReply.isHidden = true
            }
            return cell
        }
     
        else if section == 1 {
            let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let objData = replyArray[indexPath.row]
            
            if let imgUrl = URL(string: objData.img) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.name {
                cell.lblName.text = name
            }
            if let msg = objData.comments {
                cell.lblReply.text = msg
            }
            if let date = objData.date {
                cell.lblDate.text = date
            }
            return cell
        }
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height : CGFloat = 0.0
        if section == 0 {
            height =  UITableViewAutomaticDimension
        }
        else if section == 1 {
            height = UITableViewAutomaticDimension
        }
        return height
    }

    //MARK:- API Calls
    
    func adForest_userRatingData() {
        self.showLoader()
        UserHandler.userProfileRating(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.noRatingTitle = successResponse.message
                self.ratingArray = successResponse.data.rattings
                
                for items in successResponse.data.rattings {
                    if items.hasReply {
                       self.replyArray = [items.reply]
                    }
                }
                self.tableView.reloadData()
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


//MARK:- Client Cell Class
class ClientCell : UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView! {
        didSet {
            imgPicture.round()
        }
    }
    
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var imgCalendar: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    //MARK:- Properties
    
    var reply: (() ->())?
    
    
    //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func actionReply(_ sender: Any) {
        reply?()
        print("Reply Clicked")
    }
}
