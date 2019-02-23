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
  private weak var notificationAlertView : UIView?
  private let NOTI_TAB_NUMBER : Int = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTabBar()
    delegate  = self
    
    let homeView = NCHomeController()
    let homeNav = NCNaviagtionController(rootViewController: homeView)
    homeView.view.backgroundColor = .white
    homeView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V,
                                                   left: TabViewConstants.TAB_ITEM_OFF_H,
                                                   bottom: -TabViewConstants.TAB_ITEM_OFF_V,
                                                   right: TabViewConstants.TAB_ITEM_OFF_H)
    homeView.title = nil
    homeView.tabBarItem.image = UIImage(named:"icon_home")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    homeView.tabBarItem.selectedImage = UIImage(named:"icon_home_h")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    let categoryView = NCDummyViewController()
    categoryView.tabBarItem.image = UIImage(named: "icon_plus")?.withRenderingMode(.alwaysOriginal)
    categoryView.view.backgroundColor = .white
    categoryView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V,
                                                       left: TabViewConstants.TAB_ITEM_OFF_H,
                                                       bottom: -TabViewConstants.TAB_ITEM_OFF_V,
                                                       right: TabViewConstants.TAB_ITEM_OFF_H)
    categoryView.title = nil
    
    let searchView = NCSearchController()
    let searchNav = NCNaviagtionController(rootViewController: searchView)
    searchView.view.backgroundColor = .white
    searchView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V,
                                                     left: TabViewConstants.TAB_ITEM_OFF_H,
                                                     bottom: -TabViewConstants.TAB_ITEM_OFF_V,
                                                     right: TabViewConstants.TAB_ITEM_OFF_H)
    searchView.title = nil
    searchView.tabBarItem.image = UIImage(named:"icon_search")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    searchView.tabBarItem.selectedImage = UIImage(named:"icon_search_h")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    let notificationView = NCNotificationController()
    let notificationNav = NCNaviagtionController(rootViewController: notificationView)
    notificationView.view.backgroundColor = .white
    notificationView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V,
                                                           left: TabViewConstants.TAB_ITEM_OFF_H,
                                                           bottom: -TabViewConstants.TAB_ITEM_OFF_V,
                                                           right: TabViewConstants.TAB_ITEM_OFF_H)

    notificationView.title = nil
    notificationView.tabBarItem.image = UIImage(named:"icon_bell")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    notificationView.tabBarItem.selectedImage = UIImage(named:"icon_bell_h")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    let meView = NCProfileController()
    let meNav = NCNaviagtionController(rootViewController: meView)
    meView.view.backgroundColor = .white
    meView.tabBarItem.imageInsets = UIEdgeInsets(top: TabViewConstants.TAB_ITEM_OFF_V,
                                                 left: TabViewConstants.TAB_ITEM_OFF_H,
                                                 bottom: -TabViewConstants.TAB_ITEM_OFF_V,
                                                 right: TabViewConstants.TAB_ITEM_OFF_H)
    meView.title = nil
    meView.tabBarItem.image = UIImage(named:"icon_user")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    meView.tabBarItem.selectedImage = UIImage(named:"icon_user_h")?
      .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    self.tabBar.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    
    self.viewControllers = [homeNav,searchNav,categoryView,notificationNav,meNav]
    
    
    let notificationTabBar = tabBar.subviews[NOTI_TAB_NUMBER]
    notificationTabBar.subviews.forEach{(view) in
      guard let icon = view as? UIImageView else {return}
      
      let notificationAlertView = UIView()
      self.notificationAlertView  = notificationAlertView
      notificationAlertView.backgroundColor = NCColors.red
      notificationAlertView.layer.cornerRadius = 5
      view.addSubview(notificationAlertView)
      notificationAlertView.height(TabViewConstants.BADGE_SIZE)
      notificationAlertView.width(TabViewConstants.BADGE_SIZE)
      notificationAlertView.top(to: icon, offset : 5)
      notificationAlertView.right(to: icon)
      notificationAlertView.alpha = 0.0
    }
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
//    self.setupMiddleButton()
    
  }
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    
    if viewController is NCDummyViewController{
      let createPostVC = NCCreateARrticleController()
      self.present(createPostVC, animated: true, completion: nil)
      return false
    }else{
      return true
    }
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
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user == nil{
        NCPager.shared.showLoginPage()
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

//MARK: Badge
extension NCTabViewController{
  func showBadge(isShow : Bool){
    guard let badge = self.notificationAlertView else {return}
    badge.alpha = isShow ? 1.0 : 0.0
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
    static let BADGE_SIZE : CGFloat = 10
  }
}
