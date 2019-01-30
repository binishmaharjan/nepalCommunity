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
  var base:UIView = UIView()
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    super.viewDidLoad()
    
    self.view.backgroundColor = NCColors.white
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    if !isNib{
      self.view.addSubview(base)
      base.frame = self.view.bounds
      base.backgroundColor = NCColors.white
      if let tabBar = self.tabBarController?.tabBar{
       base.frame.size.height = self.view.frame.size.height - tabBar.frame.size.height
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if self.base.subviews.count == 0 {
      self.base.backgroundColor = NCColors.clear
      NCPager.shared.currentViewController = self
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NCPager.shared.currentViewController = self
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
