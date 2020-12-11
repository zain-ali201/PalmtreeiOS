//
//  ReplyCommentController.swift
//  PalmTree
//
//  Created by SprintSols on 3/16/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TextFieldEffects
import UITextField_Shake
import Firebase
import FirebaseDatabase

protocol moveTomessagesDelegate {
    func isMoveMessages(isMove: Bool)
}

class ReplyCommentController: UIViewController , NVActivityIndicatorViewable{

    //MARK:- Outlets
    
    @IBOutlet weak var viewMsg: UIView! {
        didSet {
            viewMsg.circularView()
        }
    }
    @IBOutlet weak var imgMessage: UIButton!
    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var containerViewCall: UIView!
    @IBOutlet weak var containerViewTxtField: UIView!
    @IBOutlet weak var txtComment: HoshiTextField!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOK: UIButton!
    
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblNumber: UILabel! {
        didSet {
            lblNumber.layer.borderWidth = 1
            lblNumber.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var lblVerificationText: UILabel!
    
    //MARK:- Properties
    var delegate: moveTomessagesDelegate?
    var isFromMsg = false
    var firebaseID = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Reply Comment Controller")
        
        if languageCode == "ar"
        {
            txtComment.text = "مرحبا، هل هذه مازالت متوفرة؟"
            txtComment.textAlignment = .right
        }

    }

    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- IBActions
    
    @IBAction func actionOK(_ sender: UIButton)
    {
//        firebaseID = "JbhFyW9qxWTIDVHku1OAmuQNBRt1"
        self.showLoader()
        let database = Database.database().reference()
        let str =  "\(String(describing: self.getCurrentTimeStamp().replacingOccurrences(of: ".", with: "")))" + "_" + "\(String(describing: Auth.auth().currentUser!.uid))" + "_" + "\(firebaseID)"
        
        database.child("Chats").child("\(firebaseID)").child(Auth.auth().currentUser!.uid).updateChildValues([str : txtComment.text!])
        
        database.child("Chats").child(Auth.auth().currentUser!.uid).child("\(firebaseID)").updateChildValues([str : txtComment.text!])
        self.stopAnimating()
        self.dismissVC(completion: nil)
    }
    
    @IBAction func actionCancel(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }
    
    func getCurrentTimeStamp() -> String {
            return "\(Double(NSDate().timeIntervalSince1970 * 1000))"
    }
    
    //MARK:- API Call
    
}
