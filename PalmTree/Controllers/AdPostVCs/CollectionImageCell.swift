//
//  CollectionImageCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol imagesCount {
    func imgeCount(count:Int)
}

class CollectionImageCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Properties
    var isDrag : Bool = false
    var UiImagesArr = [UIImage]()
    var imageIdArrAd = [Int]()


    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    @IBOutlet weak var viewDragImage: UIView!
    @IBOutlet weak var lblArrangeImage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            if #available(iOS 11.0, *) {
                collectionView.dragInteractionEnabled = true
                collectionView.dragDelegate = self
                collectionView.dropDelegate = self
                collectionView.reorderingCadence = .immediate //default value - .immediate

            } else {
                // Fallback on earlier versions
            }
            collectionView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    //MARK:- Properties
    var dataArray = [AdPostImageArray]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ad_id = 0
    var delegate:imagesCount?
    

    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }
    
//
//    @available(iOS 11.0, *)
//    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator , destinationationIndexpath: IndexPath , collectionView: UICollectionView){
//
//        if let item = coordinator.items.first,
//            let sourceIndexPath = item.sourceIndexPath{
//            collectionView.performBatchUpdates({
//
//                self.dataArray.remove(at: sourceIndexPath.item)
//                let moveImage = dataArray[sourceIndexPath.item]
////item.dragItem.localObject as! String
//                self.dataArray.insert(moveImage, at: destinationationIndexpath.item)
//
//
//                collectionView.deleteItems(at: [sourceIndexPath])
//                collectionView.insertItems(at: [destinationationIndexpath])
//            },completion: nil)
//            coordinator.drop(item.dragItem, toItemAt: destinationationIndexpath)
//        }
//    }
    
    @available(iOS 11.0, *)
        private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
        {
            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
            {
                var dIndexPath = destinationIndexPath
                if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
                {
                    dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                }
                
                collectionView.performBatchUpdates({
                    if collectionView === self.collectionView
                    {
                        
                        print(sourceIndexPath.row)
                        print(dIndexPath.row)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [dIndexPath])
                        self.dataArray.remove(at: sourceIndexPath.row)
                        self.dataArray.insert(item.dragItem.localObject as! AdPostImageArray, at: dIndexPath.row)
                        for data in dataArray{
                        let url = URL(string:data.thumb)
                        if let data = try? Data(contentsOf: url!)
                        {
                        let image: UIImage = UIImage(data: data)!
                        UiImagesArr.append(image)
                        }
                        }
                        print(UiImagesArr)

                    }

                   


                })
                
                coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
            
    }
    }
    @available(iOS 11.0, *)
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
      {
          collectionView.performBatchUpdates({
              var indexPaths = [IndexPath]()
              for (index, item) in coordinator.items.enumerated()
              {
                  let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                  if collectionView === self.collectionView
                  {
                      self.dataArray.insert(item.dragItem.localObject as! AdPostImageArray, at: indexPath.row)
                  }
                  else
                  {
                      self.dataArray.insert(item.dragItem.localObject as! AdPostImageArray, at: indexPath.row)
                  }
                  indexPaths.append(indexPath)
              }
              collectionView.insertItems(at: indexPaths)
          })
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
        let cell: ImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        
        let objData = dataArray[indexPath.row]

        for id in dataArray{
            imageIdArrAd.append(id.imgId)
        }
        print(imageIdArrAd)
//        if let imgUrl = URL(string: objData.thumb ){
//            cell.imgPictures.setImage(from: imgUrl)
//        }
            
        
        let url = URL(string:objData.thumb)
        
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.imgPictures.image = image
        }
        
        cell.btnDelete = { () in
            let param: [String: Any] = ["ad_id": self.ad_id, "img_id": objData.imgId]
            self.removeItem(index: indexPath.row)
        
            self.deleteImage(param: param as NSDictionary)
        }
        
       //  self.rotateImageAppropriately(cell.imgPictures.image)
        return cell
    }
    
    
    func rotateImageAppropriately(_ imageToRotate: UIImage?) -> UIImage? {
        //This method will properly rotate our image, we need to make sure that
        //We call this method everywhere pretty much...
        
        let imageRef = imageToRotate?.cgImage
        var properlyRotatedImage: UIImage?
        
        //if imageOrientationWhenAddedToScreen == 0 {
            //Don't rotate the image
            properlyRotatedImage = imageToRotate
        //}
 //       else if imageOrientationWhenAddedToScreen == 3 {
//
//            //We need to rotate the image back to a 3
//           if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 3) {                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)          }
        
//    }
      //     else if imageOrientationWhenAddedToScreen == 1 {
//
//            //We need to rotate the image back to a 1
            if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 1) {
                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)
            }
       // }
        
        return properlyRotatedImage
        
    }
    
    //Remove item at selected Index
    func removeItem(index: Int) {
        dataArray.remove(at: index)
        self.collectionView.reloadData()
    }
    
    
    
    //MARK:- API Call
    func deleteImage(param: NSDictionary) {
        
        AddsHandler.adPostDeleteImages(param: param, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDelegate.presentController(ShowVC: alert)
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.adPostImageDelete), object: nil, userInfo: nil)
                self.delegate?.imgeCount(count: successResponse.data.adImages.count)
                self.collectionView.reloadData()

                print(successResponse.data.adImages.count)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDelegate.presentController(ShowVC: alert)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: NSLocalizedString(String(format: "something_%@", languageCode), comment: ""))
            self.appDelegate.presentController(ShowVC: alert)
        }
    }
}

class ImagesCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var imgPictures: UIImageView!
    @IBOutlet weak var containerViewCross: UIView!
    @IBOutlet weak var imgDelete: UIImageView!
    
    //MARK:- Properties
    
    var btnDelete: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
   
    //MARK:- IBActions
    @IBAction func actionDelete(_ sender: Any) {
        self.btnDelete?()
    }
}

extension UIImage {
    
    func updateImageOrientionUpSide() -> UIImage? {
        if self.imageOrientation == .left {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
}

extension CollectionImageCell: UICollectionViewDragDelegate{
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.dataArray[indexPath.row]
        let itemProvider = NSItemProvider(object: item.thumb as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        isDrag = true
        return [dragItem]
    }
}
extension CollectionImageCell: UICollectionViewDropDelegate{
    @available(iOS 11.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?)
        -> UICollectionViewDropProposal {
            if collectionView.hasActiveDrag{
                return UICollectionViewDropProposal(operation: .move ,intent: .insertAtDestinationIndexPath)

            }
            return UICollectionViewDropProposal(operation: .forbidden)

    }
    
     @available(iOS 11.0, *)
     func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
         var destinationIndexpath = IndexPath()
         if let indexPath = coordinator.destinationIndexPath{
             destinationIndexpath = indexPath
         }
         else{
             let row = collectionView.numberOfItems(inSection: 0)
             destinationIndexpath = IndexPath(item: row - 1 , section: 0)
         }
         if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator:coordinator , destinationIndexPath: destinationIndexpath ,collectionView: collectionView)
                print(destinationIndexpath)

//            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexpath, collectionView: collectionView)
                       
//            self.collectionView.reloadData()

         }
     }
}
    
    

