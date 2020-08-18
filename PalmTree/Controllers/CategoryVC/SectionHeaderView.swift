//
//  SectionHeaderView.swift
//  CollapseTableView
//
//  Created by Serhii Kharauzov on 6/7/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import UIKit
import CollapseTableView

class SectionHeaderView: UITableViewHeaderFooterView, CollapseSectionHeader {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var indicatorImageView: UIImageView {
        return imageView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = UIImage(named: "drop_arrow")!.withRenderingMode(.alwaysTemplate)
    }
}
