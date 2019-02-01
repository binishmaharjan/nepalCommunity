//
//  NCSettingController.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/01.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCSettingController : NCViewController{
  
  private weak var mainView : NCSettingView?
  var titleString : String = ""{didSet{mainView?.title = titleString}}
  
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
    let  mainView = NCSettingView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}
