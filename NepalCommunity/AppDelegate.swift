//
//  AppDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/24.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var homeBarNavigation: UINavigationController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //Firebase Server
    setupFirebaseServer(application,launchOptions)
    
    //Setting up initial windows
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    let tabBar = NCTabViewController()
    window?.rootViewController = tabBar
    
    return true
  }
  
//  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//  }
  
//  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//    let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//    // Add any custom logic here.
//    return handled
//  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
  }

  
}


//MARK: Firebase Server Setup
extension AppDelegate{
  private func setupFirebaseServer(_ application : UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
    var firebasePlistName = ""
    
    if IS_DEBUG {
      firebasePlistName = "GoogleService-Info-dev"
    } else {
      firebasePlistName = "GoogleService-Info"
    }
    if let path = Bundle.main.path(forResource: firebasePlistName, ofType: "plist"), let firbaseOptions = FirebaseOptions(contentsOfFile: path) {
      FirebaseApp.configure(options: firbaseOptions)
      FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //Download Session User Data
    setupSessionUser()
  }
  
  private func setupSessionUser(){
    if let _ = Auth.auth().currentUser{
      NCSessionManager.shared.userLoggedIn()
    }else{
      Dlog("Not Logged In")
    }
  }
}

