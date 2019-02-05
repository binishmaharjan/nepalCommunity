//
//  NCUserController.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/25.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCUserProfileController : NCViewController{
  
  private var mainView : NCUserProfileView?
  var user : NCUser?{
    didSet{
      guard let mainView = self.mainView else {return}
      mainView.user = user
    }
  }
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
    self.shouldKeyboardShowUp = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setup(){
    let mainView = NCUserProfileView()
    self.mainView = mainView
    mainView.buttonDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = mainView
      else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}

//MARK: Button Delegate
extension NCUserProfileController : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.backBtn{
      self.navigationController?.popViewController(animated: true)
    }
  }
}
