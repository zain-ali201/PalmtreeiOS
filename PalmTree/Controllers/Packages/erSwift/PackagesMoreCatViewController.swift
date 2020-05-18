//
//  PackagesMoreCatViewController.swift
//  PalmTree
//
//  Created by SprintSols on 10/2/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class PackagesMoreCatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnOk: UIButton!
    
    //MARK: Proporties
    
    var catArr = [String]()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    //MARK:- Tableview Datasource and delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesMoreCatTableViewCell", for: indexPath) as! PackagesMoreCatTableViewCell
        
        let catData = catArr[indexPath.row]
        let index = indexPath.row + 1
        
        cell.lblName.text = "\(index): " + "\(catData)"
        
        return cell
        
    }
    
    
    
    @IBAction func btnOkClicked(_ sender: UIButton) {
        
    }
    
    
}
