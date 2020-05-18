//
//  Button.swift
//  PalmTree
//
//  Created by SprintSols on 3/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class ButtonWithImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 4, bottom: 5, right: (bounds.width - 35))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}


extension UIButton {
    func roundCornors(radius: CGFloat = 5) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIButton {
    func circularButton() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
extension UIButton{
    func circularButtonShadow(){
//        Shadow and Radius for Circle Button
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = frame.width / 2

    }
}
extension UIButton {
    /// Add image on left view
    func leftImage(image: UIImage) {
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: image.size.width/5)
        self.tintColor = UIColor.blue
    }
}
extension UIButton {
    func underlineButton() {
        guard let text = self.titleLabel?.text else { return }
        print(text)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

class UnderlineTextButton: UIButton {
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: .normal)
        self.setAttributedTitle(self.attributedString(), for: .normal)
    }
    
    private func attributedString() -> NSAttributedString? {
        let attributes = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.red,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        return attributedString
    }
}


