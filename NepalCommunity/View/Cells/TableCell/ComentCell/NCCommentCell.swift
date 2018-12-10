//
//  NCCommentCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/07.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCCommentCell : UITableViewCell{
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
  }
  
  private func setupConstraints(){
    
  }
}
