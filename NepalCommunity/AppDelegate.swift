//
//  AppDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/24.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    //Setting up initial windows
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = UINavigationController(rootViewController: NCLoginViewController())
    
    //Firebase Server
    setupFirebaseServer()
    
    return true
  }
  
}


//MARK: Firebase Server Setup
extension AppDelegate{
  private func setupFirebaseServer(){
    var firebasePlistName = ""
    
    if IS_DEBUG {
      firebasePlistName = "GoogleService-Info-dev"
    } else {
      firebasePlistName = "GoogleService-Info"
    }
    if let path = Bundle.main.path(forResource: firebasePlistName, ofType: "plist"), let firbaseOptions = FirebaseOptions(contentsOfFile: path) {
      FirebaseApp.configure(options: firbaseOptions)
    }
  }
}

