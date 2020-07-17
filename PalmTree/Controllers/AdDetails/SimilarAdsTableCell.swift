//
//  SimilarAdsTableCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol SimilarAdsDelegate {
    func goToDetailAd(id: Int)
}


class SimilarAdsTableCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource  = self
            
        }
    }
    
    //MARK:- Properties
    var delegate: SimilarAdsDelegate?
    var relatedAddsArray = [AddDetailRelatedAd]()
    

    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedAddsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SimilarAdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarAdsCell", for: indexPath) as! SimilarAdsCell
        
        let objData = relatedAddsArray[indexPath.row]
        
        for images in objData.adImages {
            if let imgUrl = URL(string: images.thumb) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        if let title = objData.adTitle {
            cell.lblName.text = title
        }
        
        if let locationTitle = objData.adLocation.address {
            cell.lblLocation.text = locationTitle
        }
        
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
    
        cell.btnActionFull = { () in
            self.delegate?.goToDetailAd(id: objData.adId)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 205)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
