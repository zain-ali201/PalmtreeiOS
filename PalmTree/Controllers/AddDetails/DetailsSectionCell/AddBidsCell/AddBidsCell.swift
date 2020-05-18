//
//  AddBidsCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddBidsCell: UITableViewCell {
   
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var oltBids: UIButton!{
        didSet{
            if let mainColor = defaults.string(forKey: "mainColor"){
                oltBids.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var oltStats: UIButton! {
        didSet{
            if let mainColor = defaults.string(forKey: "mainColor"){
                oltStats.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var viewTotal: UIView! {
        didSet{
            viewTotal.layer.borderColor = UIColor.lightGray.cgColor
            viewTotal.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var viewHighest: UIView! {
        didSet{
            viewHighest.layer.borderColor = UIColor.lightGray.cgColor
            viewHighest.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var lblHighest: UILabel!
    @IBOutlet weak var lblhighestValue: UILabel!
    @IBOutlet weak var viewLowest: UIView!{
        didSet{
            viewLowest.layer.borderColor = UIColor.lightGray.cgColor
            viewLowest.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var lblLowest: UILabel!
    @IBOutlet weak var lblLowestValue: UILabel!
    
    
    var btnBids: (()->())?
    var btnStats: (()->())?
    var defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionStats(_ sender: Any) {
        self.btnStats?()
        print("Stats")
    }
    
    @IBAction func actionBids(_ sender: Any) {
        self.btnBids?()
        print("Bids")
    }
    
    
}
