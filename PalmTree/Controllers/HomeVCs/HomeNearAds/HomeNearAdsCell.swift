//
//  HomeNearAdsCell.swift
//  PalmTree
//
//  Created by SprintSols on 21/06/2018.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol LocationCategoryDelegate {
    func goToCLocationDetail(id: Int)
}


class HomeNearAdsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var oltViewAll: UIButton! {
        didSet {
            oltViewAll.roundCornors(radius: 5)
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    
    
    //MARK:- Properties
    var delegate : LocationCategoryDelegate?
    var dataArray = [CatLocation]()
    
    var btnViewAction : (()->())?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    //MARK:- Collection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeNearAdsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNearAdsCollectionCell", for: indexPath) as! HomeNearAdsCollectionCell
        let objData = dataArray[indexPath.row]
        
        if let name = objData.name {
            cell.lblName.text = name
        }
        if let totalAds = objData.count {
            cell.lblAds.text = totalAds
        }
        if let imgUrl = URL(string: objData.img.encodeUrl()){
            cell.imgPicture.sd_setShowActivityIndicatorView(true)
            cell.imgPicture.sd_setIndicatorStyle(.gray)
            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
        }
        cell.btnFullAction = { () in
            
             self.delegate?.goToCLocationDetail(id: objData.catId)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 170, height: 140)
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
        self.btnViewAction?()
    }
}

class HomeNearAdsCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var smallView: UIView!{
        didSet{
            smallView.addShadowToView()
            smallView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imgContainer: UIView!{
        didSet{
            imgContainer.addShadowToView()
            imgContainer.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAds: UILabel!
    
    //MARK:- Properties
    var btnFullAction: (()->())?
    
    //MARK:- IBActions
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
