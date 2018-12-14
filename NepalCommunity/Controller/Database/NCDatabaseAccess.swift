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
  
  func checkedLike(uid:String, articleId: String, completion: (( Bool?,Error?) -> ())?){
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
            DispatchQueue.main.async {completion?(false,nil)}
          }else{
            DispatchQueue.main.async {completion?(true,nil)}
          }
      }
    }
  }
  
  func checkedDislike(uid:String, articleId:String,completion: ((Bool?,Error?) -> ())?){
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
            DispatchQueue.main.async { completion?(false, nil)}
          }else{
            DispatchQueue.main.async { completion?(true, nil)}
          }
        })
    }
  }
}
