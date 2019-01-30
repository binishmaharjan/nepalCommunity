//
//  NCPager.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/30.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit

class NCPager{
  var currentViewController:UIViewController?
  var backViewController:UIViewController?
  var rootViewController:UIViewController?{return appDelegate.tabBarController}
  private var isLock:Bool = false
  
  private var showDetailAids:[String] = []
  private var showDetailQids:[String] = []
  
  static let shared = NCPager()
  
  private func lock(callback:(()->Void)) {
    guard !isLock else{ return }
    self.isLock = true
    callback()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      self.isLock = false
    }
  }
}

extension NCPager{
  
  func present(viewController: UIViewController, animated: Bool = true, isOverCurrentContext: Bool = false) {
    self.transitionView(viewController: viewController, animated: animated, isPush: false, isOverCurrentContext: isOverCurrentContext)
  }
  
  func push(viewController: UIViewController, animated: Bool = true) {
    self.transitionView(viewController: viewController, animated: animated, isPush: true)
  }
  
  func transitionView(viewController: UIViewController, animated: Bool = true, isPush:Bool = true, isOverCurrentContext: Bool = false) {
    
    func tabTransition(tab:UITabBarController){
      self.backViewController = currentViewController
      DispatchQueue.main.async {
        tab.present(viewController, animated: animated)
      }
    }
    
    func navTransition(nav:UINavigationController, isPush:Bool){
      //呼び出し元のviewcontrollerを保持しておく
      //overCurrentContextだとこのモーダルが閉じてもviewdidappearなどが呼ばれないため
      //カメラ画面を一気に閉じるため
      //MQAnswerCommentsViewControllerがMQNotificationListViewConstrollerから遷移してきたかどうか判断するため
      self.backViewController = currentViewController
      if isPush{
        DispatchQueue.main.async {
          nav.pushViewController(viewController, animated: animated)
        }
      }
      else{
        DispatchQueue.main.async {
          nav.present(viewController, animated: animated)
        }
      }
    }
    
    func vcTransition(vc:UIViewController){
      //呼び出し元のviewcontrollerを保持しておく
      //overCurrentContextだとこのモーダルが閉じてもviewdidappearなどが呼ばれないため
      //カメラ画面を一気に閉じるため
      //MQAnswerCommentsViewControllerがMQNotificationListViewConstrollerから遷移してきたかどうか判断するため
      self.backViewController = currentViewController
      DispatchQueue.main.async {
        vc.present(viewController, animated: animated)
      }
    }
    
    lock {
      guard let cvc = self.currentViewController else {return}
      
      if let tab = cvc.tabBarController, isOverCurrentContext{
        tabTransition(tab: tab)
        return
      }
      else if let nav = cvc.navigationController{
        navTransition(nav: nav, isPush: isPush)
        return
      }
      else{
        vcTransition(vc: cvc)
      }
    }
  }
  
  func popToRootViewController(currentViewController:UIViewController? = nil, animated:Bool = true, completion:(()->())? = nil) {
    lock {
      if currentViewController != nil{
        self.currentViewController = currentViewController
      }
      guard let cv = self.currentViewController else { return  }
      if let nav = cv.navigationController {
        nav.popToRootViewController(animated: animated, completion: completion)
        return
      }
      if let nav = cv.tabBarController?.navigationController{
        nav.popToRootViewController(animated: animated, completion: completion)
        return
      }
    }
  }
  
  func pop(animated:Bool = true, completion:(()->())? = nil) {
    lock {
      guard let cv = self.currentViewController else { return  }
      if let nav = cv.navigationController {
        nav.popViewController(animated: animated, completion: completion)
        return
      }
      if let nav = cv.tabBarController?.navigationController{
        nav.popViewController(animated: animated, completion: completion)
        return
      }
    }
  }
}

//MARK: - dismiss
extension NCPager{
  func dismissModal(count:Int = 1, animated:Bool = true, completion:(()->())? = nil){
    guard count > 0 else {
      completion?()
      return
    }
    
    var vc:UIViewController? = self.currentViewController
    var c:Int = 1
    while(vc?.presentingViewController != nil){
      if count <= c{
        break
      }
      vc = vc?.presentingViewController
      c += 1
    }
    vc?.dismiss(animated: animated, completion: completion)
  }
  
  func dismissAllModal(animated:Bool, completion:(()->())? = nil){
    var vc:UIViewController? = self.currentViewController
    while(vc?.presentingViewController != nil){
      vc = vc?.presentingViewController
    }
    vc?.dismiss(animated: animated, completion: completion)
  }
  
  func dismissOverCurrentContextModal(vc: NCViewController?, animated: Bool = true, completion: (()->())? = nil){
    guard let vc = vc else { return }
    vc.dismiss(animated: animated, completion: {
      self.backViewController?.viewWillAppear(animated)
      completion?()
    })
  }
  
}
