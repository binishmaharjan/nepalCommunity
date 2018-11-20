//
//  NCMenuCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/15.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCMenuCell: UICollectionViewCell{
  //MARK : Variables
  private var label :UILabel?
  var title : String = ""{
    didSet{
      label?.text = LOCALIZE(title)
    }
  }
  
  //Cell State
  override var isSelected: Bool{
    didSet{
      
    }
  }
  
  override var isHighlighted: Bool{
    didSet{
     
    }
  }
  
  //MARK: Default
  override init(frame: CGRect) {
    super.init(frame:frame)
    setup()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    let label = UILabel()
    self.label = label
    label.text = LOCALIZE("MENU")
    label.textColor = NCColors.white
    label.font = NCFont.bold(size: 14)
    label.numberOfLines = 2
    label.adjustsFontSizeToFitWidth = false
    label.textAlignment = .center
    self.addSubview(label)
  }
  
  private func setupConstraints(){
    guard let label = self.label else { return }
    label.edgesToSuperview(insets:UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
  }
  
}
