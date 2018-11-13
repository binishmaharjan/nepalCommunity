//
//  NCViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class NCViewController: UIViewController{
  var isNib:Bool = false
  var statusBarStyle:UIStatusBarStyle = .default
  
  weak var outsideSafeAreaTopViewTemp:UIView?
  weak var outsideSafeAreaBottomViewTemp:UIView?
  
  init() {
    super.init(nibName: nil, bundle: nil)
    didInit()
  }
  
  init(nibName nibNameOrNil: String?) {
    super.init(nibName: nibNameOrNil, bundle: nil)
    self.isNib = true
    didInit()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func didInit() {
    setup()
  }
  
  private func setup() {
    
    let insideSafeAreaView = UIView()
    insideSafeAreaView.isUserInteractionEnabled = false
    self.view.addSubview(insideSafeAreaView)
    self.setupMainViewConstraints(insideSafeAreaView)
    
    let outsideSafeAreaTopViewTemp = UIView()
    outsideSafeAreaTopViewTemp.isUserInteractionEnabled = false
    self.view.addSubview(outsideSafeAreaTopViewTemp)
    self.outsideSafeAreaTopViewTemp = outsideSafeAreaTopViewTemp
    
    let outsideSafeAreaBottomViewTemp = UIView()
    outsideSafeAreaBottomViewTemp.isUserInteractionEnabled = false
    self.view.addSubview(outsideSafeAreaBottomViewTemp)
    self.outsideSafeAreaBottomViewTemp = outsideSafeAreaBottomViewTemp
    
    outsideSafeAreaTopViewTemp.edgesToSuperview(excluding: .bottom)
    outsideSafeAreaTopViewTemp.bottomToTop(of: insideSafeAreaView)
    
    outsideSafeAreaBottomViewTemp.topToBottom(of: insideSafeAreaView)
    outsideSafeAreaBottomViewTemp.edgesToSuperview(excluding: .top)
    
    insideSafeAreaView.superview?.sendSubviewToBack(insideSafeAreaView)
    outsideSafeAreaBottomViewTemp.superview?.sendSubviewToBack(outsideSafeAreaBottomViewTemp)
    outsideSafeAreaTopViewTemp.superview?.sendSubviewToBack(outsideSafeAreaTopViewTemp)
  }
  
  
  func setupMainViewConstraints(_ mainView: UIView){
    mainView.edgesToSuperview(usingSafeArea: true)
  }
}
