//
//  LatestAddsCell.swift
//  PalmTree
//
//  Created by SprintSols on 13/06/2018.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class LatestAddsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Outlets
    
    @IBOutlet weak var heightConstraintTitle: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.clear
            
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var oltViewAll: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    //MARK:- Properties
    var delegate : AddDetailDelegate?
    var dataArray = [HomeAdd]()
    var btnViewAll: (()->())?
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    var latestVertical: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.layoutLatest()
        self.layoutHorizontalSingleAd()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Collection View Delegate Methods
    
    func layoutHorizontalSingleAd(){
        if latestHorizontalSingleAd == "horizental" {
            //    let cellSize = CGSize(width:80 , height:180)
            
            let layout = UICollectionViewFlowLayout()
            //       layout.scrollDirection = .vertical //.horizontal
            //       layout.itemSize = cellSize
            
            //            let width = (view.frame.width-20)/2
            //            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            //layout.itemSize = CGSize(width: 334, height: 500)
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.isScrollEnabled = false
            let  height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
    }
    
    
    
    func layoutLatest(){
        if latestVertical == "vertical" {
            //    let cellSize = CGSize(width:80 , height:180)
            
            let layout = UICollectionViewFlowLayout()
            //            let layout = UICollectionViewLayout()
            
            //                   layout.scrollDirection = .vertical //.horizontal
            //       layout.itemSize = cellSize
            
            //            let width = (view.frame.width-20)/2
            //            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            //layout.itemSize = CGSize(width: 334, height: 500)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.isScrollEnabled = false
            //            let  height =   layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
            
            let  height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: LatestAddsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestAddsCollectionCell", for: indexPath) as! LatestAddsCollectionCell
        let objData = dataArray[indexPath.row]
        if latestHorizontalSingleAd == "horizental" {
            for item in objData.adImages {
                if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                    cell.imageView.sd_setShowActivityIndicatorView(true)
                    cell.imageView.sd_setIndicatorStyle(.gray)
                    cell.imageView.sd_setImage(with: imgUrl, completed: nil)

                }
            }

            if let name = objData.adTitle {
                cell.lblTitle.text = name
                let word = objData.adTimer.timer
                if objData.adTimer.isShow {
                    let first10 = String(word!.prefix(10))
                    print(first10)
                    cell.lblTimer.isHidden = true
                    cell.lblBidTimer.isHidden = false

                    if first10 != ""{
                        let endDate = first10
                        self.isEndTime = endDate
                        Timer.every(1.second) {
                            self.countDown(date: endDate)
                            cell.lblBidTimer.text = "\(self.day) : \(self.hour) : \(self.minute) : \(self.second) "

                        }
                    }
                }else{
                    cell.lblBidTimer.isHidden = true
                }

            }
            if let location = objData.adLocation.address {
                cell.lblLocs.text = location
            }
            if let price = objData.adPrice.price {
                cell.lblPriceHori.text = price
            }
            cell.btnFullAction = { () in
                self.delegate?.goToAddDetail(ad_id: objData.adId)
            }

        }  else {
            for item in objData.adImages {
                if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                }
            }
            
            if let name = objData.adTitle {
                cell.lblName.text = name
                let word = objData.adTimer.timer
                if objData.adTimer.isShow {
                    let first10 = String(word!.prefix(10))
                    print(first10)
                    cell.lblTimer.isHidden = false
                    
                    if first10 != ""{
                        let endDate = first10
                        self.isEndTime = endDate
                        Timer.every(1.second) {
                            self.countDown(date: endDate)
                            cell.lblTimer.text = "\(self.day) : \(self.hour) : \(self.minute) : \(self.second) "
                            
                        }
                    }
                }else{
                    cell.lblTimer.isHidden = true
                }
            }
            if let location = objData.adLocation.address {
                cell.lblLocation.text = location
            }
            if let price = objData.adPrice.price {
                cell.lblPrice.text = price
            }
            cell.btnFullAction = { () in
                self.delegate?.goToAddDetail(ad_id: objData.adId)
            }
            
        }
        
        
        return cell
        
        
    }
    func validateIFSC(code : String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
        return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
    }
    //MARK:- Counter
    func countDown(date: String) {
        
        let calendar = Calendar.current
        let requestComponents = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .nanosecond])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeNow = Date()
        guard let dateis = dateFormatter.date(from: date) else {
            return
        }
        let timeDifference = calendar.dateComponents(requestComponents, from: timeNow, to: dateis)
        day = timeDifference.day!
        hour = timeDifference.hour!
        minute = timeDifference.minute!
        second = timeDifference.second!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if latestVertical == "vertical" {
            return CGSize(width:collectionView.frame.width/2 , height:210)
        }else if latestHorizontalSingleAd == "horizental" {
            return CGSize(width:collectionView.frame.width,height: 120)
        }
        else{
            return CGSize(width: 170, height: 210)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}


