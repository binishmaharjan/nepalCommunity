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
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTabBar()
    
    let homeView = NCHomeController()
    let homeNav = UINavigationController(rootViewController: homeView)
    homeView.view.backgroundColor = .white
    homeView.tabBarItem.image = UIImage(named: "icon_home")
    homeView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V, left: TabViewConstants.TAB_ITEM_OFF_H, bottom: -TabViewConstants.TAB_ITEM_OFF_V, right: TabViewConstants.TAB_ITEM_OFF_H)
    homeView.title = nil
    appDelegate.homeBarNavigation = homeNav
    
    let categoryView = UIViewController()
    categoryView.view.backgroundColor = .white
    categoryView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V, left: TabViewConstants.TAB_ITEM_OFF_H, bottom: -TabViewConstants.TAB_ITEM_OFF_V, right: TabViewConstants.TAB_ITEM_OFF_H)
    categoryView.title = nil
    
    let searchView = UIViewController()
    searchView.view.backgroundColor = .white
    searchView.tabBarItem.image = UIImage(named: "icon_search")
    searchView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V, left: TabViewConstants.TAB_ITEM_OFF_H, bottom: -TabViewConstants.TAB_ITEM_OFF_V, right: TabViewConstants.TAB_ITEM_OFF_H)
    searchView.title = nil
    
    let notificationView = UIViewController()
    notificationView.view.backgroundColor = .white
    notificationView.tabBarItem.image = UIImage(named: "icon_bell")
    notificationView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V, left: TabViewConstants.TAB_ITEM_OFF_H, bottom: -TabViewConstants.TAB_ITEM_OFF_V, right: TabViewConstants.TAB_ITEM_OFF_H)
    notificationView.title = nil
    
    let meView = UIViewController()
    meView.view.backgroundColor = .white
    meView.tabBarItem.image = UIImage(named: "icon_user")
    meView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V, left: TabViewConstants.TAB_ITEM_OFF_H, bottom: -TabViewConstants.TAB_ITEM_OFF_V, right: TabViewConstants.TAB_ITEM_OFF_H)
    meView.title = nil
    
    self.tabBar.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    
    self.viewControllers = [homeNav,searchView,categoryView,notificationView,meView]
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
    shadowLayer.shadowOffset = TabViewConstants.SHADOW_OFFSET
    shadowLayer.shadowRadius = TabViewConstants.SHADOW_RADIUS
    shadowLayer.shadowOpacity = TabViewConstants.SHADOW_OPACITY
    
    //Middle Button
    self.setupMiddleButton()
    
  }
  
  //Setting Up Middle Bar
  private func setupMiddleButton() {
    let middleButtonBG = UIView()
    view.addSubview(middleButtonBG)
    
    
    let middleButton = UIButton()
    middleButtonBG.addSubview(middleButton)
    
    middleButtonBG.height(TabViewConstants.MIDDLE_BUTTON_SIZE)
    middleButtonBG.width(TabViewConstants.MIDDLE_BUTTON_SIZE)
    middleButtonBG.centerXToSuperview()
    middleButtonBG.top(to: tabBar, offset : -TabViewConstants.MIDDLE_BUTTON_OFFSET)
    middleButtonBG.layer.cornerRadius = TabViewConstants.MIDDLE_BUTTON_SIZE / 2
    middleButtonBG.backgroundColor = NCColors.blue
    
    
    middleButton.setImage(UIImage(named: "icon_speaker"), for: .normal)
    middleButton.setImage(UIImage(named: "icon_speaker"), for: .highlighted)
    middleButton.addTarget(self, action: #selector(tabMiddleButtonPressed), for: .touchUpInside)
    middleButton.edgesToSuperview()
    
    view.layoutIfNeeded()
    
    let shadowLayer: CALayer = middleButtonBG.layer
    shadowLayer.shadowColor = NCColors.black.cgColor
    shadowLayer.shadowOffset = TabViewConstants.SHADOW_OFFSET
    shadowLayer.shadowRadius = TabViewConstants.SHADOW_RADIUS
    shadowLayer.shadowOpacity = TabViewConstants.SHADOW_OPACITY
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}


//MARK: Tab bar pressed
extension NCTabViewController: UITabBarControllerDelegate{
  @objc func tabMiddleButtonPressed(){
    let createPostVC = NCCreateARrticleController()
    self.present(createPostVC, animated: true, completion: nil)
  }
}

//MARK: Constant
extension NCTabViewController{
  class TabViewConstants{
    static let SHADOW_RADIUS : CGFloat = 1.0
    static let SHADOW_OPACITY : Float = 0.1
    static let SHADOW_OFFSET : CGSize = CGSize(width: 0.0, height: -1.0)
    static let MIDDLE_BUTTON_SIZE : CGFloat = 71
    static let MIDDLE_BUTTON_OFFSET : CGFloat = 20
    static let TAB_ITEM_OFF_V : CGFloat = 6
    static let TAB_ITEM_OFF_H : CGFloat = 0
  }
}
