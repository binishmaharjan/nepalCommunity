//
//  NCNotificationCell.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/19.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase

class NCNotificationCell : UITableViewCell, NCDatabaseAccess{
  
  //Variables
  private weak var container: UIView?
  private weak var iconBG : UIView?
  private weak var icon : UIImageView?
  private weak var notificationLabel : UILabel?
  private weak var followBtn : UILabel?
  private weak var followBtnBg : UIView?
  private weak var border : UIView?
  
  //Notification
  var notification : NCNotification?{
    didSet{
      self.gotNotification()
    }
  }
  private var isSeen : Bool?
  private var notificationType : String?
  private var transitionId : String?
  
  //Sender
  private var sender : NCUser?{
    didSet{
      //Set Image
      DispatchQueue.global(qos: .default).async {
        self.icon?.sd_setImage(with: URL(string: self.sender?.iconUrl ?? ""), completed: { (image, error, _, _) in
          DispatchQueue.main.async {
            self.icon?.image = image
          }
        })
      }
      //Process Notification
      self.processNotificationType()
      self.processIsSeen()
    }
  }
  
  //Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //Setups
  private func setup(){
    let container = UIView()
    self.container = container
    self.addSubview(container)
    
    let iconBG = UIView()
    self.iconBG = iconBG
    container.addSubview(iconBG)
    iconBG.layer.cornerRadius = 5.0
    iconBG.dropShadow()
    
    let icon = UIImageView()
    self.icon = icon
    iconBG.addSubview(icon)
    icon.image = UIImage(named: "50")
    icon.layer.cornerRadius = 5.0
    icon.contentMode = .scaleAspectFill
    icon.clipsToBounds = true
    
    let notificationLabel = UILabel()
    self.notificationLabel = notificationLabel
    notificationLabel.text = "..."
    notificationLabel.font = NCFont.normal(size: 14)
    notificationLabel.numberOfLines = 2
    container.addSubview(notificationLabel)
    
    let border = UIView()
    self.border = border
    container.addSubview(border)
    border.backgroundColor = NCColors.darKGray
  }
  
  private func setupConstraints(){
    guard let container = self.container,
          let iconBG = self.iconBG,
          let icon = self.icon,
          let notificationLabel = self.notificationLabel,
          let border = self.border
      else {return}
    
    container.edgesToSuperview()
    
    iconBG.topToSuperview(offset: 10)
    iconBG.leftToSuperview(offset: 8)
    iconBG.width(42)
    iconBG.height(to: iconBG, iconBG.widthAnchor)
    
    icon.edgesToSuperview()
    
    notificationLabel.leftToRight(of: iconBG, offset: 8)
    notificationLabel.top(to: iconBG)
    notificationLabel.bottom(to: iconBG)
    notificationLabel.rightToSuperview(offset : -8)
    
    border.edgesToSuperview(excluding: .top)
    border.height(1)
    
    container.bottom(to: iconBG, offset : 10)
  }
  
  //Replenish With Data
  private func gotNotification(){
    guard let notification = self.notification else {return}
    let senderId = notification.senderId
    let notificationType = notification.notificationType
    let isSeen = notification.isSeen
    let transitionId = notification.transitionId
    
    //Setting the notification type
    self.notificationType = notificationType
    //Setting the isSeen
    self.isSeen = isSeen
    //Setting the transitionId
    self.transitionId = transitionId
    
    // Checking the cache user then downloading if not there
    if let savedUser = cacheUsers.object(forKey: NSString(string: "\(senderId)")) as? StructWrapper<NCUser>{
      let u = savedUser.value
      self.sender = u
    }else{
      self.downloadUser(uid: senderId) { (user, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        self.sender = user
        cacheUsers.setObject(StructWrapper<NCUser>(user!), forKey: NSString(string: "\(senderId)"))
      }
    }
  }
  
  //Create Notification Text With Data
  private func processNotificationType(){
    guard let sender = self.sender,
          let notificationLabel = self.notificationLabel,
      let notificationType = self.notificationType else {return}
    
    let senderName = sender.username
    let boldAttrs = [NSAttributedString.Key.font : NCFont.bold(size: 14)]
    let notificationText = NSMutableAttributedString(string: senderName, attributes: boldAttrs)
    
    var notiText = ""
    
    switch notificationType {
    case NCNotificationType.comment.rawValue :
      notiText = " has commented in your article."
    case NCNotificationType.articleLike.rawValue :
      notiText = " has liked your article."
    case NCNotificationType.articleDislike.rawValue :
      notiText = " has disliked your article."
    case NCNotificationType.commentDislike.rawValue :
      notiText = " has liked your comment."
    case NCNotificationType.commentDislike.rawValue :
      notiText = " has disliked your comment."
    case NCNotificationType.follow.rawValue :
      notiText = " has started following you."
    default:
      notiText = ""
    }
    let normalAttrs = [NSAttributedString.Key.font : NCFont.normal(size: 14)]
    let normalString = NSMutableAttributedString(string: notiText, attributes: normalAttrs)
    
    notificationText.append(normalString)
    notificationLabel.attributedText = notificationText
    
  }
  
  private func processIsSeen(){
    guard let isSeen = self.isSeen else {return}
    self.backgroundColor = isSeen ? NCColors.white : NCColors.gray
  }
}
