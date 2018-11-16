//
//  HomeViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/09.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import FirebaseAuth

class NCTabViewController : UITabBarController{
  
  //handler to the state change of the Auth user
  private var handle: AuthStateDidChangeListenerHandle?
  
  //MARK: Variables
  private var askButtonBG: UIView?
  private var askButton: UIButton?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTabBar()
    
    let homeView = NCHomeViewController()
    let homeNav = UINavigationController(rootViewController: homeView)
    homeView.view.backgroundColor = .white
    homeView.tabBarItem.image = UIImage(named: "icon_home")
    homeView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    homeView.title = nil
    
    let categoryView = UIViewController()
    categoryView.view.backgroundColor = .white
    categoryView.tabBarItem.image = UIImage(named: "icon_category")
    categoryView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    categoryView.title = nil
    
    let searchView = UIViewController()
    searchView.view.backgroundColor = .white
    searchView.tabBarItem.image = UIImage(named: "icon_search")
    searchView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    searchView.title = nil
    
    let notificationView = UIViewController()
    notificationView.view.backgroundColor = .white
    notificationView.tabBarItem.image = UIImage(named: "icon_bell")
    notificationView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    notificationView.title = nil
    
    let meView = UIViewController()
    meView.view.backgroundColor = .white
    meView.tabBarItem.image = UIImage(named: "icon_user")
    meView.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    meView.title = nil
    
    self.tabBar.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    
    self.viewControllers = [homeNav,categoryView,searchView,notificationView,meView]
    setupAskButton()
    setupAskButtonConstraints()

  }
  
  private func setupTabBar(){
    //Tab Bar Appearance
    let tabBar = UITabBar.appearance()
    tabBar.barTintColor = NCColors.white
    tabBar.tintColor = NCColors.blue
    
    tabBar.isTranslucent = false
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
    
    //Tab Bar Item Appearance
    let tabBarItem = UITabBarItem.appearance()
    tabBarItem.setTitleTextAttributes([.foregroundColor: NCColors.grey], for: .normal)
    tabBarItem.setTitleTextAttributes([.foregroundColor: NCColors.blue], for: .selected)
    tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
    
    //Add Shadow
    let shadowLayer: CALayer = self.tabBar.layer
    shadowLayer.shadowColor = NCColors.black.cgColor
    shadowLayer.shadowOffset = CGSize(width: 0.0, height: -1.0)
    shadowLayer.shadowRadius = 1
    shadowLayer.shadowOpacity = 0.1
    
  }
  
//
//  @objc func signoutButtonPressed(){
//    let firebaseAuth = Auth.auth()
//    do{
//      try firebaseAuth.signOut()
//    }catch{
//      debugPrint("Error signing out \(error.localizedDescription)")
//    }
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user == nil{
        let loginvc = UINavigationController(rootViewController: NCLoginViewController())
        self.present(loginvc, animated: true, completion: nil)
      }else{
//        User is logged in
      }
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  
  //MARK: Setup Ask Button
  private func setupAskButton(){
    let askButtonBG = UIView()
    self.askButtonBG = askButtonBG
    askButtonBG.backgroundColor = NCColors.blue
    askButtonBG.layer.cornerRadius = 60/2
    askButtonBG.dropShadow()
    self.view.addSubview(askButtonBG)
    
    let askButton = UIButton()
    self.askButton = askButton
    askButton.setImage(UIImage(named: "icon_speaker"), for: .normal)
    askButton.setImage(UIImage(named: "icon_speaker"), for: .highlighted)
    askButtonBG.addSubview(askButton)
    
  }
  
  private func setupAskButtonConstraints(){
    guard let askButtonBG = self.askButtonBG,
      let askButton = self.askButton else { return }
    
    askButtonBG.width(60)
    askButtonBG.height(to: askButtonBG, askButtonBG.widthAnchor)
    askButtonBG.bottomToTop(of: self.tabBar, offset: -10)
    askButtonBG.rightToSuperview(offset : -10)
    
    askButton.width(50)
    askButton.height(to: askButton, askButton.widthAnchor)
    askButton.centerInSuperview()
  }
}
