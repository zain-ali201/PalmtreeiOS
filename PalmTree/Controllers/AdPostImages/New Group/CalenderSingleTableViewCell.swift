//
//  CalenderSingleTableViewCell.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 15/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


protocol textValDateDelegate {
    func textValDate(value: String,indexPath: Int, fieldType:String, section: Int,fieldNam:String)
}

class CalenderSingleTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var oltDate: UIButton! {
        didSet {
            oltDate.contentHorizontalAlignment = .left
        }
    }
    
    @IBOutlet weak var txtDate: UITextField!
      
    //MARK:- Properties
    var currentDate = ""
    var maxDate = ""
    var fieldName = ""
    var indexP = 0
    let bgColor = UserDefaults.standard.string(forKey: "mainColor")
    var delegate: textValDateDelegate?
    var index = 0
    var section = 0
    //var delegateMax: DateFieldsDelegateMax?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 35.0, width: oltDate.frame.size.width + 18, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        oltDate.layer.addSublayer(bottomBorder)
        
       
        selectionStyle = .none
        
    }
    
    @IBAction func actionCalendar(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            print("value = \(value!)")
            print("index = \(index!)")
            print("picker = \(picker!)")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let selectedDate = dateFormatter.string(from: value as! Date)
            //self.oltDate.setTitle(selectedDate, for: .normal)
            self.txtDate.text = selectedDate
            self.currentDate = selectedDate
            self.delegate?.textValDate(value: selectedDate, indexPath: self.indexP, fieldType: "textfield_date", section: self.section,fieldNam:self.fieldName)
            
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
        datePicker?.show()
    }
  
}
