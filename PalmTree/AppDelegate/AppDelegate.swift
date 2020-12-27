//
//  AppDelegate.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import Firebase
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import IQKeyboardManagerSwift
//import GoogleMaps
//import GooglePlacePicker
import NotificationBannerSwift
import SwiftGoogleTranslate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, NotificationBannerDelegate {
    
    var window: UIWindow?
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let keyboardManager = IQKeyboardManager.sharedManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let defaults = UserDefaults.standard
    var deviceFcmToken = "0"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SwiftGoogleTranslate.shared.start(with: googleAPIKey)
        TestFairy.begin("SDK-qTP7qCrq")
        
        Thread.sleep(forTimeInterval: 2)
        
        keyboardManager.enable = true
        self.setUpGoogleMaps()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true

        if #available(iOS 11, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                print("Granted \(granted)")
            }
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in}
            UIApplication.shared.registerForRemoteNotifications()
            application.registerForRemoteNotifications()
        }
        UIApplication.shared.registerForRemoteNotifications()

        // For Facebook and Google SignIn
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        defaults.removeObject(forKey: "isGuest")
        defaults.synchronize()
        
        UITextField.appearance().tintColor = .black
        UITextView.appearance().tintColor = .black
        
        languageCode = Locale.current.languageCode!
        
        if languageCode != "ar"
        {
            languageCode = "en"
        }
        
        return true
    }
 
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let willHandleByFacebook = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        let willHandleByGoogle =  GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
       
        
        return willHandleByGoogle || willHandleByFacebook || false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        UserDefaults.standard.set("3", forKey: "fromNotification")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        UserDefaults.standard.set("3", forKey: "fromNotification")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        AppEvents.activateApp()
        //To Check Deep Link
        deepLinker.checkDeepLink()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
        UserDefaults.standard.set("3", forKey: "fromNotification")
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AdForest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
extension AppDelegate {
    //MARK:- For Google Places Search
    func setUpGoogleMaps() {
//        let googleMapsApiKey = Constants.googlePlacesAPIKey.placesKey
//        GMSServices.provideAPIKey(googleMapsApiKey)
//        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
    }
}

extension AppDelegate
{
    func customizeNavigationBar(barTintColor: UIColor)
    {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.isTranslucent = false
        appearance.barTintColor = barTintColor
        //appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.systemFontSize]
        appearance.barStyle = .blackTranslucent
    }
    
    func moveToHome()
    {
        
    }
    
