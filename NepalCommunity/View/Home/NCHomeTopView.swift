//
//  NCHomeView.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/15.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseAuth

class NCHomeTopView: NCBaseView{
  
  //Menu Bar
  var menuBar: NCMenuBar?
  
  var parent : NCHomeController?{
    didSet{
      menuBar?.parent = parent
    }
  }
  
  //PageViewController
  var pageView: NCPageViewController?{
    didSet{
      menuBar?.pageView = pageView
    }
  }
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  
  override func didInit() {
    super.didInit()
    self.setupHeader()
    self.setupHeaderConstraints()
    self.setup()
    self.setupConstraints()
  }
  
  private func setupHeader(){
    let header = UIView()
    header.backgroundColor = NCColors.blue
    self.addSubview(header)
    self.header = header
    
    let titleLbl = UILabel()
    self.titleLbl = titleLbl
    titleLbl.font = NCFont.heavy(size: 24)
    titleLbl.textColor = NCColors.white
    titleLbl.text = LOCALIZE("APPICON")
    header.addSubview(titleLbl)
  }
  
  private func setupHeaderConstraints(){
    guard let header = self.header,
          let titleLbl = self.titleLbl else{ return }
    header.edgesToSuperview(excluding : .bottom)
    header.height(HEADER_H)
    
    titleLbl.centerInSuperview()
  }
  
  private func setup(){
    let menuBar = NCMenuBar()
    self.menuBar = menuBar
    self.addSubview(menuBar)
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
    button.setTitle("LOGOUT", for: .normal)
    button.addTarget(self, action: #selector(logOutFun), for: .touchUpInside)
    header?.addSubview(button)
    button.topToSuperview()
    button.rightToSuperview()
  
  }
  
  private func setupConstraints(){
    guard  let menuBar = self.menuBar,
           let header = self.header  else { return }
    
    menuBar.topToBottom(of: header)
    menuBar.leftToSuperview()
    menuBar.rightToSuperview()
    menuBar.height(HEADER_H)
  }
  
  
  //TODO: Remove this and the firebase auth library and Button
  @objc private func logOutFun(){
    let firebaseAuth = Auth.auth()
    do{
      try firebaseAuth.signOut()
    }catch{
      debugPrint("Error signing out \(error.localizedDescription)")
    }
  }
}
