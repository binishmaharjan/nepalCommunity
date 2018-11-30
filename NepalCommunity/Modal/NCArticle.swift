//
//  NCArticle.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/28.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
struct NCArticle : Codable{
  let articleDescription : String
  let articleTitle : String
  let commentCount : Int
  let dateCreated : String
  let dislikeCount : Int
  let hasImage : Int
  let likeCount : Int
  let uid : String
  let articleCategory : String
  let articleId : String
  let imageUrl : String
  
  private enum CodingKeys: String, CodingKey {
    case articleDescription = "article_description"
    case articleTitle = "article_title"
    case commentCount = "comment_count"
    case dateCreated = "date_created"
    case dislikeCount = "dislike_count"
    case hasImage = "has_image"
    case likeCount = "like_count"
    case uid
    case articleCategory = "article_category"
    case articleId  = "article_id"
    case imageUrl = "image_url"
  }
  
}
