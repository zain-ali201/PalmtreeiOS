//
//  HomeFeatureCollectionCell.swift
//  PalmTree
//
//  Created by SprintSols on 5/30/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class HomeFeatureCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor =  UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblFeatured: UILabel!
    
    
    var btnFullAction: (()->())?
    var latestHorizontalSingleAd: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var  imageView: UIImageView!
    var  imageViewLoc: UIImageView!
    var lblTitle: UILabel!
    var lblLocs: UILabel!
    var lblPriceHori: UILabel!
    var lblFeature: UILabel!
    var lblBidTimer: UILabel!
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
        if latestHorizontalSingleAd  == "horizental" {
            //            containerView.backgroundColor = UIColor.systemRed
            imgPicture.isHidden = true
            lblName.isHidden = true
            lblLocation.isHidden = true
            lblPrice.isHidden = true
            lblTimer.isHidden = true
            let imageName = "appLogo"
            let image = UIImage(named: imageName)
             imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 2, y: 5, width: 110, height: 113)
            contentView.addSubview(imageView)
             lblFeature = UILabel(frame: CGRect(x: 2, y: 5, width: 78, height: 28))
            lblFeature.textAlignment = .center
            lblFeature.textColor = UIColor.white
            lblFeature.text = "Featured"
            lblFeature.backgroundColor = UIColor.red
            //bottomalign label
            //            lblFeature.frame.origin.x = imageView.frame.width + 18
            //            lblFeature.frame.origin.y = 5 + lblFeature.frame.height
            lblFeature.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            
            //imageView.frame.height
            //top right with x = 0
            //            label.frame.origin.y = 30
            //            label.frame.origin.x = imageView.frame.width - label.frame.width
            contentView.addSubview(lblFeature)
            lblBidTimer = UILabel(frame: CGRect(x: 2, y: 0, width: 100, height: 28))
            lblBidTimer.textAlignment = .center
            lblBidTimer.textColor = UIColor.white
            //            lblBidTimer.text = "Bid Timer"
            lblBidTimer.backgroundColor = Constants.hexStringToUIColor(hex: "#575757")
            //bottomalign label
            //            lblBidTimer.frame.origin.x = 0
            lblBidTimer.frame.origin.y = 62 + lblBidTimer.frame.height
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
            
            
        }

//        if latestHorizontalSingleAd   {
//            //            containerView.backgroundColor = UIColor.systemRed
//            imgPicture.isHidden = true
//            lblName.isHidden = true
//            lblLocation.isHidden = true
//            lblPrice.isHidden = true
//            let imageName = "appLogo"
//            let image = UIImage(named: imageName)
//            let imageView = UIImageView(image: image!)
//            imageView.frame = CGRect(x: 2, y: 2, width: 110, height: 125)
//            contentView.addSubview(imageView)
//
//            let lblFeature = UILabel(frame: CGRect(x: 0, y: 0, width: 78, height: 28))
//            lblFeature.textAlignment = .left
//            lblFeature.textColor = UIColor.white
//            lblFeature.text = "Featured"
//            lblFeature.backgroundColor = UIColor.red
//            //bottomalign label
////            lblFeature.frame.origin.x = imageView.frame.width + 18
////            lblFeature.frame.origin.y = 5 + lblFeature.frame.height
//            lblFeature.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
//
//            //imageView.frame.height
//            //top right with x = 0
//            //            label.frame.origin.y = 30
//            //            label.frame.origin.x = imageView.frame.width - label.frame.width
//            contentView.addSubview(lblFeature)
//
//            let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 28))
//            lblTitle.textAlignment = .left
//            lblTitle.textColor = UIColor.black
//            lblTitle.text = "Ad Title"
//
//            //bottomalign label
//            lblTitle.frame.origin.x = imageView.frame.width + 18
//            lblTitle.frame.origin.y = 5 + lblTitle.frame.height
//            lblTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
//
//            //imageView.frame.height
//            //top right with x = 0
//            //            label.frame.origin.y = 30
//            //            label.frame.origin.x = imageView.frame.width - label.frame.width
//            contentView.addSubview(lblTitle)
//            let imageNameLoc = "location"
//            let imageLoc = UIImage(named: imageNameLoc)
//            let imageViewLoc = UIImageView(image: imageLoc!)
//            imageViewLoc.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//            imageViewLoc.frame.origin.y = 68
//            imageViewLoc.frame.origin.x = lblLocation.frame.width + (imageViewLoc.frame.width)
//            contentView.addSubview(imageViewLoc)
//            let lblLocation = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 28))
//            lblLocation.textAlignment = .left
//            //                        lblLocation.backgroundColor = UIColor.blue
//            lblLocation.textColor = UIColor.lightGray
//            lblLocation.font = lblLocation.font.withSize(15)
//            lblLocation.center.x = lblTitle.center.x - 3
//            lblLocation.numberOfLines = 2
//            lblLocation.frame.origin.y = lblTitle.frame.origin.y + (lblLocation.frame.height) + 6
//            lblLocation.text = "Model Town Link Road Lahore Punjab Pakistan"
//            contentView.addSubview(lblLocation)
//
//            let lblPrice = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 28))
//            lblPrice.textAlignment = .left
//            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
//                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
//            }
//
//            lblPrice.center.x = lblTitle.center.x - 3
//            lblPrice.frame.origin.y = imageViewLoc.frame.origin.y + (lblPrice.frame.height) + 2
//            lblPrice.text = "$-223"
//            contentView.addSubview(lblPrice)
//
//
//        }
        
        
        
        
        
    }
}
