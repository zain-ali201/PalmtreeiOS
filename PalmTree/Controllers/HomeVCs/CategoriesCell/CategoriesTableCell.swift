//
//  CategoriesTableCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol CategoryDetailDelegate {
    func goToCategoryDetail()
    func goToAdFilterListVC(cat_id: Int, catName: String)
}

class CategoriesTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    //MARK:- Properties
    var categoryArray = [CategoryJSON]()
    var delegate : CategoryDetailDelegate?
    var btnViewAll: (()->())?
    
    var numberOfColums: CGFloat = 0
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        collectionView!.collectionViewLayout = layout
        
        setLayout()
    }
    
    func setLayout()
    {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isScrollEnabled = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }

    //MARK:- Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if categoryArray.count > 0
        {
            count = categoryArray.count + 1
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CategoriesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        
        if indexPath.row == categoryArray.count
        {
            if languageCode == "ar"
            {
                cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                cell.lblName.text = "المزيد"
            }
            else
            {
                cell.lblName.text = "More"
            }
            
            cell.imgPicture.image = UIImage(named: "more")
            
            cell.btnFullAction = { () in
                self.delegate?.goToCategoryDetail()
            }
        }
        else
        {
            let objData = categoryArray[indexPath.row]
        
            if let name = objData.name
            {
                if languageCode == "ar"
                {
                    cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    cell.lblName.text = name
                }
                else
                {
                    cell.lblName.text = name
                }
                
                if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, objData.imgUrl.encodeUrl())) {
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                }
            }
            
            cell.btnFullAction = { () in
                self.delegate?.goToAdFilterListVC(cat_id: objData.id, catName: objData.name)
                if var recentList = UserDefaults.standard.array(forKey: "recentList") as? [[String: Any]]
                {
                    recentList.append(["title": "All Ads", "catID": objData.id, "catName": objData.name, "locationName": userDetail?.locationName ?? "UAE", "lat": userDetail?.lat ?? 0.0, "lng": userDetail?.lng ?? 0.0])
                    UserDefaults.standard.set(recentList, forKey: "recentList")
                }
                else
                {
                    var recentList: [[String: Any]] = []
                    recentList.append(["title": "All Ads", "catID": objData.id ?? 0, "catName": objData.name ?? "", "locationName": userDetail?.locationName ?? "UAE", "lat": userDetail?.lat ?? 0.0, "lng": userDetail?.lng ?? 0.0])
                    UserDefaults.standard.set(recentList, forKey: "recentList")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if Constants.isiPadDevice {
            return CGSize(width: collectionView.frame.width / 5, height: 115)
        }
        return CGSize(width: collectionView.frame.width / 3, height: 115)
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
}
