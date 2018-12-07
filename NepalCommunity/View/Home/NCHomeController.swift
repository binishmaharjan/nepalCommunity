//
//  NCHomeViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/14.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCHomeController: NCViewController {
  
  //Top Menu
  var homeTop : NCHomeTopView?
  
  //Menu Selection Bar
  var scrollView : UIScrollView?
  private var contentView : UIView?
  private var menuBar: UIView?
  private var menuConstraints : Constraint?
  //Left constraints of menuBar tap on menu item
  var menuBarX: CGFloat = 0.0 {
    didSet {
      menuConstraints?.constant = menuBarX
      UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
        self.view.layoutIfNeeded()//Animate the change in constraints
      }, completion: nil)
    }
  }
  //Left constraints of menuBar when changed from PageViewController
  var menuBarXFromPageView : CGFloat = 0.0{
    didSet{
      menuConstraints?.constant = menuBarXFromPageView
    }
  }
  
  //PageView With Controllers
  private var pageView:NCPageViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupConstraints()
    self.view.backgroundColor = NCColors.white
  }
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.blue
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  

  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  private func setup(){
    let mainView = NCHomeTopView()
    self.homeTop = mainView
    homeTop?.parent = self
    self.view.addSubview(mainView)
    
    let pageView = NCPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options:nil)
    self.pageView = pageView
    pageView.homeTop = homeTop
    pageView.parentVC = self
    pageView.pagerToHomeDelegate = self
     mainView.pageView = pageView
    self.view.addSubview(pageView.view)
    self.addChild(pageView)
    
    //Menu Selection Bar
    let scrollView = UIScrollView()
    self.scrollView = scrollView
    self.view.addSubview(scrollView)
    scrollView.showsHorizontalScrollIndicator = false
    
    let contentView = UIView()
    self.contentView = contentView
    contentView.backgroundColor = UIColor.clear
    scrollView.addSubview(contentView)
    
    let menuBar = UIView()
    self.menuBar = menuBar
    contentView.addSubview(menuBar)
    menuBar.backgroundColor = NCColors.white
    
  }
  
  private func setupConstraints(){
    guard let mainView = self.homeTop,
          let scrollView = self.scrollView,
          let contentView = self.contentView,
          let menuBar = self.menuBar,
          let pageView = self.pageView else { return }
    mainView.edgesToSuperview(excluding: .bottom, usingSafeArea : true)
    mainView.height(88)
    
    scrollView.bottom(to: mainView)
    scrollView.leftToSuperview()
    scrollView.rightToSuperview()
    scrollView.height(4)
    
    contentView.edgesToSuperview()
    contentView.height(to: scrollView)
    contentView.width((UIScreen.main.bounds.width / 4) * 6)
    
    menuBar.bottomToSuperview()
    menuConstraints = menuBar.leftToSuperview()
    menuBar.width(UIScreen.main.bounds.width / 4)
    menuBar.height(4)
    
    pageView.view.topToBottom(of: mainView)
    pageView.view.leftToSuperview()
     pageView.view.rightToSuperview()
    pageView.view.bottomToSuperview()
  }
}


extension NCHomeController: NCPagerToHomeDelegate{
  func passPagerToHome(article: NCArticle) {
    let detailVc = NCDetailViewController()
    self.navigationController?.pushViewController(detailVc, animated: true)
  }
}
