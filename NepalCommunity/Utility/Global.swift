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
  static let USERS_REF = "users"
  static let USER_ID = "uid"
  static let USERNAME = "username"
  static let ICON_URL = "icon_url"
  static let DOB = "dob"
  static let ACCOUNT_TYPE = "account_type"
  static let DATE_CREATED = "date_created"
  static let EMAIL = "email"
}

class StorageReference{
  static let USER_PROFILE = "user_profile"
  static let PROFILE_IMAGE = "profile_image.jpg"
}
