//
//  NCUserListController.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/30.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCUserListController: NCViewController{
  //MARK : Variables
  var mainView : NCUserListView?
  
  var user : NCUser?{
    didSet{
      mainView?.user = user
    }
  }
  
   var titleString : NCUserListType?{
    didSet{
      mainView?.title = titleString
    }
  }

  //MARK : Initialize
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
    let mainView = NCUserListView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}
