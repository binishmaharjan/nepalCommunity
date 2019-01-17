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
  
  func postArticle(articleId : String, userId: String, title: String, description: String, category : String,imageURL : String, hasImage : Int, completion : ((Error?) -> ())?)
  
}


extension NCDatabaseWrite{
  
  func writeEmailUser(userId: String, username: String, iconUrl: String, email : String, completion: ((Error?) -> ())?) {
    
    let user = NCUser.init(accountType: NCAccountType.email.rawValue, dateCreated: NCDate.dateToString(), iconUrl: iconUrl, uid: userId, username: username, email: email)
    do{
      let data = try FirestoreEncoder().encode(user) as [String : AnyObject]
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(userId).setData(data) { (error) in
            if let error = error{
              DispatchQueue.main.async {completion?(error)}
            }else{
              DispatchQueue.main.async {completion?(nil)}
            }
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
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(userId).setData(data) { (error) in
            if let error = error{
              DispatchQueue.main.async {completion?(error)}
            }else{
             DispatchQueue.main.async {completion?(nil)}
            }
        }
      }
    }catch{
      completion?(error)
    }
  }
  
  func postArticle(articleId : String,userId: String, title: String, description: String, category : String,imageURL : String,hasImage : Int, completion : ((Error?) -> ())?){
    
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
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(articleId)
          .setData(data) { (error) in
            if let error = error{
              DispatchQueue.main.async {completion?(error)}
            }else{
               DispatchQueue.main.async {completion?(nil)}
            }
        }
      }
    }catch{
      completion?(error)
    }
  }
  
  
  func postComment(commentId : String, uid:String, articleId: String, commentString: String,completion : ((Error?) -> ())?){
    
    let comment = NCComment.init(commentId: commentId,
                                 comment: commentString,
                                 dateCreated: NCDate.dateToString(),
                                 likeCount: 0,
                                 dislikeCount: 0,
                                 uid: uid,
                                 articleId: articleId)
    
    do{
      let data = try FirestoreEncoder().encode(comment) as [String : AnyObject]
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore().collection(DatabaseReference.ARTICLE_REF).document(articleId).collection(DatabaseReference.COMMENT_REF).document(commentId).setData(data, completion: { (error) in
          if let error = error{
            DispatchQueue.main.async {
              completion?(error)
            }
          }else{
            DispatchQueue.main.async {
              completion?(nil)
            }
          }
        })
      }
    }catch{
      completion?(error)
    }
  }
}
