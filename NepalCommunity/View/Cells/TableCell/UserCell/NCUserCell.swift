//
//  NCUser.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/23.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCUserCell : UITableViewCell{
  
  private weak var userImageBG : UIView?
  private weak var userImage : UIImageView?
  private weak var userNameLbl : UILabel?
  private weak var userEmailLbl : UILabel?
  private weak var container : UIView?
  
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
    
    //User Image
    let userImageBG = UIView()
    self.userImageBG = userImageBG
    container.addSubview(userImageBG)
    userImageBG.layer.cornerRadius = 5.0
    userImageBG.dropShadow()
    
    let userImage = UIImageView()
    self.userImage = userImage
    userImageBG.addSubview(userImage)
    userImage.image = UIImage(named: "50")
    userImage.layer.cornerRadius = 5.0
    userImage.contentMode = .scaleAspectFill
    userImage.clipsToBounds = true
    
    //NameLabel Label
    let nameLabel = UILabel()
    self.userNameLbl = nameLabel
    nameLabel.text = LOCALIZE("Fullname" )
    nameLabel.textColor = NCColors.black
    nameLabel.font = NCFont.bold(size: 18)
    nameLabel.adjustsFontSizeToFitWidth = true
    container.addSubview(nameLabel)
    
    //Email Label
    let emailLabel = UILabel()
    self.userEmailLbl = emailLabel
    emailLabel.text = LOCALIZE("Email")
    emailLabel.textColor = NCColors.orange
    emailLabel.font = NCFont.normal(size: 14)
    emailLabel.adjustsFontSizeToFitWidth = true
    container.addSubview(emailLabel)
  }
  
  private func setupConstraints(){
    guard let userImageBG = self.userImageBG,
          let userImage = self.userImage,
          let userNameLbl = self.userNameLbl,
          let userEmailLbl = self.userEmailLbl,
          let container = self.container
      else {return}
    
    container.edgesToSuperview()
    
    userImageBG.topToSuperview(offset : 4)
    userImageBG.height(42)
    userImageBG.leftToSuperview(offset : 8)
    userImage.width(to: userImage, userImage.heightAnchor)
    
    userImage.edgesToSuperview()
    container.bottom(to: userImageBG, offset : 4)
    
    userNameLbl.top(to: userImageBG)
    userNameLbl.leftToRight(of: userImageBG, offset: 8)
    
    userEmailLbl.topToBottom(of: userNameLbl, offset : 2)
    userEmailLbl.left(to: userNameLbl)
  }
}
