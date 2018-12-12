//
//  NCCreateArticleController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/21.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import Gallery


class NCCreateARrticleController: NCViewController{
  
  //MARK: Variables
  private var mainView : NCCreateArticleView?
  private var mainViewBottomConstraints: Constraint?
  private var isLoading : Bool = false
  
  //MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = NCColors.white
    self.setup()
    self.setupConstraints()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupNotification()
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.mainView?.titleField?.becomeFirstResponder()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tearDownNotification()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.mainView?.titleField?.resignFirstResponder()
    self.mainView?.descriptionField?.resignFirstResponder()
  }
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.blue
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
  }
  
  //MARK: Setup
  private func setup(){
    let mainView = NCCreateArticleView()
    self.mainView = mainView
    mainView.delegate = self
    mainView.categoriesDelegate = self
    mainView.imageDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.topToSuperview(usingSafeArea : true)
    mainView.leftToSuperview(usingSafeArea : true)
    mainView.rightToSuperview(usingSafeArea : true)
    mainViewBottomConstraints = mainView.bottomToSuperview(usingSafeArea : true)
  }
}

//MARK: Button
extension NCCreateARrticleController : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.backBtn{
      self.dismiss(animated: true, completion: nil)
    }
    else if view == mainView?.postBtn{
      guard let mainView = self.mainView else {return}
      //Getting the proper title
      guard let titleField = mainView.titleField,
        let titleText = titleField.text,titleText.count > 0,
        !mainView.isTitlePlaceholder else{
          NCDropDownNotification.shared.showError(message: LOCALIZE("Enter Title"))
          return
      }
      //Getting the proper description
      guard let descriptionField = mainView.descriptionField,
        let descriptionText = descriptionField.text, descriptionText.count > 0 ,
        !mainView.isDescriptionPlaceholder else {
          NCDropDownNotification.shared.showError(message: LOCALIZE("Enter Description"))
          return
      }
      
      //Confirming if the post has image or not
      let hasImage = mainView.hasImage
      let category = mainView.categories.rawValue
      if hasImage{
        guard let selectImageView = mainView.selectedImageView,
          let image = selectImageView.image else {
            NCDropDownNotification.shared.showError(message: LOCALIZE("Error"))
            return
        }
        self.postCreateWithImage(title: titleText, description: descriptionText, image: image, category: category)
      }else{
        self.postCreateWithText(title: titleText, description: descriptionText, category: category)
      }
    }
  }
}


//MARK: Notification
extension NCCreateARrticleController{
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

//MARK: Categories Selection
extension NCCreateARrticleController : NCCategoriesSelectionDelegate{
  func categoriesSelectionTapped() {
    let categoryAlert = UIAlertController(title: LOCALIZE("Categories"), message: "Select Categories", preferredStyle: .actionSheet)
    let foodTravelAlert = UIAlertAction(title: LOCALIZE(NCCategories.food_travel.rawValue), style: .default) { (_) in
      self.mainView?.categories = .food_travel
    }
    
    let japanLifeAlert = UIAlertAction(title: LOCALIZE(NCCategories.japanLife.rawValue), style: .default) { (_) in
      self.mainView?.categories = .japanLife
    }
    
    let schoolVisaAlert = UIAlertAction(title: LOCALIZE(NCCategories.school_visa.rawValue), style: .default) { (_) in
      self.mainView?.categories = .school_visa
    }
    
    let partTimeAlert = UIAlertAction(title: LOCALIZE(NCCategories.parttime.rawValue), style: .default) { (_) in
      self.mainView?.categories = .parttime
    }
    
    let miscellaneousAlert = UIAlertAction(title: LOCALIZE(NCCategories.miscellaneous.rawValue), style: .default) { (_) in
      self.mainView?.categories = .miscellaneous
    }
    
    let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    categoryAlert.addAction(foodTravelAlert)
    categoryAlert.addAction(japanLifeAlert)
    categoryAlert.addAction(schoolVisaAlert)
    categoryAlert.addAction(partTimeAlert)
    categoryAlert.addAction(miscellaneousAlert)
    categoryAlert.addAction(cancelAlert)
    
    self.present(categoryAlert, animated: true, completion: nil)
  }
}

//MARK : Image Selection Gallery Delegate
extension NCCreateARrticleController : GalleryControllerDelegate, NCImageSelectionDelegate{
  func imagePressed(image: UIImage) {
    let vc = NCFullImageController()
    vc.image = image
    self.present(vc, animated: true, completion: nil)
  }
  
  func showLibrary() {
    let gallery = GalleryController()
    gallery.delegate = self
    Config.tabsToShow = [.imageTab]
    Config.Camera.imageLimit = 1
    present(gallery, animated: true, completion: nil)
  }
  
  func openCamera() {
    let gallery = GalleryController()
    gallery.delegate = self
    Config.tabsToShow = [.cameraTab]
    Config.Camera.imageLimit = 1
    present(gallery, animated: true, completion: nil)
  }
  
  func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
    images[0].resolve(completion: { (image) in
      self.mainView?.selectedImageView?.image = image
      self.mainView?.hasImage = true
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

//MARK: Post Article
extension NCCreateARrticleController : NCDatabaseWrite, NCStorage{
  //Post With Images
  private func postCreateWithImage(title : String, description : String, image : UIImage, category : String){
    
    if !isLoading{
      self.isLoading = true
      //Show Indicator
      NCActivityIndicator.shared.start(view: self.view)
      
      //Generating random id
      let articleId = randomID(length: 25)
      
      //Saving the image and getting the url
      saveArticleImageToStorage(articleId: articleId, image: image) { (imageUrl, error) in
        if let error = error{
          Dlog("\(error.localizedDescription)")
          NCDropDownNotification.shared.showError(message: LOCALIZE(error.localizedDescription))
          NCActivityIndicator.shared.stop()
          self.isLoading = false
          return
        }
        
        guard let imageUrl = imageUrl else {return}
        
        //Posting the article with the image
        self.postArticle(articleId: articleId, userId: (NCSessionManager.shared.user?.uid)!, title: title, description: description, category: category, imageURL: imageUrl, hasImage: 1, completion: { (error) in
          if let error = error{
            Dlog("\(error.localizedDescription)")
            NCDropDownNotification.shared.showError(message: LOCALIZE(error.localizedDescription))
            NCActivityIndicator.shared.stop()
            self.isLoading = false
            return
          }
          //Dismissing the view
          NCDropDownNotification.shared.showSuccess(message: LOCALIZE("Success!!!"))
          NCActivityIndicator.shared.stop()
          self.isLoading = false
          self.dismiss(animated: true, completion: nil)
        })
      }
    }
  }
  
  
  //Post With Text Only
  private func postCreateWithText(title: String, description : String, category : String){
    if !isLoading{
      self.isLoading = true
      //Generating random id
      let articleId = randomID(length: 25)
      
      //Show Indicator
      NCActivityIndicator.shared.start(view: self.view)
      //Posting the aritcle with text only
      self.postArticle(articleId: articleId, userId: (NCSessionManager.shared.user?.uid)!, title: title, description: description, category: category, imageURL: "", hasImage: 0) { (error) in
        if let error = error {
          Dlog("\(error.localizedDescription)")
          NCDropDownNotification.shared.showError(message: LOCALIZE(error.localizedDescription))
          NCActivityIndicator.shared.stop()
          self.isLoading = false
          return
        }
        //Dismissing the view
        NCDropDownNotification.shared.showSuccess(message: LOCALIZE("Success!!!"))
        NCActivityIndicator.shared.stop()
        self.isLoading = false
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
}
