//
//  NCSingleHomeController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/19.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCSingleHomeController : NCViewController{
  
  private var mainView : NCSingleHomeView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
  }
  
  private func setup(){
    let mainView  = NCSingleHomeView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.edgesToSuperview()
  }
  
}
