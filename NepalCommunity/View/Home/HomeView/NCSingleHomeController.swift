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
  var singleToPagerDelegate : NCSingleToPagerDelegate?
  
//  var label : UILabel?
//  var labelText: String = ""{
//    didSet{
//      label?.text = labelText
//    }
//  }
  
  var referenceTitle :String{
    set{mainView?.referenceTitle = newValue}
    get{return mainView?.referenceTitle ?? ""}
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
  }
  
  private func setup(){
    let mainView  = NCSingleHomeView()
    self.mainView = mainView
    mainView.homeViewDelegate = self
    self.view.addSubview(mainView)
    
//    let label  = UILabel()
//    self.label = label
//    self.view.addSubview(label)
//    label.font = NCFont.bold(size: 54)
//    label.textAlignment = .center
//    label.edgesToSuperview()
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.edgesToSuperview()
  }
  
}

//Home View Delegate
extension NCSingleHomeController : NCSingleHomeViewDelegate{
  func commentIconPressed(article: NCArticle, user :NCUser) {
    singleToPagerDelegate?.commentIconPressed(article: article, user: user)
  }
  
  func menuButtonWasPressed(article: NCArticle) {
    singleToPagerDelegate?.menuButtonWasPressed(article: article)
  }
  
  func cellWasTapped(article: NCArticle, user: NCUser) {
    singleToPagerDelegate?.passFromSingleToPager(article: article, user: user)
  }
}
