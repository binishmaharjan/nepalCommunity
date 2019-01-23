//
//  NCSearchController.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/22.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCSearchController : NCViewController{
  
  private var mainView : NCSearchView?
  
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
  
  private func setup(){
    let mainView = NCSearchView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}
