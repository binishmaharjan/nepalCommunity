//
//  NCDatebaseWrite.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/30.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import Firebase

protocol NCDatabaseWrite{
  func writeEmailUser(userId : String, username: String,iconUrl : String,email : String, completion : ((_ error: Error?)->())? )
  func writeFacebookUser(userId: String, username: String, iconUrl: String, email : String, completion: ((Error?) -> ())?)
}


extension NCDatabaseWrite{
  func writeEmailUser(userId: String, username: String, iconUrl: String, email : String, completion: ((Error?) -> ())?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    Firestore.firestore().collection(DatabaseReference.USERS_REF).document(userId).setData([
      DatabaseReference.USER_ID : userId,
      DatabaseReference.USERNAME : username,
      DatabaseReference.ACCOUNT_TYPE : NCAccountType.email.rawValue,
      DatabaseReference.DATE_CREATED : formatter.string(from: Date()),
      DatabaseReference.ICON_URL : iconUrl,
      DatabaseReference.EMAIL : email
    ]) { (error) in
      if let error = error{
        completion?(error)
      }else{
        completion?(nil)
      }
    }
  }
  
  func writeFacebookUser(userId: String, username: String, iconUrl: String,email: String, completion: ((Error?) -> ())?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    Firestore.firestore().collection(DatabaseReference.USERS_REF).document(userId).setData([
      DatabaseReference.USER_ID : userId,
      DatabaseReference.USERNAME : username,
      DatabaseReference.ACCOUNT_TYPE : NCAccountType.facebook.rawValue,
      DatabaseReference.DATE_CREATED : formatter.string(from: Date()),
      DatabaseReference.ICON_URL : iconUrl,
      DatabaseReference.EMAIL : email
    ]) { (error) in
      if let error = error{
        completion?(error)
      }else{
        completion?(nil)
      }
    }
  }
}
