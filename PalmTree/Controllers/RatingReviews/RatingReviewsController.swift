//
//  RatingReviewsController.swift
//  PalmTree
//
//  Created by SprintSols on 4/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyGif

class RatingReviewsController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var imgContainer: UIView! {
        didSet {
            imgContainer.circularView()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: ReplyCell.className, bundle: nil), forCellReuseIdentifier: ReplyCell.className)
//            tableView.register(UINib(nibName: CommentCell.className, bundle: nil), forCellReuseIdentifier: CommentCell.className)
            tableView.register(UINib(nibName: ReplyReactionCell.className, bundle: nil), forCellReuseIdentifier: ReplyReactionCell.className)
            
        }
    }
    @IBOutlet weak var oltLoadMore: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltLoadMore.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgRating: UIImageView!
    
    //MARK:- Properties
    var addRatingArray = [AddDetailRating]()
    var addReplyArray = [AddDetailReply]()
    var adID = 0
    var hasNextPage = false
    var nextPage = 0
    let gifManager = SwiftyGifManager(memoryLimit: 100)
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.googleAnalytics(controllerName: "Rating Reviews Controller")
        self.populateData()
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
   
    func populateData() {
        if  AddsHandler.sharedInstance.ratingsAdds != nil {
            let objData =  AddsHandler.sharedInstance.ratingsAdds
            
            if let title = objData?.sectionTitle {
//                self.title = title
                lblTitle.text = title
            }
            if let loadMoreButton = objData?.loadmoreBtn {
                oltLoadMore.setTitle(loadMoreButton, for: .normal)
            }
            if let ratingArray = objData?.ratings {
                 self.addRatingArray = ratingArray
            }
            for item in addRatingArray {
                if item.hasReply {
                    self.addReplyArray = item.reply
                }
            }
            if let hasNextPage = objData?.pagination.hasNextPage {
                self.hasNextPage = hasNextPage
            }
            if let nextPage = objData?.pagination.nextPage {
                self.nextPage = nextPage
            }
//            self.tableView.reloadData()
        }
    }
    
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addRatingArray.count
        }
        return addReplyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0 :
//            let cell: ReplyCell = tableView.dequeueReusableCell(withIdentifier: ReplyCell.className, for: indexPath) as! ReplyCell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReplyReactionCell.className, for: indexPath) as! ReplyReactionCell
            
            let objData = addRatingArray[indexPath.row]
            cell.oltReply.isHidden = true
            
            if let imgUrl = URL(string: objData.ratingAuthorImage) {
                cell.imgProfile.setImage(from: imgUrl)
            }
            if let name = objData.ratingAuthorName {
                cell.lblName.text = name
            }
            if let replyText = objData.ratingText {
                cell.lblReply.text = replyText
            }
            if let date = objData.ratingDate {
                cell.lblDate.text = date
            }
            if let ratingBar = objData.ratingStars {
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.settings.fillMode = .precise
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: "#ffcc00")
                cell.ratingBar.rating = Double(ratingBar)!
            }
            if let replyButtontext = objData.replyText {
                cell.oltReply.setTitle(replyButtontext, for: .normal)
            }
            
            cell.imgThumb.setGifImage(UIImage(gifName: "thumb"), manager: gifManager, loopCount: -1)
            cell.imgHeart.setGifImage(UIImage(gifName: "heart"), manager: gifManager, loopCount: -1)
            cell.imgWow.setGifImage(UIImage(gifName: "wow"), manager: gifManager, loopCount: -1)
            cell.imgAndry.setGifImage(UIImage(gifName: "sad"), manager: gifManager, loopCount: -1)
            if let like = objData.adReactions.like {
                cell.lblThumb.text = "\(like)"
            }
            
            if let love = objData.adReactions.love {
                cell.lblHeart.text = "\(love)"
            }
            
            if let wow = objData.adReactions.wow {
                cell.lblWow.text = "\(wow)"
            }
            
            if let sad = objData.adReactions.angry {
                cell.lblSad.text = "\(sad)"
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.className, for: indexPath) as! CommentCell
            let objData = addReplyArray[indexPath.row]
            
            if let imgUrl = URL(string: objData.ratingAuthorImage) {
                cell.imgPicture.setImage(from: imgUrl)
            }
            if let name = objData.ratingAuthorName {
                cell.lblName.text = name
            }
            if let date = objData.ratingDate {
                cell.lblDate.text = date
            }
            if let replyText = objData.ratingText {
                cell.lblReply.text = replyText
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
  
    //MARK:- IBActions
    @IBAction func actionLoadMore(_ sender: Any) {
        if self.hasNextPage {
            let param: [String: Any] = ["ad_id": 5799, "page_number": nextPage]
            print(param)
            self.loadMoreData(param: param as NSDictionary)
        }
    }
 
    //MARK:- API Call
    func loadMoreData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.addDetailRating(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.hasNextPage = successResponse.data.pagination.hasNextPage
                self.nextPage = successResponse.data.pagination.nextPage
                if self.hasNextPage == false {
                    self.oltLoadMore.isHidden = true
                }
                self.addRatingArray.append(contentsOf: successResponse.data.ratings)
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
