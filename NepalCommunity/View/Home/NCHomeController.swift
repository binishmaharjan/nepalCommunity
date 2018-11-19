//
//  NCHomeViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/14.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCHomeController: NCViewController {
  
  private var homeTop : NCHomeTopView?
  
  private var pageView:NCPageViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupConstraints()
  }
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.blue
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  private func setup(){
    let mainView = NCHomeTopView()
    self.homeTop = mainView
    self.view.addSubview(mainView)
    
    let pageView = NCPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options:nil)
    self.pageView = pageView
    pageView.homeTop = homeTop
     mainView.pageView = pageView
    self.view.addSubview(pageView.view)
    self.addChild(pageView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.homeTop,
          let pageView = self.pageView else { return }
    mainView.edgesToSuperview(excluding: .bottom, usingSafeArea : true)
    mainView.height(88)
    
    pageView.view.topToBottom(of: mainView)
    pageView.view.leftToSuperview()
     pageView.view.rightToSuperview()
    pageView.view.bottomToSuperview()
  }
}
