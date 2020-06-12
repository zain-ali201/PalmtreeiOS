//
//  SeekBar.swift
//  PalmTree
//
//  Created by SprintSols on 9/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import RangeSeekSlider


protocol SeekBarDelegate {
    func SeekBarValue(seekBarVal: String, fieldType: String, indexPath: Int,fieldTypeName:String)
}

class SeekBar : UITableViewCell , RangeSeekSliderDelegate{
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Properties
    var minimumValue = 0
    var maximumValue = ""
    var fieldName = ""
    var delegate:SeekBarDelegate?
    var index = 0
    var fieldTypeNam = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        rangeSlider.delegate = self
        rangeSlider.disableRange = true
        rangeSlider.enableStep = true
        rangeSlider.step = 5
        if let bgColor = UserDefaults.standard.string(forKey: "mainColor") {
            rangeSlider.tintColor = Constants.hexStringToUIColor(hex: bgColor)
            rangeSlider.minLabelColor = Constants.hexStringToUIColor(hex: bgColor)
            rangeSlider.maxLabelColor = Constants.hexStringToUIColor(hex: bgColor)
            rangeSlider.handleColor = Constants.hexStringToUIColor(hex: bgColor)
            rangeSlider.handleBorderColor = Constants.hexStringToUIColor(hex: bgColor)
            rangeSlider.colorBetweenHandles = Constants.hexStringToUIColor(hex: bgColor)
            rangeSlider.initialColor = Constants.hexStringToUIColor(hex: bgColor)
        }
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            let mxValue = maxValue
            self.maximumValue = "\(mxValue)"
            self.delegate?.SeekBarValue(seekBarVal: self.maximumValue, fieldType: "seekbar", indexPath: index,fieldTypeName:fieldTypeNam)
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
