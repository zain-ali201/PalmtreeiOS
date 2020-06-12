//
//  PublicUserRatingController.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PublicUserRatingController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "ReplyCell", bundle: nil), forCellReuseIdentifier: "ReplyCell")
            tableView.register(UINib(nibName: "AdRatingCell", bundle: nil), forCellReuseIdentifier: "AdRatingCell")
            tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        }
    }
    
    //MARK:- Properties
    var adAuthorID = ""
    var dataArray = [UserPublicRate]()
    var replyArray = [UserPublicReply]()
    var isShowForm = false
    
    //MARK:- View Life Cyce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        let param: [String: Any] = ["author_id": adAuthorID]
        print(param)
        self.ratingData(param: param as NSDictionary)
    }

    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataArray.count
        case 1:
            return replyArray.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell: ReplyCell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
            let objData = dataArray[indexPath.row]
            if let imgUrl = URL(string: objData.img) {
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
            if let comment = objData.comments {
                cell.lblReply.text = comment
            }
            if let rating = objData.stars {
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.settings.fillMode = .precise
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
                cell.ratingBar.rating = Double(rating)!
            }
            if objData.canReply {
                if let replyText = objData.replyTxt {
                    cell.oltReply.setTitle(replyText, for: .normal)
                }
                cell.btnReplyAction = { () in
                    let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyCommentController") as! ReplyCommentController
                    commentVC.modalPresentationStyle = .overCurrentContext
                    commentVC.modalTransitionStyle = .flipHorizontal
                    commentVC.isFromUserRating = true
                    commentVC.comment_id = objData.replyId
                    self.presentVC(commentVC)
                }
            } else {
                cell.oltReply.isHidden = true
            }
          
            return cell
            
        case 1:
            let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let objData = replyArray[indexPath.row]
            
            if let name = objData.name {
                cell.lblName.text = name
            }
            if let date = objData.date {
                cell.lblDate.text = date
            }
            if let msg = objData.comments {
                cell.lblReply.text = msg
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            return cell
        case 2:
            if isShowForm {
                let cell: AdRatingCell = tableView.dequeueReusableCell(withIdentifier: "AdRatingCell", for: indexPath) as! AdRatingCell
                let objData = AddsHandler.sharedInstance.userRatingForm
                
                if let rateTitle = objData?.title {
                    cell.lblTitle.text = rateTitle
                }
                if let tagLine = objData?.tagline {
                    cell.lblNotEdit.text = tagLine
                }
                if let btnTitle = objData?.btn {
                    cell.oltSubmitRating.setTitle(btnTitle, for: .normal)
                }
                if let placeHolder = objData?.textareaText {
                    cell.txtComment.placeholder = placeHolder
                }
                cell.btnSubmitAction = { () in
                    guard let comment = cell.txtComment.text else {return}
                    if comment == "" {
                        cell.txtComment.shake(6, withDelta: 10, speed: 0.06)
                    } else {
                        let param: [String: Any]  =  ["author_id": self.adAuthorID, "ratting": cell.rating,"comments": comment, "is_reply": false]
                        print(param)
                        self.rating(param: param as NSDictionary)
                        cell.txtComment.text = ""
                    }
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0, 1:
            return UITableViewAutomaticDimension
        case 2:
            if isShowForm {
                return  220
            } else {
                return  0
            }
        default:
            return 0
        }
    }
    //MARK:- API Call
    func ratingData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.ratingToPublicUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.isShowForm = successResponse.data.canRate
                AddsHandler.sharedInstance.userRatingForm = successResponse.data.form
                self.dataArray = successResponse.data.rattings
                for item in successResponse.data.rattings {
                    if item.hasReply {
                        self.replyArray = [item.reply]
                    }
                }
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
    
    //MARK:- API Call
    func rating(param: NSDictionary) {
        self.showLoader()
        AddsHandler.postUserRating(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray = successResponse.data.rattings
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
