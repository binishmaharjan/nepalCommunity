//
//  NCBaseView.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class NCBaseView : UIView{
  
  convenience init() { self.init(frame: CGRect.zero)}
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    didInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    didInit()
  }
  
  func didInit(){}
}
