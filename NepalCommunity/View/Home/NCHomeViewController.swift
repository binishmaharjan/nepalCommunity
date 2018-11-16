//
//  NCHomeViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/14.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCHomeViewController: NCViewController {
  
  private var mainView : NCHomeView?
  
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
    let mainView = NCHomeView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}
