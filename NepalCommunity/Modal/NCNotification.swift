//
//  NCNotification.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/18.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit

enum NCNotificationType : String{
  case follow = "follow"
  case comment = "comment"
  case articleLike = "article_like"
  case articleDislike = "article_dislike"
  case commentLike = "comment_like"
  case commentDislike = "comment_dislike"
}


struct NCNotification : Codable{
  
  let notificationId : String
  let senderId : String
  let dateCreated : String
  let notificationType : String
  let transitionId : String
  let isSeen : Bool
  
  private enum CodingKeys: String, CodingKey {
    case notificationId = "notification_id"
    case senderId = "sender_id"
    case dateCreated = "date_created"
    case notificationType = "notification_type"
    case transitionId = "transition_id"
    case isSeen = "is_seen"
  }
}
