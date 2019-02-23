//
//  NCDatabaseAccess.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/10.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase


protocol NCDatabaseAccess{
  func downloadUser(uid: String,completion: (( NCUser?,Error?) -> ())?)
  func downloadArticle(articleId: String,completion: (( NCArticle?,Error?) -> ())?)
  func checkedLike(uid:String, articleId: String, completion: (( Bool?,Error?) -> ())?)
  func checkedDislike(uid:String, articleId:String,completion: ((Bool?,Error?) -> ())?)
}

extension NCDatabaseAccess{
  func downloadUser(uid: String,completion: (( NCUser?,Error?) -> ())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore().collection(DatabaseReference.USERS_REF)
        .whereField(DatabaseReference.USER_ID, isEqualTo: uid)
        .getDocuments { (snapshot, error) in
          if let error = error {
            DispatchQueue.main.async {completion?(nil,error)}
            return
          }
          
          guard let snapshot = snapshot,
            let first =  snapshot.documents.first else {return}
          let data = first.data()
          do{
            let user = try FirebaseDecoder().decode(NCUser.self, from: data)
            DispatchQueue.main.async {completion?(user,nil)}
          }catch{
            DispatchQueue.main.async {completion?(nil,error)}
          }
      }
    }
  }
  
  func downloadArticle(articleId: String,completion: (( NCArticle?,Error?) -> ())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore().collection(DatabaseReference.ARTICLE_REF)
        .whereField(DatabaseReference.ARTICLE_ID, isEqualTo: articleId)
        .getDocuments { (snapshot, error) in
          if let error = error {
            DispatchQueue.main.async {completion?(nil,error)}
            return
          }
          
          guard let snapshot = snapshot,
            let first =  snapshot.documents.first else {return}
          let data = first.data()
          do{
            let article = try FirebaseDecoder().decode(NCArticle.self, from: data)
            DispatchQueue.main.async {completion?(article,nil)}
          }catch{
            DispatchQueue.main.async {completion?(nil,error)}
          }
      }
    }
  }
  
  func checkedLike(uid:String, articleId: String, completion: (( Bool?,Error?) -> ())?){
    
    if let savedLike = cacheLike.object(forKey: NSString(string: "\(articleId)")) as? BoolWrapper{
      let b = savedLike.value
      completion?(b,nil)
    }else{
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(articleId)
          .collection(DatabaseReference.LIKE_ID_REF)
          .document(uid).getDocument { (snapshot, error) in
            
            if let error = error {
              DispatchQueue.main.async {completion?(nil,error)}
              return
            }
            
            guard let snapshot = snapshot else {
              DispatchQueue.main.async {
                completion?(nil,NSError.init(domain: "No SnapShot", code: -1, userInfo: nil))
              }
              return
            }
            
            let data = snapshot.data()
            
            if data == nil{
              cacheLike.setObject(BoolWrapper(false), forKey: NSString(string: "\(articleId)"))
              DispatchQueue.main.async {completion?(false,nil)}
            }else{
              cacheLike.setObject(BoolWrapper(true), forKey: NSString(string: "\(articleId)"))
              DispatchQueue.main.async {completion?(true,nil)}
            }
        }
      }
    }
  }
  
  func checkedDislike(uid:String, articleId:String,completion: ((Bool?,Error?) -> ())?){
    
    if let savedDislike = cacheDislike.object(forKey: NSString(string: "\(articleId)")) as? BoolWrapper{
      let b = savedDislike.value
      completion?(b,nil)
    }else{
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(articleId)
          .collection(DatabaseReference.DISLIKE_ID_REF)
          .document(uid).getDocument(completion: { (snapshot, error) in
            if let error = error{
              DispatchQueue.main.async {completion?(nil,error)}
              return
            }
            
            guard let snapshot = snapshot else {
              DispatchQueue.main.async {
                completion?(nil,NSError.init(domain: "No SnapShot", code: -1, userInfo: nil))
              }
              return
            }
            
            let data = snapshot.data()
            
            if data == nil{
              cacheDislike.setObject(BoolWrapper(false), forKey: NSString(string: "\(articleId)"))
              DispatchQueue.main.async { completion?(false, nil)}
            }else{
              cacheDislike.setObject(BoolWrapper(true), forKey: NSString(string: "\(articleId)"))
              DispatchQueue.main.async { completion?(true, nil)}
            }
          })
      }
    }
  }
  
  func checkedCommentLike(uid:String, articleId: String,commentId : String, completion: (( Bool?,Error?) -> ())?){
    
    if let savedLike = cacheCommentLike.object(forKey: NSString(string: "\(commentId)")) as? BoolWrapper{
      let b = savedLike.value
      completion?(b,nil)
    }else{
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(articleId)
          .collection(DatabaseReference.COMMENT_REF)
          .document(commentId)
          .collection(DatabaseReference.LIKE_ID_REF)
          .document(uid).getDocument { (snapshot, error) in
            
            if let error = error {
              DispatchQueue.main.async {completion?(nil,error)}
              return
            }
            
            guard let snapshot = snapshot else {
              DispatchQueue.main.async {
                completion?(nil,NSError.init(domain: "No SnapShot", code: -1, userInfo: nil))
              }
              return
            }
            
            let data = snapshot.data()
            
            if data == nil{
              cacheCommentLike.setObject(BoolWrapper(false), forKey: NSString(string: "\(commentId)"))
              DispatchQueue.main.async {completion?(false,nil)}
            }else{
              cacheCommentLike.setObject(BoolWrapper(true), forKey: NSString(string: "\(commentId)"))
              DispatchQueue.main.async {completion?(true,nil)}
            }
        }
      }
    }
  }
  
  func checkedCommentDislike(uid:String, articleId: String,commentId : String, completion: (( Bool?,Error?) -> ())?){
    
    if let savedLike = cacheCommentDislike.object(forKey: NSString(string: "\(commentId)")) as? BoolWrapper{
      let b = savedLike.value
      completion?(b,nil)
    }else{
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(articleId)
          .collection(DatabaseReference.COMMENT_REF)
          .document(commentId)
          .collection(DatabaseReference.DISLIKE_ID_REF)
          .document(uid).getDocument { (snapshot, error) in
            
            if let error = error {
              DispatchQueue.main.async {completion?(nil,error)}
              return
            }
            
            guard let snapshot = snapshot else {
              DispatchQueue.main.async {
                completion?(nil,NSError.init(domain: "No SnapShot", code: -1, userInfo: nil))
              }
              return
            }
            
            let data = snapshot.data()
            
            if data == nil{
              cacheCommentDislike.setObject(BoolWrapper(false), forKey: NSString(string: "\(commentId)"))
              DispatchQueue.main.async {completion?(false,nil)}
            }else{
              cacheCommentDislike.setObject(BoolWrapper(true), forKey: NSString(string: "\(commentId)"))
              DispatchQueue.main.async {completion?(true,nil)}
            }
        }
      }
    }
  }
  
  func checkFollow(uid :String, ouid : String, completion: (( Bool?,Error?) -> ())?){
    if let savedFollow = cacheFollow.object(forKey: NSString(string: "\(ouid)")) as? BoolWrapper{
      let b = savedFollow.value
      completion?(b,nil)
    }else{
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(uid)
          .collection(DatabaseReference.FOLLOWING)
          .document(ouid)
          .getDocument(completion: { (snapshot, error) in
            if let error = error {
              DispatchQueue.main.async {completion?(nil,error)}
              return
            }
            
            guard let snapshot = snapshot else {
              DispatchQueue.main.async {
                completion?(nil,NSError.init(domain: "No SnapShot", code: -1, userInfo: nil))
              }
              return
            }
            
            let data = snapshot.data()
            
            if data == nil{
              cacheFollow.setObject(BoolWrapper(false), forKey: NSString(string: "\(ouid)"))
              DispatchQueue.main.async {completion?(false,nil)}
            }else{
              cacheFollow.setObject(BoolWrapper(true), forKey: NSString(string: "\(ouid)"))
              DispatchQueue.main.async {completion?(true,nil)}
            }
          })
      }
    }
  }
}
