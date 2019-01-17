//
//  NCTitleCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/18.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints


class NCTitleCell: UITableViewCell{
  
  var title : String = "Title"{
    didSet{
      titleLabel?.text = LOCALIZE(title)
    }
  }
  private var titleLabel : UILabel?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleLabel.text = LOCALIZE(title)
    titleLabel.font = NCFont.bold(size: 14)
    titleLabel.textColor = NCColors.blue
    self.addSubview(titleLabel)
  }
  
  private func setupConstraints(){
    guard let titleLabel = self.titleLabel else {return}
    titleLabel.edgesToSuperview(insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4))
  }
}
