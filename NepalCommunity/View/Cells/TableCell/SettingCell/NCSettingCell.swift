//
//  NCSettingCell.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/01.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCSettingCell : UITableViewCell{
  
  private weak var container : UIView?
  private weak var titleLabel : UILabel?
  private weak var border : UIView?
  
  var title : String = ""{didSet{titleLabel?.text = title}}
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    
    let container = UIView()
    self.container = container
    self.addSubview(container)
    
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleLabel.text = "CEll"
    titleLabel.font = NCFont.bold(size: 18)
    container.addSubview(titleLabel)
    
    
    let border = UIView()
    self.border = border
    border.backgroundColor = NCColors.darKGray
    container.addSubview(border)
    
  }
  
  private func setupConstraints(){
    guard let titleLabel = self.titleLabel,
          let container = self.container,
          let border = self.border else {return}
    
    container.edgesToSuperview()
    
    titleLabel.centerYToSuperview()
    titleLabel.leftToSuperview(offset : 10)
    
    //container.bottom(to: titleLabel, offset  : 5)
    
    border.edgesToSuperview(excluding : .top)
    border.height(1)
  }
}
