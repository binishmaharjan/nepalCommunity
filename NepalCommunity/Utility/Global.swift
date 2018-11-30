//
//  Global.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/24.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


#if DEBUG
let IS_DEBUG = true
#else
let IS_DEBUG = false
#endif

//Log for Debug
func Dlog(_ obj: Any? = nil, file:String = #file, function:String = #function, line: Int = #line){
  #if DEBUG
  var filename:NSString = file as NSString
  filename = filename.lastPathComponent as NSString
  if let obj = obj{
    print("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
  }else{
    print("[File:\(filename) Func:\(function) Line:\(line)]")
  }
  #endif
}

//Log for Release
func Alog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line){
  var filename: NSString = file as NSString
  filename = filename.lastPathComponent as NSString
  if let obj = obj{
    NSLog("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
  }else{
    NSLog("[File:\(filename) Func:\(function) Line:\(line)]")
  }
}

//Localize Text
func LOCALIZE(_ text: String) -> String{
  return NSLocalizedString(text, comment: "")
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class DatabaseReference{
  //User
  static let USERS_REF = "users"
  static let USER_ID = "uid"
  static let USERNAME = "username"
  static let ICON_URL = "icon_url"
  static let DOB = "dob"
  static let ACCOUNT_TYPE = "account_type"
  static let DATE_CREATED = "date_created"
  static let EMAIL = "email"
  
  
  //Article
  static let ARTICLE_REF = "article"
  static let ARTICLE_ID = "article_id"
  static let LIKE_COUNT = "like_count"
  static let DISLIKE_COUNT = "dislike_count"
  static let ARTICLE_TITLE = "article_title"
  static let ARTICLE_DESCRIPTION = "article_description"
  static let IMAGE_URL = "image_url"
  static let HAS_IMAGE = "has_image"
  static let COMMENT_COUNT = "comment_count"
  static let ARTICLE_CATEGORY = "article_category"
}

class StorageReference{
  static let USER_PROFILE = "user_profile"
  static let PROFILE_IMAGE = "profile_image.jpg"
  
  static let ARTICLE_IMAGES = "article_images"
}
