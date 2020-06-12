//
//  AddDetailDescriptionCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddDetailDescriptionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIWebViewDelegate {
   
    
    //MARK:- Outlets
    
    
    
    @IBOutlet weak var heightConstraintWebView: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isScrollEnabled = false
        }
    }
    
    @IBOutlet weak var lblHtmlText: UILabel!
    @IBOutlet weak var lblTagTitle: UILabel!
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationValue: UILabel!
    @IBOutlet weak var cstCollectionHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblWebUrl: UILabel!
    
    //MARK:- Properties
    var fieldsArray = [AddDetailFieldsData]()
    let defaults = UserDefaults.standard
    var flowLayout: UICollectionViewFlowLayout {
        return self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    }
    var btnUrlvalue = ""
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
       // cstCollectionHeight.constant = self.collectionView.contentSize.height
        //collectionView.reloadData()
        self.setupView()
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
//        let objData = AddsHandler.sharedInstance.objAddDetails?.adDetail
//        
//        UserDefaults.standard.set(objData?.fieldsDataColumn, forKey: "fieldsDataColumn")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cstCollectionHeight.constant = self.collectionView.contentSize.height
    }
    
    //MARK:- Custom
    func setupView() {
        if defaults.bool(forKey: "isRtl") {
            locationValue.textAlignment = .right

        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setNeedsLayout()
        
    }
    
    func reload() {
         collectionView.reloadData()
        //cstCollectionHeight.constant = self.collectionView.contentSize.height
        //self.perform(#selector(self.reloadCollection), with: nil, afterDelay: 1)
       
    }
//    @objc func reloadCollection(){
//         collectionView.reloadData()
//    }
    
    //MARK:- Collection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fieldsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddDetailDescriptionCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDetailDescriptionCollectionCell", for: indexPath) as! AddDetailDescriptionCollectionCell
        
          let objData = fieldsArray[indexPath.row]

        if let category = objData.key {
            cell.lblCategory.text = "\(category) :"
        }
        if let name = objData.value {
            cell.lblDescription.text = "\(name)"
        }
        if  objData.type == "color_field" {
            cell.lblDescription.text = ""
            cell.imgViewColor.isHidden = false
            cell.imgViewColor.image = UIImage(named:"circleShape")
            cell.imgViewColor.image = cell.imgViewColor.image?.withRenderingMode(.alwaysTemplate)
            cell.imgViewColor.tintColor = UIColor(hex:objData.value)
            
        }
        if objData.type == "textfield_url"{
            let webUrl = objData.value
            self.btnUrlvalue = objData.value
            cell.lblWebUrl.isHidden = true
            cell.btnWebUrlClick.isHidden = false
            cell.lblDescription.isHidden = true
            let viewLink = UserDefaults.standard.string(forKey: "webUrl")
            print(viewLink!)
            let myNormalAttributedTitle = NSAttributedString(string: viewLink!,
                attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue])
            cell.btnWebUrlClick.setAttributedTitle(myNormalAttributedTitle, for: .normal)


        }
        else{
            cell.lblWebUrl.isHidden = true
        }

       //cstCollectionHeight.constant = 300 //collectionView.contentSize.height + cell.lblCategory.frame.height - collectionView.contentSize.height
        return cell
    }
   @IBAction func btnWebUrlClick(_ sender: UIButton) {
         
         let inValidUrl:String = "Invalid url"
         
         if #available(iOS 10.0, *) {
             if verifyUrl(urlString: btnUrlvalue) == false {
                 Constants.showBasicAlert(message: inValidUrl)
             }else{
                 UIApplication.shared.open(URL(string: btnUrlvalue)!, options: [:], completionHandler: nil)
             }
             
         } else {
             if verifyUrl(urlString: btnUrlvalue) == false {
                 Constants.showBasicAlert(message: inValidUrl)
             }else{
                 UIApplication.shared.openURL(URL(string: btnUrlvalue)!)
             }
         }
     }
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
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = getItemWidth(boundWidth: collectionView.bounds.size.width)
        
        return CGSize(width: itemWidth, height:45)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    
    
    func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        
        let col = AddsHandler.sharedInstance.objAddDetails?.adDetail.fieldsDataColumn
    
        let colInt:Int = Int(col!)!
        print(colInt)
        let colFloat = CGFloat(colInt)
        
        //let column:CGFloat = 2
        let minItemSpacing: CGFloat = 1
        let offSet: CGFloat = 1
        
        let totalWidth = boundWidth - (offSet + offSet) - ((colFloat - 1) * minItemSpacing)
        return totalWidth / colFloat
    }
    
}


class AddDetailDescriptionCollectionCell : UICollectionViewCell {
    
    
   
    @IBOutlet weak var imgViewColor: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnWebUrlClick: UIButton!
    @IBOutlet weak var lblWebUrl: UILabel!
    @IBOutlet weak var contHeightTitle: NSLayoutConstraint!
    @IBOutlet weak var constHeightDetail: NSLayoutConstraint!
    
    
}

//class DescriptionCellSize {
//
//    static let totalItem: CGFloat = 10
//    static let column:CGFloat = 1
//    static let minLineSpacing: CGFloat = 1
//    static let minItemSpacing: CGFloat = 1
//    static let offSet: CGFloat = 1
//    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
////        let col = UserDefaults.standard.float(forKey: "fieldsDataColumn")
////
////        let column:CGFloat = CGFloat(col)
//        let totalWidth = boundWidth - (offSet + offSet) - ((column-1) * minItemSpacing)
//        return totalWidth / column
//    }
//}
