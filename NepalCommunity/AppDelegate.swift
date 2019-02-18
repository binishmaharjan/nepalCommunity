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
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var homeBarNavigation: UINavigationController?
  var tabBarController : NCTabViewController?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //Firebase Server
    setupFirebaseServer(application,launchOptions)
    setupGoogleAuthentication()
    
    //Setting up initial windows
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    let tabBar = NCTabViewController()
    self.tabBarController = tabBar
    window?.rootViewController = tabBar
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                             annotation: [:])
    //For Facebook
    //    return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
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

extension AppDelegate : GIDSignInDelegate, NCSignUpAndSignIn, NCDatabaseWrite{
  
  private func setupGoogleAuthentication(){
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    NCActivityIndicator.shared.start(view: (NCPager.shared.currentViewController?.view!)!)
    if let error = error{
      Dlog(error.localizedDescription)
      NCActivityIndicator.shared.stop()
      return
    }
    
    guard let authentication = user.authentication else {return}
    let credentitial = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    self.loginWithGoogle(credential: credentitial) { (username, uid, email, url, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        NCActivityIndicator.shared.stop()
        return
      }
      
      guard let username = username,
        let uid = uid,
        let email = email,
        let url = url
        else {
          NCActivityIndicator.shared.stop()
          Dlog("No Google Data")
          return
      }
      self.writeGooglUser(userId: uid, username: username, iconUrl: url, email: email, completion: { (error) in
        if let error = error{
          Dlog(error.localizedDescription)
          NCActivityIndicator.shared.stop()
        }
        NCSessionManager.shared.userLoggedIn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
          NCNotificationManager.postDismissLogin()
          NCActivityIndicator.shared.stop()
        })
        Dlog("Successful")
      })
    }
    
  }
}

