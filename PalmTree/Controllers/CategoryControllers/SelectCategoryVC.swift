//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SelectCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Properties
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var delegate : CategoryDetailDelegate?
    
    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnACtion(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoryArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        if indexPath.row == 0
        {
            if languageCode == "ar"
            {
                cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                cell.lblName.text = "جميع السيارات";
            }
            else
            {
                cell.lblName.text = "All Categories"
            }
        }
        else
        {
            let objData = categoryArray[indexPath.row]
                
            if let name = objData.name
            {
                if languageCode == "ar"
                {
                    cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    //                cell.lblName.text = NSLocalizedString(name, comment: "")
                    cell.lblName.text = name
                }
                else
                {
                    cell.lblName.text = name
                }
            }
            
            if let imgUrl = URL(string: objData.img.encodeUrl()) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            
            cell.categoryBtnAction = { () in
                self.delegate?.selectCategory()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        self.navigationController?.pushViewController(adFilterListVC, animated: true)
    }
}
