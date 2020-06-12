//
//  AddsTableCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol AddDetailDelegate{
    func goToAddDetail(ad_id : Int)
}
class AddsTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var heightConstraintTitle: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var oltViewAll: UIButton! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    var locationBtnAction: (()->())?
    
    //MARK:- Properties
    
    var dataArray = [HomeAdd]()
    var delegate : AddDetailDelegate?
    
    var btnViewAll :(()->())?
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    var latestVertical: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd: String =  UserDefaults.standard.string(forKey: "homescreenLayout")!
    
    
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
    
    
    //MARK:- Custom
    
    func reloadData() {
        collectionView.reloadData()
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
            //       layout.scrollDirection = .vertical //.horizontal
            //       layout.itemSize = cellSize
            
            //            let width = (view.frame.width-20)/2
            //            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            //layout.itemSize = CGSize(width: 334, height: 500)
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.isScrollEnabled = false
            //                let  height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArray.count
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  AddsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddsCollectionCell", for: indexPath) as! AddsCollectionCell
//        let objData = dataArray[indexPath.row]
//
//        for item in objData.adImages {
//            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
//                cell.imgPicture.sd_setShowActivityIndicatorView(true)
//                cell.imgPicture.sd_setIndicatorStyle(.gray)
//                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
//            }
//        }
//
//        if let name = objData.adTitle {
//            cell.lblName.text = name
//            let word = objData.adTimer.timer
//            if objData.adTimer.isShow {
//                let first10 = String(word!.prefix(10))
//                print(first10)
//                cell.lblTimer.isHidden = false
//
//                if first10 != ""{
//                    let endDate = first10
//                    self.isEndTime = endDate
//                    Timer.every(1.second) {
//                        self.countDown(date: endDate)
//                        cell.lblTimer.text = "\(self.day) : \(self.hour) : \(self.minute) : \(self.second) "
//
//                    }
//                }
//            }else{
//                cell.lblTimer.isHidden = true
//            }
//        }
//        if let location = objData.adLocation.address {
//            cell.lblLocation.text = location
//        }
//        if let price = objData.adPrice.price {
//            cell.lblPrice.text = price
//        }
        cell.btnFullAction = { () in
//            self.delegate?.goToAddDetail(ad_id: objData.adId)
            self.delegate?.goToAddDetail(ad_id: 1)
        }
        cell.lblName.text = "Cars"
        cell.lblPrice.text = "AED 50"
        
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

        return CGSize(width:collectionView.frame.width/2 , height:240)
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
    
    
    //MARK:- IBActions
    
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
    
    @IBAction func locationBtnAction(_ sender: Any) {
        self.locationBtnAction?()
    }
}
