//
//  NCLoginViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import GoogleSignIn


class NCLoginViewController: NCViewController{
  //Main View
  private var mainView: NCLoginView?
  private var mainViewBottomConstraints: Constraint?
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.white
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
    self.statusBarStyle = .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupConstraints()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    self.setupNotification()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tearDownNotification()
  }
  
  private func setup(){
    let mainView = NCLoginView()
    self.mainView = mainView
    mainView.backgroundColor = NCColors.white
    mainView.signUpDelegate = self
    mainView.delegate = self
    self.view.addSubview(mainView)
    
    GIDSignIn.sharedInstance()?.uiDelegate = self
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
extension NCLoginViewController : NCLoginViewDelegate, NCButtonDelegate, NCSignUpAndSignIn, NCDatabaseWrite, NCStorage, GIDSignInUIDelegate{
  func buttonViewTapped(view: NCButtonView) {
    /*
     Sign in with email
     */
    if view == mainView?.signInBtn{
      NCActivityIndicator.shared.start(view: self.view)
      guard let email = self.mainView?.emailField?.text,
        let password = self.mainView?.passwordField?.text else {
          NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showError(message: "Empty Fields")
          return
      }
      loginWithEmail(email: email, password: password) { (error) in
        if let error = error {
          NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showError(message: error.localizedDescription)
          return
        }
        //Login Successful
        NCActivityIndicator.shared.stop()
        NCSessionManager.shared.userLoggedIn()
        //self.dismiss(animated: true, completion: nil)
        NCPager.shared.dismissModal()
      }
    }
      /*
       Sign in with Google
       */
    else if view == mainView?.fbBtn{
      Dlog("Google Login")
      self.registerWithGoogle(completion: nil)
    }
  }
  
  //Sign up new email user button is pressed
  func signUpButtonPressed() {
    NCPager.shared.showSignUpView()
  }
}

//MARK: SignUp Functions
extension NCLoginViewController{
  
  func registerWithGoogle(completion : ((Error?)->())?){
    Dlog("Google Registration")
    GIDSignIn.sharedInstance()?.signIn()
  }
  
  private func facebookSignUpFunction(){
    //Start the indicator
    NCActivityIndicator.shared.start(view: self.view)
    //Register with Facebook
    self.registerWithFacebook(viewController: self) { (error) in
      if let error = error {
        NCActivityIndicator.shared.stop()
        NCDropDownNotification.shared.showError(message: error.localizedDescription)
        return
      }
      //If successful, login with the facebook
      self.loginWithFacebook(completion: { (error) in
        if let error = error {
          NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showError(message: error.localizedDescription)
          return
        }
        //Get the information form the facebook
        self.fetchFacebookUser(completion: { (name, uid, email, image, error) in
          if let error = error {
            NCActivityIndicator.shared.stop()
            NCDropDownNotification.shared.showError(message: error.localizedDescription)
            return
          }
          
          guard let name = name,
            let uid = uid,
            let email = email,
            let image = image else {
              NCActivityIndicator.shared.stop()
              NCDropDownNotification.shared.showError(message: "Fetch Error")
              return
          }
          //Once image is downloaded, save the image to the storage
          self.saveImageToStorage(image: image, userId: uid, completion: { (url, error) in
            if let error = error {
              NCActivityIndicator.shared.stop()
              NCDropDownNotification.shared.showError(message: error.localizedDescription)
              return
            }
            
            guard let url = url else {
              NCActivityIndicator.shared.stop()
              NCDropDownNotification.shared.showError(message: "URL Error")
              return
            }
            
            //If save is successful,write the user info to the database
            self.writeFacebookUser(userId: uid, username: name, iconUrl: url, email: email, completion: { (error) in
              if let error = error {
                NCActivityIndicator.shared.stop()
                NCDropDownNotification.shared.showError(message: error.localizedDescription)
                return
              }
              NCActivityIndicator.shared.stop()
              NCSessionManager.shared.userLoggedIn()
              self.dismiss(animated: true, completion: nil)
            })
          })
        })
      })
    }
  }
}

//MARK: Notification
extension NCLoginViewController{
  private func setupNotification(){
    self.tearDownNotification()
    NCNotificationManager.receive(keyboardWillHide: self, selector: #selector(keyboardWillHide(_:)))
    NCNotificationManager.receive(keyboardWillShow: self, selector: #selector(keyboardWilShow(_:)))
    NCNotificationManager.receive(dismissLogin: self, selector: #selector(receiveDismissLogin(_:)))
  }
  
  private func tearDownNotification(){
    NCNotificationManager.remove(self)
  }
  
  @objc func receiveDismissLogin(_ notification : Notification){
    NCPager.shared.dismissModal()
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
