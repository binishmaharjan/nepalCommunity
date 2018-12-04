//
//  NCEmptyTableView.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/03.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCEmptyTableView: NCBaseView{
  
  private var messageLabel : UILabel?
  private var messageText = LOCALIZE("No Result")
  private var imageView : UIImageView?
  
  private weak var loaderFirst:UIActivityIndicatorView?
  
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  private func setup(){
    let imageView = UIImageView()
    self.imageView = imageView
    imageView.image = UIImage(named: "no_result")
    imageView.contentMode = .scaleAspectFit
    self.addSubview(imageView)
    
    let messageLabel = UILabel()
    self.messageLabel = messageLabel
    messageLabel.text = messageText
    messageLabel.font = NCFont.bold(size: 18)
    messageLabel.textAlignment = .center
    messageLabel.textColor = NCColors.darkBlue
    self.addSubview(messageLabel)
    
    
    let v = UIActivityIndicatorView()
    self.addSubview(v)
    self.loaderFirst = v
    v.hidesWhenStopped = true
    v.style = UIActivityIndicatorView.Style.whiteLarge
    v.color = NCColors.blue
    v.edgesToSuperview()
  }
  
  private func setupConstraints(){
    guard let messageLabel = self.messageLabel,
      let loaderFirst = self.loaderFirst,
      let imageView = self.imageView
      else { return }
    
    imageView.width(UIScreen.main.bounds.width - 64)
    imageView.centerXToSuperview()
    imageView.topToSuperview(offset : 40)
    imageView.height(to: imageView, imageView.widthAnchor)
    
    messageLabel.topToBottom(of: imageView, offset: 20)
    messageLabel.centerXToSuperview()
    
    loaderFirst.edgesToSuperview()
  }
  
  func startAnimating(){
    guard let messageLabel = self.messageLabel,
          let imageView = self.imageView,
      let loaderFirst = self.loaderFirst else { return }
    messageLabel.isHidden = true
    imageView.isHidden = true
    loaderFirst.startAnimating()
  }
  
  func stopAnimating(){
    guard let messageLabel = self.messageLabel,
      let imageView = self.imageView,
      let loaderFirst = self.loaderFirst else { return }
    loaderFirst.stopAnimating()
    messageLabel.isHidden = false
    imageView.isHidden = false
  }
}
