//
//  NCComment.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/15.
//  Copyright © 2019年 guest. All rights reserved.
//

struct NCComment : Codable {
  let commentId : String
  let comment : String
  let dateCreated : String
  let likeCount : Int
  let dislikeCount : Int
  let uid : String
  let articleId : String
  
  private enum CodingKeys : String, CodingKey{
    case commentId = "commentId"
    case comment =  "comment"
    case dateCreated = "date_created"
    case likeCount = "like_count"
    case dislikeCount = "dislike_count"
    case uid = "uid"
    case articleId = "article_id"
  }
}
