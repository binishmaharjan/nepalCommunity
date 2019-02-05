//
//  NCArticleListController.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/04.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCArticleListController : NCViewController{
  
  //MARK : variables
  private weak var mainView : NCArticleListView?
  
  var user : NCUser?{didSet{mainView?.user = user}}
  
  var titleString : NCArticleListType = NCArticleListType.likedArticle {didSet{mainView?.title = titleString}}
  
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
  
  private func setup(){
    let mainView = NCArticleListView()
    self.mainView = mainView
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}
