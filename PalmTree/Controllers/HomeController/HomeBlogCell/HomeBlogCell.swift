//
//  HomeBlogCell.swift
//  PalmTree
//
//  Created by SprintSols on 21/06/2018.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol BlogDetailDelegate {
    func blogPostID(ID: Int)
}

class HomeBlogCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var oltViewAll: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    var delegate: BlogDetailDelegate?
    var btnViewAll : (()->())?
    var dataArray = [HomeBlog]()
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
      selectionStyle = .none
    }

    //MARK:- Collection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeBlogCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBlogCollectionCell", for: indexPath) as! HomeBlogCollectionCell
        let objData = dataArray[indexPath.row]
        
        var hasImg = false
        if let img = objData.hasImage {
            hasImg = img
        }
        if  hasImg {
            if let imgUrl = URL(string: objData.image.encodeUrl()){
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        else if hasImg == false {
            cell.imgPicture.image = #imageLiteral(resourceName: "placeholder")
        }
        if let name = objData.title {
            cell.lblName.text = name
        }
        
        if let date = objData.date {
            cell.lblPrice.text = date
        }
        for item in objData.cats {
            if let category = item.name {
                cell.lblLocation.text = category
            }
        }
        cell.btnFullAction = { () in
            self.delegate?.blogPostID(ID: objData.postId)
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
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
    
    
    //MARK:- IBOutlets
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}

class HomeBlogCollectionCell : UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    //MARK:- Properties
    var btnFullAction: (()->())?
    
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
    }
    
}
