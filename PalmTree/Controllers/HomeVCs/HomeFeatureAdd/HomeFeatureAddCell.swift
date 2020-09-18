//
//  HomeFeatureAddCell.swift
//  PalmTree
//
//  Created by SprintSols on 5/30/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


class HomeFeatureAddCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    //MARK:- Properties
    var delegate: AddDetailDelegate?
    var dataArray = [AdsJSON]()
    
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
    
    //MARK:- Custom
    
    @objc func scrollToNextCell() {
        let cellSize = CGSize(width: frame.width, height: frame.height)
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
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
        if latestVertical == "vertical"{
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
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  HomeFeatureCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFeatureCollectionCell", for: indexPath) as! HomeFeatureCollectionCell
        let objData = dataArray[indexPath.row]
        
            for item in objData.images {
                if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, item.url.encodeUrl())) {
                    cell.imageView.sd_setShowActivityIndicatorView(true)
                    cell.imageView.sd_setIndicatorStyle(.gray)
                    cell.imageView.sd_setImage(with: imgUrl, completed: nil)
                }
            }
            
            if let name = objData.title {
                cell.lblTitle.text = name
                
            if let location = objData.address {
                cell.lblLocs.text = location
            }
            if let price = objData.price {
                cell.lblPriceHori.text = price
            }
                
            cell.btnFullAction = { () in
                self.delegate?.goToAddDetail(ad_id: objData.id)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 170, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //        if collectionView.isDragging {
        //            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        //            UIView.animate(withDuration: 0.3, animations: {
        //                cell.transform = CGAffineTransform.identity
        //            })
        //        }
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
    
}
