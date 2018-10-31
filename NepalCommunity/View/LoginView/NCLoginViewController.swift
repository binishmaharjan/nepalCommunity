//
//  NCLoginViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCLoginViewController: NCViewController{
  //Main View
  private var mainView: NCLoginView?
  private var mainViewBottomConstraints: Constraint?
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.red
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
    self.statusBarStyle = .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupConstraints()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    self.setupNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tearDownNotification()
  }
  
  private func setup(){
    let mainView = NCLoginView()
    self.mainView = mainView
    mainView.backgroundColor = NCColors.white
    mainView.signUpDelegate = self
    mainView.delegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.topToSuperview(usingSafeArea : true)
    mainView.leftToSuperview(usingSafeArea : true)
    mainView.rightToSuperview(usingSafeArea : true)
    mainViewBottomConstraints = mainView.bottomToSuperview()
  }
  
}

//MARK: Button Delegate
extension NCLoginViewController : NCLoginViewDelegate, NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.signInBtn{
      Dlog("Sign In")
    }else if view == mainView?.fbBtn{
      Dlog("FB Sign in")
    }
  }
  
  func signUpButtonPressed() {
    let vc = NCSignUpViewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: Notification
extension NCLoginViewController{
  private func setupNotification(){
    self.tearDownNotification()
    NCNotificationManager.receive(keyboardWillHide: self, selector: #selector(keyboardWillHide(_:)))
    NCNotificationManager.receive(keyboardWillShow: self, selector: #selector(keyboardWilShow(_:)))
  }
  
  private func tearDownNotification(){
    NCNotificationManager.remove(self)
  }
  
  @objc func keyboardWilShow(_ notification : Notification){
    guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let mainViewBottomConstraints = self.mainViewBottomConstraints else { return }
    
    let h = frame.height - self.view.safeAreaInsets.bottom
    mainViewBottomConstraints.constant = -h
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  @objc func keyboardWillHide(_ notification: Notification){
    guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let mainViewBottomConstraints = self.mainViewBottomConstraints else { return }
    
    let h:CGFloat = 0
    mainViewBottomConstraints.constant = h
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.view.layoutIfNeeded()
    })
  }
}
