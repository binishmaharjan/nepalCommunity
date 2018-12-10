//
//  NCDatebaseWrite.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/30.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import CodableFirebase

protocol NCDatabaseWrite{
  func writeEmailUser(userId : String, username: String,iconUrl : String,email : String, completion : ((_ error: Error?)->())? )
  func writeFacebookUser(userId: String, username: String, iconUrl: String, email : String, completion: ((Error?) -> ())?)
  
  func postArticle(userId: String, title: String, description: String, category : String,imageURL : String, hasImage : Int, completion : ((Error?) -> ())?)

}


extension NCDatabaseWrite{
  
  private func randomID(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
  }
  
  func writeEmailUser(userId: String, username: String, iconUrl: String, email : String, completion: ((Error?) -> ())?) {
    
    let user = NCUser.init(accountType: NCAccountType.email.rawValue, dateCreated: NCDate.dateToString(), iconUrl: iconUrl, uid: userId, username: username, email: email)
    do{
      let data = try FirestoreEncoder().encode(user) as [String : AnyObject]
    Firestore.firestore().collection(DatabaseReference.USERS_REF).document(userId).setData(data) { (error) in
        if let error = error{
          completion?(error)
        }else{
          completion?(nil)
        }
      }
    }catch{
      completion?(error)
    }
  }
  
  func writeFacebookUser(userId: String, username: String, iconUrl: String,email: String, completion: ((Error?) -> ())?) {
    
    let user = NCUser.init(accountType: NCAccountType.facebook.rawValue, dateCreated: NCDate.dateToString(), iconUrl: iconUrl, uid: userId, username: username, email: email)
    do{
      let data = try FirestoreEncoder().encode(user) as [String : AnyObject]
      Firestore.firestore().collection(DatabaseReference.USERS_REF).document(userId).setData(data) { (error) in
        if let error = error{
          completion?(error)
        }else{
          completion?(nil)
        }
      }
    }catch{
      completion?(error)
    }
  }
  
  func postArticle(userId: String, title: String, description: String, category : String,imageURL : String,hasImage : Int, completion : ((Error?) -> ())?){
    
    let articleId = randomID(length: 20)
    let article = NCArticle.init(articleDescription: description,
                                 articleTitle: title,
                                 commentCount: 0,
                                 dateCreated: NCDate.dateToString(),
                                 dislikeCount: 0,
                                 hasImage: hasImage,
                                 likeCount: 0,
                                 uid: userId,
                                 articleCategory: category,
                                 articleId: articleId,
                                 imageUrl : imageURL)
    
    do{
      let data = try FirestoreEncoder().encode(article) as [String : AnyObject]
      Firestore.firestore().collection(DatabaseReference.ARTICLE_REF).document(articleId).setData(data) { (error) in
        if let error = error{
          completion?(error)
        }else{
          completion?(nil)
        }
      }
    }catch{
      completion?(error)
    }
  }
}
