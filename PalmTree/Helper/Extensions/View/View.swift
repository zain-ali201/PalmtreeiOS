//
//  View.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    
    func roundCorners() {
        self.layer.cornerRadius = 5
    }

    // OUTPUT 1
    func addShadow(scale: Bool = true) {
        self.layer.cornerRadius = 5

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {
    func addShadowToView() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
        layer.cornerRadius = 3
    }
}

extension UIImageView {
    func cornerRadius(radius:CGFloat) {
        layer.cornerRadius = radius
    }
}

extension UIView {
    func shadow() {
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        layer.opacity = 0.85
    }
}


extension UIView {
    func circularView() {
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
}



//class BubbleView: UIView {
//
//    var isIncoming = false
//
//    var incomingColor = UIColor.gray
//    var outgoingColor = UIColor.green //UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1)
//
//    override func draw(_ rect: CGRect){
//        let width = rect.width
//        let height = rect.height
//        let bezierPath = UIBezierPath()
//        if isIncoming {
//            bezierPath.move(to: CGPoint(x: 22, y: height))
//            bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
//            bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
//            bezierPath.addLine(to: CGPoint(x: width, y: 17))
//            bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
//            bezierPath.addLine(to: CGPoint(x: 21, y: 0))
//            bezierPath.addCurve(to: CGPoint(x: 3, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
//            bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
//            bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
//            bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
//            bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
//            bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
//
//            incomingColor.setFill()
//
//        } else {
//            bezierPath.move(to: CGPoint(x: width - 22, y: height))
//            bezierPath.addLine(to: CGPoint(x: 17, y: height))
//            bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
//            bezierPath.addLine(to: CGPoint(x: 0, y: 17))
//            bezierPath.addCurve(to: CGPoint(x: 35, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
//            bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
//            bezierPath.addCurve(to: CGPoint(x: width - 150, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
//            bezierPath.addLine(to: CGPoint(x: width - 60, y: height - 30))
//            bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
//            bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
//            bezierPath.addCurve(to: CGPoint(x: width - 19.04, y: height - 10.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
//            bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
//
//            outgoingColor.setFill()
//        }
//
//        bezierPath.close()
//        bezierPath.fill()
//    }
//
//}
//
//
//
