//
//  NCProfileController.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/18.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCProfileController : NCViewController{
  
  override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
  private var mainView : NCProfileView?
  //Should Keyboard show up when showing detail view
  private var shouldKeyboardShowUp : Bool = false
  
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
    self.shouldKeyboardShowUp = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setup(){
    let mainView = NCProfileView()
    self.mainView = mainView
//    mainView.cellDelegate = self
    mainView.buttonDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
  
}

//MARK: Button Delegate
extension NCProfileController : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.settingBtn{
      Dlog("Setting")
      NCPager.shared.showSettingPage()
    }
  }
}