class LatestAddsCollectionCell : UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblTimer: UILabel! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                //                       lblTimer.textColor = Constants.hexStringToUIColor(hex: mainColor)
                lblTimer.isHidden = true
            }
        }
        
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    var btnFullAction : (()->())?
    var latestHorizontalSingleAd: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var  imageView: UIImageView!
    var  imageViewLoc: UIImageView!
    var lblTitle: UILabel!
    var lblLocs: UILabel!
    var lblPriceHori: UILabel!
    var lblBidTimer:UILabel!
    var locsBtn: UIButton!
    //MARK:- IBActions
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblName.textAlignment = .right
        } else {
            lblName.textAlignment = .left
        }
        
        if latestHorizontalSingleAd == "horizental" {
            //            containerView.backgroundColor = UIColor.systemRed
            imgPicture.isHidden = true
            lblName.isHidden = true
            lblLocation.isHidden = true
            lblPrice.isHidden = true
            lblTimer.isHidden = true
            let imageName = "appLogo"
            let image = UIImage(named: imageName)
            imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 2, y: 5, width: 110, height: 110)
            contentView.addSubview(imageView)
            
            lblBidTimer = UILabel(frame: CGRect(x: 2, y: 0, width: 100, height: 28))
            lblBidTimer.textAlignment = .center
            lblBidTimer.textColor = UIColor.white
            //            lblBidTimer.text = "Bid Timer"
            lblBidTimer.backgroundColor = Constants.hexStringToUIColor(hex: "#575757")
            
            //6b6b6b
                //UIColor.black
            //                       lblTimer.textColor = Constants.hexStringToUIColor(hex: mainColor)

//
            //bottomalign label
            //            lblBidTimer.frame.origin.x = 0
            lblBidTimer.frame.origin.y = 59 + lblBidTimer.frame.height
            //
            //            lblBidTimer.frame.origin.x = imageView.frame.width + 18
            //            lblBidTimer.frame.origin.y = -8 + lblBidTimer.frame.height
            
            
            lblBidTimer.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            
            contentView.addSubview(lblBidTimer)
            lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 28))
            lblTitle.textAlignment = .left
            lblTitle.textColor = UIColor.black
            lblTitle.text = "Ad Title"
            
            //bottomalign label
            lblTitle.frame.origin.x = imageView.frame.width + 18
            lblTitle.frame.origin.y = -8 + lblTitle.frame.height
            lblTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            
            //imageView.frame.height
            //top right with x = 0
            //            label.frame.origin.y = 30
            //            label.frame.origin.x = imageView.frame.width - label.frame.width
            contentView.addSubview(lblTitle)
            
            
            let imageNameLoc = "location"
            let imageLoc = UIImage(named: imageNameLoc)
            imageViewLoc = UIImageView(image: imageLoc!)
            imageViewLoc.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            imageViewLoc.frame.origin.y = 58
            imageViewLoc.frame.origin.x = lblLocation.frame.width + (imageViewLoc.frame.width)
            contentView.addSubview(imageViewLoc)
            lblLocs = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 28))
            lblLocs.textAlignment = .left
            //                        lblLocation.backgroundColor = UIColor.blue
            lblLocs.textColor = UIColor.lightGray
            lblLocs.font = lblLocs.font.withSize(15)
            lblLocs.center.x = lblTitle.center.x - 3
            lblLocs.numberOfLines = 2
            lblLocs.frame.origin.y = lblTitle.frame.origin.y + (lblLocs.frame.height) + 6
            lblLocs.text = "Model Town Link Road Lahore Punjab Pakistan"
            contentView.addSubview(lblLocs)
            
            lblPriceHori = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 28))
            lblPriceHori.textAlignment = .left
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPriceHori.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
            
            lblPriceHori.center.x = lblTitle.center.x - 3
            lblPriceHori.frame.origin.y = imageViewLoc.frame.origin.y + (lblPriceHori.frame.height) - 10
            lblPriceHori.text = "$-223"
            contentView.addSubview(lblPriceHori)
            
            
        } else {
            imgPicture.isHidden = false
            lblName.isHidden = false
            lblLocation.isHidden = false
            lblPrice.isHidden = false
            lblTimer.isHidden = false
//            imageView.isHidden = true
//            imageViewLoc.isHidden = true
//            lblLocs.isHidden = true
//            lblPriceHori.isHidden = true
//            lblBidTimer.isHidden = true
            
        }
        
        
        
    }
    
}


