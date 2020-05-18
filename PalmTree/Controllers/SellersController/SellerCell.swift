//
//  SellerCell.swift
//  PalmTree
//
//  Created by SprintSols on 9/6/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos

class SellerCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    //MARK:- Properties
    
    var dataArray = [SellersSocialIcon]()

    var btnUrlvalue = ""
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        print(dataArray)
    }
    
    //MARK:- Collection View Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionIconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionIconCell", for: indexPath) as! CollectionIconCell
        let objData = dataArray[indexPath.row]
        
//        btnUrlvalue = objData.value
//        print(objData.value)
        
        if objData.key == "Facebook" {
            cell.imgIcon.image = UIImage(named: "facebook")
            cell.socialBtn.tag = 0
            cell.socialBtn.setTitle(objData.value, for: .normal)

        } else if objData.key == "Twitter" {
            cell.imgIcon.image = UIImage(named: "twitter")
        cell.socialBtn.tag = 1
            cell.socialBtn.setTitle(objData.value, for: .normal)



        } else if objData.key == "Linkedin" {
            self.btnUrlvalue = objData.value
            print(self.btnUrlvalue)
            cell.socialBtn.tag = 2
            cell.socialBtn.setTitle(objData.value, for: .normal)
            cell.imgIcon.image = UIImage(named: "linkedin")
        } else if objData.key == "Google+" {
            cell.socialBtn.setTitle(objData.value, for: .normal)
            cell.socialBtn.tag = 3
            cell.imgIcon.image = UIImage(named: "googleSocial")
        }
        cell.socialBtn.addTarget(self, action: #selector(SellerCell.btnClicked(_:)), for: .touchUpInside)

        return cell
    }
    @objc func btnClicked(_ sender: UIButton){
         let inValidUrl = UserDefaults.standard.string(forKey: "InValidUrl")

                if #available(iOS 10.0, *) {
                    if verifyUrl(urlString: sender.currentTitle) == false {
                        Constants.showBasicAlert(message: inValidUrl!)
                    }else{
                        UIApplication.shared.open(URL(string: sender.currentTitle!)!, options: [:], completionHandler: nil)
                    }
                    
                } else {
                    if verifyUrl(urlString: sender.currentTitle) == false {
                        Constants.showBasicAlert(message: inValidUrl!)
                    }else{
                        UIApplication.shared.openURL(URL(string: sender.currentTitle!)!)
                    }
                }
         print(sender.currentTitle)
         
         
     }
//    @IBAction func btnWebUrlClick(_ sender: UIButton) {
//
//         let inValidUrl:String = "Invalid url"
//
//         if #available(iOS 10.0, *) {
//             if verifyUrl(urlString: btnUrlvalue) == false {
//                 Constants.showBasicAlert(message: inValidUrl)
//
//             }else{
//                 UIApplication.shared.open(URL(string: btnUrlvalue)!, options: [:], completionHandler: nil)
//             }
//
//         } else {
//             if verifyUrl(urlString: btnUrlvalue) == false {
//                 Constants.showBasicAlert(message: inValidUrl)
//             }else{
//                 UIApplication.shared.openURL(URL(string: btnUrlvalue)!)
//             }
//         }
//     }
    func verifyUrl (urlString: String?) -> Bool {
           //Check for nil
           if let urlString = urlString {
               // create NSURL instance
               if let url = NSURL(string: urlString) {
                   // check if your application can open the NSURL instance
                   return UIApplication.shared.canOpenURL(url as URL)
               }
           }
           return false
       }
//       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.isiPadDevice {
            return CGSize(width: 25, height: 25)
        }
        return CGSize(width: 30, height: 30)
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


//MARK:- Collection Cell
class CollectionIconCell: UICollectionViewCell {
    
    @IBOutlet weak var socialBtn: UIButton!
    @IBOutlet weak var imgIcon: UIImageView! {
        didSet {
            imgIcon.layer.borderWidth = 1
            imgIcon.layer.masksToBounds = false
            imgIcon.layer.borderColor = UIColor.white.cgColor
            imgIcon.layer.cornerRadius = imgIcon.frame.height/2
            imgIcon.clipsToBounds = true
        }
    }
}





