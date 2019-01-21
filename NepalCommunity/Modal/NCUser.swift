//
//  NCUser.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct NCUser : Codable{
  let accountType:String
  let dateCreated:String
  let iconUrl: String
  let uid: String
  let username:String
  let email:String
  let followers :Int?
  let following :Int?
  
  private enum CodingKeys: String, CodingKey {
    case accountType = "account_type"
    case dateCreated = "date_created"
    case iconUrl = "icon_url"
    case uid
    case username
    case email
    case followers
    case following
  }
}