    func moveToLogin() {
        let loginVC = storyboard.instantiateViewController(withIdentifier: LoginViewController.className) as! LoginViewController
        let nav: UINavigationController = UINavigationController(rootViewController: loginVC)
         nav.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    
    func presentController(ShowVC: UIViewController) {
        self.window?.rootViewController?.presentVC(ShowVC)
    }
    
    func dissmissController() {
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func popController() {
        self.window?.rootViewController?.navigationController?.popViewController(animated: true)
    }
    
    func pushController(controller: UIViewController) {
        self.window?.rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AppDelegate
{
    // MARK: UNUserNotificationCenter Delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //  let content = notification.request.content
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("Open App")
        case "chat":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let obj = storyboard.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
            
            window?.rootViewController = obj
            window?.makeKeyAndVisible()
            completionHandler()
        default:
            break
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
        
//        if let refreshedToken = InstanceID.instanceID().token() {
//            print("Firebase: InstanceID token: \(refreshedToken)")
//            self.deviceFcmToken = refreshedToken
//            let defaults =  UserDefaults.standard
//            defaults.setValue(deviceToken, forKey: "fcmToken")
//            defaults.synchronize()
//        }else{
//            
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    
    func application(_ application: UIApplication, didrequestAuthorizationRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
        
        let token = deviceToken.base64EncodedString()
        
        let fcmToken = Messaging.messaging().fcmToken
        print("Firebase: FCM token: \(fcmToken ?? "")")
        
        print("Firebase: found token \(token)")
        
        print("Firebase: found token \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        switch application.applicationState {
        case .active: break
            
        case .background: break
            
        case .inactive: break
            
        default:
            break
        }
        
        print("Firebase: user info \(userInfo)")
        switch application.applicationState {
        case .active:
            break
        case .background, .inactive:
            break
        }
        let gcmMessageIDKey = "gcm.message_id"
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("mtech Message ID: \(messageID)")
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let fcmToken = Messaging.messaging().fcmToken
        let defaults = UserDefaults.standard
        defaults.set(fcmToken, forKey: "fcmToken")
        defaults.synchronize()
    }
    
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("received remote notification")
//    }
    
  
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        print("Received data message: \(remoteMessage.appData)")
        
        guard let topic = remoteMessage.appData[AnyHashable("topic")] as? String else {
            return
        }
        
        if topic == "chat"{
            
            guard let adID = remoteMessage.appData[AnyHashable("adId")]as? String else  {
                return
            }
            guard let textFrom = remoteMessage.appData[AnyHashable("from")] as? String else {
                return
            }
            guard let textTitle = remoteMessage.appData[AnyHashable("title")] as? String else  {
                return
            }
            guard let userMessage = remoteMessage.appData[AnyHashable("message")] as? String else {
                return
            }
            guard let senderID = remoteMessage.appData[AnyHashable("senderId")] as? String else {
                return
            }
            guard let receiverID = remoteMessage.appData[AnyHashable("recieverId")] as? String else {
                return
            }
            guard let type = remoteMessage.appData[AnyHashable("type")] as? String else {
                return
            }
            
            let state = UIApplication.shared.applicationState
            
            if state == .background {
                
            }
                
            else if state == .inactive {
                
            }
                
            else if state == .active {
                
            }
            
            let  banner = NotificationBanner(title: textTitle, subtitle: userMessage, style: .success)
            banner.autoDismiss = true
            banner.delegate = self
            banner.show()
            banner.onTap = {
                if topic == "broadcast" {
                    banner.dismiss()
                    self.moveToHome()
                }
                if topic == "chat" {
                    banner.dismiss()
                    
                    let chatVC = self.storyboard.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
                    let nav: UINavigationController = UINavigationController(rootViewController: chatVC)
                    
                    self.window?.rootViewController = nav
                    UserDefaults.standard.set("1", forKey: "fromNotification")
                    self.window?.makeKeyAndVisible()
                }
            }
            banner.onSwipeUp = {
                banner.dismiss()
            }
            
        }
        else
        {
            guard let data = remoteMessage.appData[AnyHashable("data")]as? String else  {
                return
            }
            
            let dict = convertToDictionary(text: data)
            print("Dictionary is: \(dict!)")
            let title = dict!["title"] as! String
            let message = dict!["message"] as! String
            
            let  banner = NotificationBanner(title: title, subtitle:message, style: .success)
            banner.autoDismiss = true
            banner.delegate = self
            banner.show()
            banner.onTap = {
                if topic == "broadcast" {
                    banner.dismiss()
                    self.moveToHome()
                }
                if topic == "chat" {
                    banner.dismiss()
                    
                    let chatVC = self.storyboard.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
                    let nav: UINavigationController = UINavigationController(rootViewController: chatVC)
                   
                    self.window?.rootViewController = nav
                    UserDefaults.standard.set("1", forKey: "fromNotification")
                    self.window?.makeKeyAndVisible()
                }
            }
            
            banner.onSwipeUp = {
                banner.dismiss()
            }
        }
    }

    
    
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {

override func localizedString(forKey key: String,
                              value: String?,
                              table tableName: String?) -> String {

    guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
        let bundle = Bundle(path: path) else {
        return super.localizedString(forKey: key, value: value, table: tableName)
    }

    return bundle.localizedString(forKey: key, value: value, table: tableName)
  }
}

extension Bundle {

class func setLanguage(_ language: String) {

    defer {
        object_setClass(Bundle.main, AnyLanguageBundle.self)
    }

    objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
