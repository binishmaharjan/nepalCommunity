//
//  NCImageSelectionCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/22.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCImageSelectionCell : UICollectionViewCell{
  
  var imageView : UIImageView?
  var indexPath: Int = 0{
    didSet{
      if indexPath <= 1{
        imageView?.contentMode = .center
      }else{
        imageView?.contentMode = .scaleAspectFill
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    self.layer.cornerRadius = 5.0
    self.layer.borderWidth = 1
    self.layer.borderColor = NCColors.darKGray.cgColor
    
    let imageView = UIImageView()
    self.imageView = imageView
    self.addSubview(imageView)
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 5.0
    imageView.contentMode = .center
  }
  
  private func setupConstraints(){
    guard let imageView = self.imageView else {return}
    imageView.edgesToSuperview()
  }
}
