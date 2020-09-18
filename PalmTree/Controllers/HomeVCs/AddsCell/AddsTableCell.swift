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
    func goToAddDetailVC(detail : AdsJSON)
    func addToFavourites(ad_id : Int)
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
    @IBOutlet weak var lblJust: UILabel!
    @IBOutlet weak var locBtn: UIButton!
    
    var locationBtnAction: (()->())?
    
    //MARK:- Properties
    
    var dataArray = [AdsJSON]()
    var delegate : AddDetailDelegate?
    
    var btnViewAll :(()->())?
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        selectionStyle = .none
        
        if languageCode == "ar"
        {
            lblSectionTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblJust.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            locBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK:- Custom
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  AddsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddsCollectionCell", for: indexPath) as! AddsCollectionCell
        let objData = dataArray[indexPath.row]

        cell.imgPicture.image = UIImage(named: "placeholder")
        
        for item in objData.images {
            if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, item.url.encodeUrl())) {
                print(imgUrl)
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }

        if let name = objData.title {
            cell.lblName.text = name
        }
        
        if let price = objData.price {
            cell.lblPrice.text = String(format: "AED %@", price) 
        }
        
        if defaults.bool(forKey: "isLogin") == true
        {
            if objData.is_favorite
            {
                cell.favBtn.setImage(UIImage(named: ""), for: .normal)
            }
        }
        
        cell.btnFullAction = { () in
            self.delegate?.goToAddDetailVC(detail: objData)
        }
        
        cell.favBtnAction = { () in
            self.delegate?.addToFavourites(ad_id: objData.id)
        }
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
