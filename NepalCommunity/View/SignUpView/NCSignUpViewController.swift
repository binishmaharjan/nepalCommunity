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
import NVActivityIndicatorView
import Gallery
import FirebaseStorage

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
extension NCSignUpViewController: NCButtonDelegate, NCSignUpAndSignIn, NCDatabaseWrite, NCStorage{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.backBtn{
      self.navigationController?.popViewController(animated: true)
    }else if view == mainView?.signUpBtn{
      emailSignUp()
    }else if view == mainView?.cameraIcon{
      self.presentPicker()
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
      NCDropDownNotification.shared.showError(message: LOCALIZE("Error : Empty Fields"))
      return
    }
    if password.count <= 0{
      NCDropDownNotification.shared.showError(message: LOCALIZE("Error : Empty Fields"))
      return
    }
    if email.count <= 0{
      NCDropDownNotification.shared.showError(message: LOCALIZE("Error : Empty Fields"))
      return
    }
    
    NCActivityIndicator.shared.start(view: self.view)
    //Registering User with email
    self.registerEmail(email: email, password: password, username: username) { (userId, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        NCActivityIndicator.shared.stop()
        NCDropDownNotification.shared.showError(message: LOCALIZE("Error : \(error.localizedDescription)"))
        return
      }
      //User id after account is successfully created
      guard let userId = userId else {
        NCActivityIndicator.shared.stop()
        NCDropDownNotification.shared.showError(message: LOCALIZE("Error : Sign Up Error"))
        return
      }
      
      //Uploading the image to the storage
      guard let image = self.mainView?.iconView?.image else{
         NCActivityIndicator.shared.stop()
        Dlog("No Profile Image")
        NCDropDownNotification.shared.showError(message: LOCALIZE("Error Occured!"))
        return
      }
      
      self.saveImageToStorage(image: image, userId: userId, completion: { (url, error) in
        if let error = error{
          Dlog(error.localizedDescription)
           NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showError(message: LOCALIZE("Error : \(error.localizedDescription)"))
          return
        }
        
        //Write the data to the database
        self.writeEmailUser(userId: userId, username: username, iconUrl: url!, completion: { (error) in
          if let error = error{
            NCActivityIndicator.shared.stop()
            NCDropDownNotification.shared.showError(message: LOCALIZE("Error : \(error.localizedDescription)"))
            return
          }
          self.navigationController?.popViewController(animated: true)
          NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showSuccess(message: LOCALIZE("Account Successfully Created"))
        })
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

extension NCSignUpViewController : GalleryControllerDelegate{
  
  private func presentPicker(){
    let gallery = GalleryController()
    gallery.delegate = self
    Config.tabsToShow = [.imageTab]
    Config.Camera.imageLimit = 1
    present(gallery, animated: true, completion: nil)
  }
  
  func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
    images[0].resolve(completion: { (image) in
      self.mainView?.iconView?.image = image
      
      
//      let profileImageFromPicker = image
//      let metaData = StorageMetadata()
//      metaData.contentType = "image/jpeg"
//
//      let imageData : Data = (profileImageFromPicker?.jpegData(compressionQuality: 0.5))!
//
//      let store = Storage.storage()
//      let userID = "AHNSHD76sHS"
//
//      let storeRef = store.reference().child("user_profile/\(userID)/profile_photo.jpg")
//      NCActivityIndicator.shared.start(view: self.view)
//      let _ = storeRef.putData(imageData, metadata: metaData){(metaData, error) in
//        NCActivityIndicator.shared.stop()
//        guard let _  = metaData else {
//          Dlog("error: \(error.debugDescription)")
//          return
//        }
//
//        storeRef.downloadURL(completion: { (url, error) in
//          guard  let url = url else {
//            Dlog(error?.localizedDescription)
//            return
//          }
//          Dlog(url)
//        })
//      }
//
      
    })
    controller.dismiss(animated: true, completion: nil)
  }
  
  func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    
  }
  
  func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    
  }
  
  func galleryControllerDidCancel(_ controller: GalleryController) {
    controller.dismiss(animated: true, completion: nil)
  }
  
  
}

