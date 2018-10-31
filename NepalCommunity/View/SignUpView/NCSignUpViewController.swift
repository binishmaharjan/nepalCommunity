//
//  NCSignUpViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import Firebase
import FirebaseAuth
import FirebaseFirestore


class NCSignUpViewController: NCViewController{
  //MARK: Main View
  private var mainView: NCSignUpView?
  private var mainViewBottomConstraints: Constraint?
  
  //MARK : Functions
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
    let mainView = NCSignUpView()
    self.mainView = mainView
    mainView.backgroundColor = NCColors.white
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
extension NCSignUpViewController: NCButtonDelegate, NCEmailSignUpProtocol, NCDatabaseWriteProtocol{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.backBtn{
      self.navigationController?.popViewController(animated: true)
    }else if view == mainView?.signUpBtn{
      emailSignUp()
    }else if view == mainView?.cameraIcon{
      Dlog("Camera Icon Pressed")
    }
  }
  
  
  private func emailSignUp(){
    guard let mainView = self.mainView,
          let usernameField = mainView.usernameField,
          let passwordField = mainView.passwordField,
          let emailField = mainView.emailField,
          let username = usernameField.text,
          let password = passwordField.text,
          let email = emailField.text else { return }
    if username.count <= 0{
      Dlog("Input Error")
      return
    }
    if password.count <= 0{
      Dlog("Input Error")
      return
    }
    if email.count <= 0{
      Dlog("Input Error")
      return
    }
    
    //Registering User with email
    self.registerEmail(email: email, password: password, username: username) { (userId, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        return
      }
      guard let userId = userId else {
        Dlog("No User")
        return
      }
      //Writing the data to the database
      self.writeEmailUser(userId: userId, username: username, iconUrl: "Icon_URl", completion: { (error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        self.navigationController?.popViewController(animated: true)
      })
    }
  }
}

//MARK: Keyboard
extension NCSignUpViewController{
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

