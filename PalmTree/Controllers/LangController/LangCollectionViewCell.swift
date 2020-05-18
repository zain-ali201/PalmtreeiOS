//
//  LangCollectionViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 13/06/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class LangCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var btnCode: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBg.addShadow()
        
    }
    
}
extension UICollectionView {

    func EmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func ok() {
        self.backgroundView = nil
    }
}
