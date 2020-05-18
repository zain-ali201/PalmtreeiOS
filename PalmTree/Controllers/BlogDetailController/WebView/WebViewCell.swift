//
//  WebViewCell.swift
//  PalmTree
//
//  Created by SprintSols on 3/14/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WebViewCell: UITableViewCell {

    @IBOutlet weak var heightWebView: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView! {
        didSet {
           // webView.delegate = self
            webView.isOpaque = false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //to set webview size with amount of data
    
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        webView.frame.size.height = 1
//        webView.frame.size = webView.sizeThatFits(.zero)
//    }
    
}
