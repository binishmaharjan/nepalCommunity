//
//  NCActivityIndicator.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/31.
//  Copyright © 2018年 guest. All rights reserved.
//

import NVActivityIndicatorView

class NCActivityIndicator{
  
  private init(){}
  
  static let shared = NCActivityIndicator()
  private let background : UIView = UIView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 35, y: UIScreen.main.bounds.height / 2 - 35, width: 70, height: 70))
  
  var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballSpinFadeLoader, color: NCColors.blue)
  
  func start(view : UIView){
    view.addSubview(background)
    
    background.addSubview(activityIndicator)
    background.backgroundColor = NCColors.black.withAlphaComponent(0.5)
    background.layer.cornerRadius = 5.0
    activityIndicator.center = background.center
    
    view.addSubview(activityIndicator)
    if !(activityIndicator.isAnimating){
      activityIndicator.startAnimating()
    }
  }
  
  func stop(){
    activityIndicator.removeFromSuperview()
    background.removeFromSuperview()
    if activityIndicator.isAnimating{
      activityIndicator.stopAnimating()
    }
  }
}
