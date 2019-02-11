//
//  NCEditProfileController.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/07.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import Gallery


class NCEditProfileController : NCViewController{
  //MARK: Variables
  private weak var mainView : NCEditProfileView?
  var titleString : String = ""{didSet{mainView?.title = titleString}}

  //MARK: Overrides
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.blue
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
  }
  
  //MARK : Setups
  private func setup(){
    let mainView = NCEditProfileView()
    self.mainView = mainView
    mainView.editDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}

//MARK:  Gallery Delegate
extension NCEditProfileController : GalleryControllerDelegate{
  func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
    images[0].resolve(completion: { (image) in
      self.mainView?.iconView?.image = image
    })
    mainView?.isProfileChange  = true
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

//MARK : Edit Profile Delegate
extension NCEditProfileController : NCEditProfileDelegate{
  func cameraIconPressed() {
    self.presentPicker()
  }
  
  private func presentPicker(){
    let gallery = GalleryController()
    gallery.delegate = self
    Config.tabsToShow = [.imageTab]
    Config.Camera.imageLimit = 1
    present(gallery, animated: true, completion: nil)
  }
}
