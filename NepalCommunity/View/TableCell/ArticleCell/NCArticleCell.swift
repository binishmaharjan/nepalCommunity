//
//  ArticleCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/19.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCArticleCell : UITableViewCell{
  
  //Variables
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  private var topLabel: UILabel?
  private var titleLabel :UILabel?
  private var likeIconBG: UIView?
  private var likeIcon: NCImageButtonView?
  private var likeLabel: UILabel?
  private var dislikeIconBG : UIView?
  private var dislikeIcon: NCImageButtonView?
  private var dislikeLabel: UILabel?
  private var commentIconBG : UIView?
  private var commentIcon : NCImageButtonView?
  private var commentLabel: UILabel?
  private var menuIconBG: UIView?
  private var menuIcon: NCImageButtonView?
  private var seperator : UIView?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(){
    //User Image
    let userImageBG = UIView()
    self.userImageBG = userImageBG
    self.addSubview(userImageBG)
    userImageBG.layer.cornerRadius = 5.0
    userImageBG.dropShadow()
    
    let userImage = UIImageView()
    self.userImage = userImage
    userImageBG.addSubview(userImage)
    userImage.image = UIImage(named: "50")
    userImage.layer.cornerRadius = 5.0
    userImage.clipsToBounds = true
    
    //Top Label
    let topLabel = UILabel()
    self.topLabel = topLabel
    topLabel.text = LOCALIZE("Maharjan Binish | LifeStyle | 2 hours" )
    topLabel.textColor = NCColors.darKGray
    topLabel.font = NCFont.normal(size: 12)
    topLabel.adjustsFontSizeToFitWidth = true
    self.addSubview(topLabel)
    
    //Menu Icon
    let menuIconBG = UIView()
    self.menuIconBG = menuIconBG
    self.addSubview(menuIconBG)
    
    let menuIcon = NCImageButtonView()
    self.menuIcon = menuIcon
    menuIconBG.addSubview(menuIcon)
    menuIcon.image = UIImage(named: "icon_menu")
    
    //Title Label
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleLabel.text = LOCALIZE("What shoud i cook for dinner?pork or chicken with rice.")
    self.addSubview(titleLabel)
    titleLabel.font = NCFont.normal(size: 16)
    titleLabel.textColor = NCColors.black
    titleLabel.numberOfLines = 2
    titleLabel.lineBreakMode = .byTruncatingTail
    titleLabel.adjustsFontSizeToFitWidth = false
    
    //Comment Label
    let commentIconBG = UIView()
    self.commentIconBG = commentIconBG
    self.addSubview(commentIconBG)
    
    let commentIcon = NCImageButtonView()
    self.commentIcon = commentIcon
    commentIcon.image = UIImage(named: "icon_comment")
    commentIconBG.addSubview(commentIcon)
    
    let commentLabel = UILabel()
    self.commentLabel = commentLabel
    commentLabel.text = LOCALIZE("12346")
    commentLabel.textColor = NCColors.darKGray
    commentLabel.font = NCFont.normal(size: 12)
    self.addSubview(commentLabel)
    
    //Dislike Lablel
    let dislikeIconBG = UIView()
    self.dislikeIconBG = dislikeIconBG
    self.addSubview(dislikeIconBG)
    
    let dislikeIcon = NCImageButtonView()
    self.dislikeIcon = dislikeIcon
    dislikeIcon.image = UIImage(named: "icon_thumb_down")
    dislikeIconBG.addSubview(dislikeIcon)
    
    let dislikeLabel = UILabel()
    self.dislikeLabel = dislikeLabel
    dislikeLabel.text = LOCALIZE("12346")
    dislikeLabel.textColor = NCColors.darKGray
    dislikeLabel.font = NCFont.normal(size: 12)
    self.addSubview(dislikeLabel)
    
    //Like Label
    let likeIconBG = UIView()
    self.likeIconBG = likeIconBG
    self.addSubview(likeIconBG)
    
    let likeIcon = NCImageButtonView()
    self.likeIcon = likeIcon
    likeIcon.image = UIImage(named: "icon_thumb_up")
    likeIconBG.addSubview(likeIcon)
    
    let likeLabel = UILabel()
    self.likeLabel = likeLabel
    likeLabel.text = LOCALIZE("12346")
    likeLabel.textColor = NCColors.darKGray
    likeLabel.font = NCFont.normal(size: 12)
    self.addSubview(likeLabel)
    
    //Seperator
    let seperator = UIView()
    self.seperator = seperator
    seperator.backgroundColor = NCColors.darKGray
    
    self.addSubview(seperator)
  }
  
  private func setupConstraints(){
    guard let userImage = self.userImage,
          let userImageBG = self.userImageBG,
          let topLabel = self.topLabel,
          let titleLabel = self.titleLabel,
          let commentIconBG = self.commentIconBG,
          let commentIcon = self.commentIcon,
          let commentLabel = self.commentLabel,
          let likeIconBG = self.likeIconBG,
          let likeIcon = self.likeIcon,
          let likeLabel = self.likeLabel,
          let dislikeIconBG = self.dislikeIconBG,
          let dislikeIcon = self.dislikeIcon,
          let dislikeLabel = self.dislikeLabel,
          let seperator = self.seperator,
          let menuIconBG = self.menuIconBG,
      let menuIcon = self.menuIcon else { return }
    
    userImageBG.topToSuperview(offset : 16)
    userImageBG.leftToSuperview(offset : 16)
    userImageBG.width(60)
    userImageBG.height(to: userImageBG, userImageBG.widthAnchor)
    
    userImage.edgesToSuperview()
    
    topLabel.topToSuperview(offset: 11)
    topLabel.leftToRight(of: userImageBG, offset : 16)
    topLabel.rightToLeft(of: menuIconBG)
    
    menuIconBG.rightToSuperview(offset: -16)
    menuIconBG.centerY(to: topLabel)
    menuIconBG.width(28)
    menuIconBG.height(19)
    
    menuIcon.edgesToSuperview()
    
    titleLabel.topToBottom(of: topLabel, offset : 8)
    titleLabel.leftToRight(of: userImageBG, offset:  16)
    titleLabel.rightToSuperview(offset : -16)
    
    commentLabel.rightToSuperview(offset : -16)
    commentLabel.bottomToSuperview(offset : -8)

    
    commentIconBG.rightToLeft(of: commentLabel)
    commentIconBG.centerY(to: commentLabel)
    commentIconBG.width(26.25)
    commentIconBG.height(32.5)
//    commentLabel.isDrawRectangle = true
//    commentIconBG.isDrawRectangle = true
    
    commentIcon.edgesToSuperview()
    
    
    dislikeLabel.rightToLeft(of: commentIconBG, offset:  -8)
    dislikeLabel.bottom(to: commentLabel)
    
    dislikeIconBG.rightToLeft(of: dislikeLabel)
    dislikeIconBG.centerY(to: dislikeLabel)
    dislikeIconBG.width(26.25)
    dislikeIconBG.height(32.5)
//    dislikeLabel.isDrawRectangle = true
//    dislikeIconBG.isDrawRectangle = true
    
    dislikeIcon.edgesToSuperview()
    
    likeLabel.rightToLeft(of: dislikeIconBG, offset:  -8)
    likeLabel.bottom(to: commentLabel)
    
    likeIconBG.rightToLeft(of: likeLabel)
    likeIconBG.centerY(to: likeLabel)
    likeIconBG.width(26.25)
    likeIconBG.height(32.5)
//    likeLabel.isDrawRectangle = true
//    likeIconBG.isDrawRectangle = true
    
    likeIcon.edgesToSuperview()
    
    seperator.bottomToSuperview()
    seperator.leftToSuperview()
    seperator.rightToSuperview()
    seperator.height(0.5)

    
  }
}
