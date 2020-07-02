//
//  TermsConditionsController.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AboutusVC: UIViewController {


    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtView.text = "متجر Palmtree هو تطبيق وموقع ويب مبوب رائد للمستخدمين في دول مجلس التعاون الخليجي. منذ إطلاقه في عام 2020 من قبل محمد الكويتي، أصبحت Palmtree مكانًا آمنًا للمستخدمين لشراء أو بيع أو العثور على أي شيء في مجتمعهم المحلي. مجتمع مترابط وسمح، يؤمن بإعادة توزيع السلع غير المستخدمة لتلبية حاجة جديدة، ويصبح مطلوبًا مرة أخرى، حيث يتم تبادل الممتلكات غير المنتج مثل المساحة والمهارات والأموال وتداولها بطرق جديدة لا تتطلب دائمًا مؤسسات مركزية أو وسيط."
            
            txtView.textAlignment = .right
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- IBActions
   
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
