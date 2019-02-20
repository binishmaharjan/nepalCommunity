//
//  NCNotificationController.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/07.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCNotificationController : NCViewController{
  
  //MARK : Variables
  var mainView : NCNotificationView?
  
  //MARK: Overrides
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    guard let mainView = self.mainView else {return}
    mainView.user = NCSessionManager.shared.user
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setup(){
    let mainView = NCNotificationView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard  let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}
