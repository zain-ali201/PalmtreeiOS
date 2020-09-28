//  MIT License

//  Copyright (c) 2019 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class ConversationsViewController: UIViewController {
  
  //MARK: IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    //MenuButtons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPalmtree: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var profileImageView: UIImageView!
  
  //MARK: Private properties
  private var conversations = [ObjectConversation]()
  private let manager = ConversationManager()
  private let userManager = UserManager()
  private var currentUser: ObjectUser?
    
    var isFromAdDetail = false
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if isFromAdDetail
    {
        btnBack.alpha = 1
    } else
    {
        btnBack.alpha = 0
    }
    
    if languageCode == "ar"
    {
        self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        changeMenuButtons()
        lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    fetchProfile()
    fetchConversations()
    
    self.navigationController?.navigationBar.isHidden = false
  }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func changeMenuButtons()
    {
        btnHome.setImage(UIImage(named: "home_" + languageCode ), for: .normal)
        btnPalmtree.setImage(UIImage(named: "mypalmtree_" + languageCode), for: .normal)
        btnPost.setImage(UIImage(named: "post_" + languageCode), for: .normal)
        btnWishlist.setImage(UIImage(named: "wishlist_active_" + languageCode), for: .normal)
        btnMessages.setImage(UIImage(named: "messages_" + languageCode ), for: .normal)
        
        btnHome.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPalmtree.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnWishlist.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnMessages.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }

//MARK: IBActions
    
    @IBAction func backBtnAction(_ button: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            self.navigationController?.popToViewController(homeVC, animated: false)
        }
        else if button.tag == 1002
        {
            let myAdsVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAdsController") as! MyAdsController
            self.navigationController?.pushViewController(myAdsVC, animated: false)
        }
        else if button.tag == 1003
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                if defaults.bool(forKey: "isLogin") == false
                {
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let navController = UINavigationController(rootViewController: loginVC)
                    self.present(navController, animated:true, completion: nil)
                }
                else
                {
                    adDetailObj = AdDetailObject()
                    let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostVC") as! AdPostVC
                    let navController = UINavigationController(rootViewController: adPostVC)
                    navController.navigationBar.isHidden = true
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated:true, completion: nil)
                }
            }
        }
        else if button.tag == 1004
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                let favouritesVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
                self.navigationController?.pushViewController(favouritesVC, animated: false)
            }
        }
    }
}

//MARK: Private methods
extension ConversationsViewController {
  
  func fetchConversations() {
    manager.currentConversations {[weak self] conversations in
      self?.conversations = conversations.sorted(by: {$0.timestamp > $1.timestamp})
      self?.tableView.reloadData()
      self?.playSoundIfNeeded()
    }
  }
  
  func fetchProfile() {
    userManager.currentUserData {[weak self] user in
      self?.currentUser = user
      if let urlString = user?.profilePicLink {
        self?.profileImageView.setImage(url: URL(string: urlString))
      }
    }
  }
  
  func playSoundIfNeeded() {
    guard let id = userManager.currentUserID() else { return }
    if conversations.last?.isRead[id] == false {
      AudioService().playSound()
    }
  }
}

//MARK: UITableView Delegate & DataSource
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if conversations.isEmpty
    {
        emptyView.alpha = 1
    }
    return conversations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.className) as! ConversationCell
    cell.set(conversations[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc: MessagesViewController = UIStoryboard.initial(storyboard: .messages)
    vc.conversation = conversations[indexPath.row]
    manager.markAsRead(conversations[indexPath.row])
    show(vc, sender: self)
  }
}

//MARK: ProfileViewController Delegate
extension ConversationsViewController: ProfileViewControllerDelegate {
  func profileViewControllerDidLogOut() {
    userManager.logout()
    navigationController?.dismiss(animated: true)
  }
}

//MARK: ContactsPreviewController Delegate
extension ConversationsViewController: ContactsPreviewControllerDelegate {
  func contactsPreviewController(didSelect user: ObjectUser) {
    guard let currentID = userManager.currentUserID() else { return }
    let vc: MessagesViewController = UIStoryboard.initial(storyboard: .messages)
    if let conversation = conversations.filter({$0.userIDs.contains(user.id)}).first {
      vc.conversation = conversation
      show(vc, sender: self)
      return
    }
    let conversation = ObjectConversation()
    conversation.userIDs.append(contentsOf: [currentID, user.id])
    conversation.isRead = [currentID: true, user.id: true]
    vc.conversation = conversation
    show(vc, sender: self)
  }
}
