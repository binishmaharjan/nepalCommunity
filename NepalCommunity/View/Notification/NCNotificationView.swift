//
//  NCNotificationView.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/07.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCNotificationView : NCBaseView{
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  
  
  //MARK : Overrides
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstranits()
  }
  
  private func setup(){
    let header = UIView()
    header.backgroundColor = NCColors.blue
    self.addSubview(header)
    self.header = header
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Notifications")
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
  }
  
  
  private func setupConstranits(){
    guard let header = self.header,
      let titleLbl = self.titleLbl
      else {return}
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
  }
}
