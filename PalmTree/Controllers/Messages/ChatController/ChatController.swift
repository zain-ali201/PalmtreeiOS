//
//  ChatController.swift
//  PalmTree
//
//  Created by SprintSols on 3/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import Firebase
import FirebaseDatabase
import FirebaseStorage
import QuartzCore

class ChatController: UIViewController, NVActivityIndicatorViewable, UITextViewDelegate {

    //MARK:- Outlets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var txtMsg: UITextField!
    @IBOutlet var tblChat: UITableView!

    @IBOutlet weak var txtMessage: UITextView!
    
    //MARK:- Properties
    var dict:NSDictionary!
    let arrMsg = NSMutableArray()

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.googleAnalytics(controllerName: "Chat Controller")
       
        bottomConstraint.constant = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        let senderDisplayName = "\(String(describing: dict.object(forKey: "Firstname")!))"
        let senderDisplayName = "Zain Ali"
        title = "Chat: \(senderDisplayName)"
        let database = Database.database().reference()
        
//        database.child("Chats").child(Auth.auth().currentUser!.uid).child("\(String(describing: dict.object(forKey: "firebaseId")!))").observe(.childAdded) { (snapshot) in
        
        database.child("Chats").child(Auth.auth().currentUser!.uid).child("JbhFyW9qxWTIDVHku1OAmuQNBRt1").observe(.childAdded) { (snapshot) in
            
            let components = snapshot.key.components(separatedBy: "_")
            let dictMsg = NSMutableDictionary()
            dictMsg.setObject(components[1], forKey: "SenderId" as NSCopying)
            dictMsg.setObject(components[2], forKey: "ReceiverId" as NSCopying)
            dictMsg.setObject(snapshot.value!, forKey: "Message" as NSCopying)
            
            self.arrMsg.add(dictMsg)
            self.tblChat.reloadData()
            self.tblChat.separatorStyle = .none
            self.scrollToBottom()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionMsgSend(_ sender: Any) {
        if (txtMsg.text == "" || txtMsg.text == " ")
        {
            let alert = UIAlertController(title: "Alert", message: "Please type a Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let database = Database.database().reference()
//            let str =  "\(String(describing: self.getCurrentTimeStamp().replacingOccurrences(of: ".", with: "")))" + "_" + "\(String(describing: Auth.auth().currentUser!.uid))" + "_" + "\(String(describing: dict.object(forKey: "firebaseId")!))"
//
//            database.child("Chats").child("\(String(describing: dict.object(forKey: "firebaseId")!))").child(Auth.auth().currentUser!.uid).updateChildValues([str : txtMsg.text!])
//
//            database.child("Chats").child(Auth.auth().currentUser!.uid).child("\(String(describing: dict.object(forKey: "firebaseId")!))").updateChildValues([str : txtMsg.text!])
            
            let str =  "\(String(describing: self.getCurrentTimeStamp().replacingOccurrences(of: ".", with: "")))" + "_" + "\(String(describing: Auth.auth().currentUser!.uid))" + "_" + "\(String(describing: "JbhFyW9qxWTIDVHku1OAmuQNBRt1"))"
            
            database.child("Chats").child("\(String(describing: "JbhFyW9qxWTIDVHku1OAmuQNBRt1"))").child(Auth.auth().currentUser!.uid).updateChildValues([str : txtMsg.text!])
            
            database.child("Chats").child(Auth.auth().currentUser!.uid).child("\(String(describing: "JbhFyW9qxWTIDVHku1OAmuQNBRt1"))").updateChildValues([str : txtMsg.text!])
            self.tblChat.reloadData()
            txtMsg.text = " "
        }
    }
    
    func getCurrentTimeStamp() -> String {
            return "\(Double(NSDate().timeIntervalSince1970 * 1000))"
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrMsg.count-1, section: 0)
            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = (keyboardSize.height) * -1.0
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            bottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtMsg.resignFirstResponder()
        return true
    }
}

extension ChatController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMsg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict1 = arrMsg.object(at: indexPath.row) as! NSDictionary
        
        if((String(describing: dict1.object(forKey: "SenderId")!)) == Auth.auth().currentUser?.uid){
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! Chat2TableViewCell
            cell2.lblSender.text = (dict1.object(forKey: "Message") as! String)
            cell2.lblSender.backgroundColor = UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1)
            cell2.lblSender.font = UIFont.systemFont(ofSize: 18)
            cell2.lblSender.textColor = .white
            cell2.lblSender?.layer.masksToBounds = true
            cell2.lblSender.layer.cornerRadius = 7
            return cell2
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatTableViewCell
            cell.lblReceiver.text = (dict1.object(forKey: "Message") as! String)
            cell.lblReceiver.backgroundColor = UIColor .lightGray
            cell.lblReceiver.font = UIFont.systemFont(ofSize: 18)
            cell.lblReceiver.textColor = UIColor.white
            cell.lblReceiver?.layer.masksToBounds = true
            cell.lblReceiver.layer.cornerRadius = 7
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
