//
//  NCImageDetailViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/12.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCImageDetailViewController:NCViewController{
  
  var image:UIImage? {
    get{
      return self.mainView?.image
    }
    set(v){
      self.mainView?.image = v
    }
  }
  
  private weak var mainView:NCImageDetailView?
  
  override func didInit() {
    self.view.backgroundColor = NCColors.black
    self.setup()
    self.setupConstraints()
  }
  
  
  private func setup(){
    do{
      let v = NCImageDetailView()
      self.view.addSubview(v)
      self.mainView = v
      v.delegate = self
    }
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else{return}
    mainView.edgesToSuperview(usingSafeArea: true)
  }
}

extension NCImageDetailViewController:NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == self.mainView?.closeBtn{
      self.dismiss(animated: true, completion: nil)
    }
  }
}

extension NCImageDetailViewController:NCImageDetailViewDelegate {
  func imageDetailViewTap(sender: UITapGestureRecognizer, tapPoint: CGPoint) {}
  
  func imageDetailViewDidPan() {
    self.dismiss(animated: false, completion: nil)
  }
  
  func imageDetailViewLongPress(sender: UILongPressGestureRecognizer) {
//    MQPager.shared.showSavePhotoConfirm(image: self.mainView?.image, ok: nil, cancel: nil, failure: nil)
  }
}
