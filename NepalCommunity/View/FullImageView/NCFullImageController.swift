//
//  NCFullImageController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/27.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCFullImageController : NCViewController{
  private var mainView : UIView?
  private var imageView:UIImageView?
  private var cancelButtonBG: UIView?
  private var cancelButton: UIButton?
  var image : UIImage?{
    didSet{
      guard let image = image else {return}
      imageView?.image = image
    }
  }
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.black
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.black
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
  }
  
  private func setup(){
    let mainView = UIView()
    self.mainView = mainView
    mainView.backgroundColor = NCColors.black
    let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture(gesture:)))
    downSwipe.direction = .down
    mainView.addGestureRecognizer(downSwipe)
    self.view.addSubview(mainView)
    
    let imageView = UIImageView()
    self.imageView = imageView
    imageView.contentMode = .scaleAspectFit
    mainView.addSubview(imageView)
    
    let cancelButtonBG = UIView()
    self.cancelButtonBG = cancelButtonBG
    cancelButtonBG.layer.cornerRadius = 30 / 2
    cancelButtonBG.backgroundColor = NCColors.white.withAlphaComponent(0.3)
    cancelButtonBG.isUserInteractionEnabled = true
    cancelButtonBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelButtonPressed)))
    mainView.addSubview(cancelButtonBG)
    
    let cancelButton = UIButton()
    self.cancelButton = cancelButton
    cancelButton.setImage(UIImage(named: "icon_cancel"), for: .normal)
    cancelButtonBG.addSubview(cancelButton)
    cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView,
          let imageView = self.imageView,
          let cancelButtonBG = self.cancelButtonBG,
      let cancelButton = self.cancelButton else { return }
    
    mainView.edgesToSuperview()
    imageView.edgesToSuperview()
    
    cancelButtonBG.topToSuperview(offset : 32)
    cancelButtonBG.leftToSuperview(offset : 16)
    cancelButtonBG.width(30)
    cancelButtonBG.height(to: cancelButtonBG, cancelButtonBG.widthAnchor)
    
    cancelButton.edgesToSuperview(insets: TinyEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
  }
  
  
  //Cancel Button Pressed
  @objc private func cancelButtonPressed(){
    self.dismiss(animated: true, completion: nil)
  }
  
  //Swipe Down Gesture
  @objc private func swipeDownGesture(gesture : UISwipeGestureRecognizer){
    if gesture.direction == UISwipeGestureRecognizer.Direction.down{
      self.dismiss(animated: true, completion: nil)
    }
  }
}
