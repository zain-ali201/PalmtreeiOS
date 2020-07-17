//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AdFilterListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NVActivityIndicatorViewable{

    //MARK:- Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
    
    var filtersArray = ["Cars", "UAE", "Price", "Make/Model", "Color"]
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == ""
        {
            filtersArray = [NSLocalizedString("Cars", comment: ""),NSLocalizedString("UAE", comment: ""),NSLocalizedString("Price", comment: ""),NSLocalizedString("Make/Model", comment: ""),NSLocalizedString("Color", comment: "")]
        }
        
        self.googleAnalytics(controllerName: "Advance Search Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSearch.textAlignment = .right
        }
        
        createFilterView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ button: UIButton)
    {
        let alert = UIAlertController(title: "Search Alert", message: "Save this search and get notified of new results", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default, handler: { (okAction) in
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ button: UIButton)
    {
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.present(filterVC, animated: true, completion: nil)
    }
    
    //MARK:- Custom Functions
    
    func createFilterView()
    {
        for view in filtersView.subviews
        {
            view.removeFromSuperview()
        }
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: filtersView.frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        filtersView.addSubview(scrollView)
        
        var xAxis = 10
        var width = 0
        
        for i in 0..<filtersArray.count
        {
            let filter: String = filtersArray[i]
            
            width = Int((filter.html2AttributedString?.width(withConstrainedHeight: 36))!)
            width += 70
            
            let view = UIView()
            view.frame = CGRect(x: Int(xAxis), y: 7, width: Int(width), height: 36)
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 1.0
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            
            let lbl = UILabel()
            lbl.frame = CGRect(x: 0, y: 0, width: width, height: 36)
            lbl.textAlignment = .center
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.backgroundColor = .clear
            
            let crossBtn = UIButton()
            crossBtn.frame = CGRect(x: view.frame.width - 18, y: 13, width: 10, height: 10)
            crossBtn.setImage(UIImage(named: "cross_grey"), for: .normal)
            crossBtn.tag = i
            crossBtn.addTarget(self, action: #selector(crossBtnAction(button:)), for: .touchUpInside)
            
            
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 36)
            
//            if languageCode == "ar"
//            {
//                lbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//                lbl.text = NSLocalizedString(filter, comment: "")
//            }
//            else
//            {
               lbl.text = filter
//            }
//            
            view.addSubview(lbl)
            view.addSubview(btn)
            view.addSubview(crossBtn)
            scrollView.addSubview(view)
            
            xAxis += (Int(width) + 10)
        }
        
        scrollView.contentSize = CGSize(width: 570, height: 0)
    }
    
    @IBAction func crossBtnAction(button: UIButton)
    {
        //filtersArray.remove(at: button.tag)
    }
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblProcess.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AdDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AdDetailVC") as! AdDetailVC
        self.navigationController?.pushViewController(AdDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
}

extension NSAttributedString
{
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}
