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

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UITextViewDelegate {

    //MARK:- Outlets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var oltName: UIButton!{
        didSet {
            oltName.contentHorizontalAlignment = .left
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltName.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnBlock: UIButton!
    
    @IBOutlet weak var containerViewTop: UIView! {
        didSet {
            containerViewTop.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgSent: UIImageView! {
        didSet {
            imgSent.tintImageColor(color: UIColor.white)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var heightConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightContraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        UserDefaults.standard.set("3", forKey: "fromNotification")
        appDelegate.moveToHome()
    }
    @IBOutlet weak var containerViewSendMessage: UIView! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                containerViewSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var buttonSendMessage: UIButton!{
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                buttonSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgMessage: UIImageView!
    
    @IBOutlet weak var containerViewBottom: UIView! {
        didSet {
            containerViewBottom.layer.borderWidth = 0.5
            containerViewBottom.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var txtMessage: UITextView!{
        didSet {
            txtMessage.layer.borderWidth = 0.5
            txtMessage.layer.borderColor = UIColor.lightGray.cgColor
            txtMessage.delegate = self
        }
    }
    
   
    
    //MARK:- Properties
    
    var settingObject = [String: Any]()
    let keyboardManager = IQKeyboardManager.sharedManager()
    let defaults = UserDefaults.standard
    var ad_id = ""
    var sender_id = ""
    var receiver_id = ""
    var messageType = ""
    var isBlocked :String?
    var blockMessage = ""
    var btn_text = ""
    var currentPage = 0
    var maximumPage = 0
    let textViewMaxHeight: CGFloat = 100
    var textHeightConstraint: NSLayoutConstraint!
    
    var dataArray = [SentOfferChat]()
    var reverseArray = [SentOfferChat]()
    
    var userBlocked = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.showBackButton()
        self.refreshButton()
        self.googleAnalytics(controllerName: "Chat Controller")
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        txtMessage.delegate = self
        if UserDefaults.standard.string(forKey: "fromNotification") == "1"{
            btnClose.isHidden = false
            topConstraint.constant += 10
        }else{
            topConstraint.constant -= 30
            btnClose.isHidden = true
            UserDefaults.standard.set("3", forKey: "fromNotification")
        }
        
        self.textHeightConstraint = txtMessage.heightAnchor.constraint(equalToConstant: 40)
        self.textHeightConstraint.isActive = true
        self.adjustTextViewHeight()
        
        
      
        btnBlock.backgroundColor  = UIColor(hex: defaults.string(forKey: "mainColor")!)
        btnBlock.roundCornors()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        print(parameter)
        self.adForest_getChatData(parameter: parameter as NSDictionary)
        self.showLoader()
        keyboardHandling()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if Constants.isIphoneX == true{
            NotificationCenter.default.removeObserver(self)
            keyboardManager.enable = true
            keyboardManager.enableAutoToolbar = true
        //}else{
            //keyboardManager.enable = true
            //keyboardManager.enableAutoToolbar = true
        //}
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame
//    }
    
    func adjustTextViewHeight() {
        let fixedWidth = txtMessage.frame.size.width
        let newSize = txtMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
       
        if newSize.height == 100 || newSize.height > 100{
            heightConstraintTxtView.constant = 100
            heightContraintViewBottom.constant = 100
            txtMessage.isScrollEnabled = true
        }else{
            self.textHeightConstraint.constant = newSize.height
            heightConstraintTxtView.constant = newSize.height
            heightContraintViewBottom.constant = newSize.height
        }
        self.view.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView)
    {

        self.adjustTextViewHeight()
//        print(textView.contentSize.height)
//        if textView.contentSize.height >= self.textViewMaxHeight
//        {
//            textView.isScrollEnabled = true
//        }
//        else
//        {
//
//
//            heightConstraintTxtView.constant = textView.contentSize.height
//            heightContraintViewBottom.constant = textView.contentSize.height
//                textView.isScrollEnabled = false
//
//        }
    }

    //MARK: - Custom
    
    func keyboardHandling(){
        
        //if Constants.isIphoneX == true  {
            NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
            keyboardManager.enable = false
            keyboardManager.enableAutoToolbar = false
       // }else{
            //keyboardManager.enable = true
            //keyboardManager.enableAutoToolbar = true
        //}
        
    }

    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            if self.dataArray.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = keyboardHeight
        }
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        //bottomConstraint.constant = 8
        // animateViewMoving(up: true, moveValue: 8)
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        // animateViewMoving(up: false, moveValue: 8)
        self.bottomConstraint.constant = 0
        //        if self.dataArray.count > 0 {
        //            self.tableView.scrollToRow(at: IndexPath.init(row:  self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
        //        }
        self.txtMessage.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        self.bottomConstraint.constant = 0
        self.txtMessage.resignFirstResponder()
        return true
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArray.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func refreshTableView() {
        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        print(parameter)
        self.adForest_getChatData(parameter: parameter as NSDictionary)
    }
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objSentOfferChatData != nil {
            let objData = UserHandler.sharedInstance.objSentOfferChatData
            
            if let addtitle = objData?.adTitle {
                self.oltName.setTitle(addtitle, for: .normal)
                oltName.underline()
            }
            if let price = objData?.adPrice.price {
                self.lblPrice.text = price
            }
            if let date = objData?.adDate {
                self.lblDate.text = date
            }
        
        }
    }
    
    func refreshButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        button.addTarget(self, action: #selector(onClickRefreshButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func onClickRefreshButton() {
        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        print(parameter)
        self.showLoader()
        self.adForest_getChatData(parameter: parameter as NSDictionary)
    }
    
    
    @IBAction func btnBlockClicked(_ sender: UIButton) {
    
        if isBlocked == "true"{
            let parameter : [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
            print(parameter)
            adForest_UnblockUserChat(parameters: parameter as NSDictionary)
        }else{
            let parameter : [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
            print(parameter)
            adForest_blockUserChat(parameters: parameter as NSDictionary)
        }

    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = dataArray[indexPath.row]
        if objData.type == "reply" {
            let cell: SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell

            if userBlocked == true{
                cell.isHidden = true
            }
            
            if let message = objData.text {
                cell.txtMessage.text = message
                //cell.label.text = message
                if UserDefaults.standard.bool(forKey: "isRtl") {
                    let image = UIImage(named: "bubble_se")
                    cell.imgPicture.image = image!
                        .resizableImage(withCapInsets:
                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                }else{
                    let image = UIImage(named: "bubble_sent")
                    cell.imgPicture.image = image!
                        .resizableImage(withCapInsets:
                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                }
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            return cell
        }
        else {
            
            let cell: ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
        
            if userBlocked == true{
                cell.isHidden = true
            }
            if UserDefaults.standard.bool(forKey: "isRtl") {
                if let message = objData.text {
                    let image = UIImage(named: "bubble_sent")
                    cell.imgBackground.image = image!
                        .resizableImage(withCapInsets:
                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                    
                }
            }else{
                if let message = objData.text {
                    let image = UIImage(named: "bubble_se")
                    cell.imgBackground.image = image!
                        .resizableImage(withCapInsets:
                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                    
                }
            }
                    
            if let imgUrl = URL(string: objData.img) {
                cell.imgIcon.sd_setShowActivityIndicatorView(true)
                cell.imgIcon.sd_setIndicatorStyle(.gray)
                cell.imgIcon.sd_setImage(with: imgUrl, completed: nil)
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            self.showLoader()
            self.adForest_loadMoreChat(parameter: param as NSDictionary)
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
//        if isBlocked == "true"{
//            print(blockMessage)
//            let alert = Constants.showBasicAlert(message: blockMessage)
//            self.presentVC(alert)
//        }else{
//            print("Not Blocked..")
        
        guard let messageField = txtMessage.text else {
            return
        }
        if messageField == "" {
            
        } else {
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]
            print(parameter)
            self.adForest_sendMessage(param: parameter as NSDictionary)
            self.showLoader()
        }
      //}
    }
    
    @IBAction func actionNotificationName(_ sender: UIButton) {
        let addDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        addDetailVc.ad_id = Int(ad_id)!
        self.navigationController?.pushViewController(addDetailVc, animated: true)

    }
    
    //MARK:- API Call
    
    func adForest_getChatData(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
                self.btn_text = successResponse.data.btnText
                self.dataArray = self.reverseArray.reversed()
                self.adForest_populateData()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.tableView.setEmptyMessage("")
                self.btnBlock.setTitle( self.btn_text, for: .normal)
//                if isBlocked == "true"{
//                          btnBlock.setTitle("UnBlock", for: .normal)
//                      }else{
//                           btnBlock.setTitle("Block", for: .normal)
//                      }
            }
            else {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                 self.tableView.reloadData()
                //self.tableView.backgroundView?.isHidden = true
                self.btn_text = successResponse.data.btnText
                self.btnBlock.setTitle( self.btn_text, for: .normal)
                self.tableView.setEmptyMessage(successResponse.message)
            }
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)

        }
    }
    
    //Load More Chat
    func adForest_loadMoreChat(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(successResponse)
            if successResponse.success {
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
                
                self.dataArray.append(contentsOf: self.reverseArray.reversed())
                self.tableView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //send message
    func adForest_sendMessage(param: NSDictionary) {
        UserHandler.sendMessage(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.txtMessage.text = ""
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
               
                self.dataArray = self.reverseArray.reversed()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.heightConstraintTxtView.constant = 40
                self.heightContraintViewBottom.constant = 40
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adForest_blockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.blockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
               // let alert = Constants.showBasicAlert(message: successResponse.message)
               // self.presentVC(alert)
          
                var ok = ""
                
                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)
                    
                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }
                
                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { (ok) in
                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                                         print(parameter)
                        self.userBlocked = true
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                }
                al.addAction(btnOk)
                self.presentVC(al)
                
                //self.btnBlock.setTitle("UnBlock", for: .normal)
                self.isBlocked = "true"
        
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    
    func adForest_UnblockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.UnblockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                
                var ok = ""
                
                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)
                    
                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }
                
                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { (ok) in
                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    print(parameter)
                    self.userBlocked = false
                    self.adForest_getChatData(parameter: parameter as NSDictionary)
                }
                al.addAction(btnOk)
                self.presentVC(al)
                
               // self.btnBlock.setTitle("Block", for: .normal)
                self.isBlocked = "false"
                
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}


class SenderCell: UITableViewCell {

    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewBg: UIView!
    let label =  UILabel()
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        selectionStyle = .none
        self.txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //self.imgPicture.layer.cornerRadius = 15
        self.imgPicture.clipsToBounds = true
        //imgPicture.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)
        
        //showIncomingMessage()
    }
   
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgIcon: UIImageView!{
        didSet{
            imgIcon.round()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //self.imgBackground.layer.cornerRadius = 15
        self.imgBackground.clipsToBounds = true
    }
   
}

public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
