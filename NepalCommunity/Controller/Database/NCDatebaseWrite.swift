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
  
  //Register Email User
  func writeEmailUser(userId: String, username: String, iconUrl: String, email : String, completion: ((Error?) -> ())?) {
    
    let user = NCUser.init(accountType: NCAccountType.email.rawValue,
                           dateCreated: NCDate.dateToString(),
                           iconUrl: iconUrl,
                           uid: userId,
                           username: username,
                           email: email,
                           followers:0,
                           following :0)
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
  
  //Register Facebook User
  func writeFacebookUser(userId: String, username: String, iconUrl: String,email: String, completion: ((Error?) -> ())?) {
    
    let user = NCUser.init(accountType: NCAccountType.facebook.rawValue,
                           dateCreated: NCDate.dateToString(),
                           iconUrl: iconUrl,
                           uid: userId,
                           username: username,
                           email: email,
                           followers:0,
                           following :0)
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
  
  
  //Post Article
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
  
  
  //Post Comment
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
  
  
  //Report User
  func report(id: String, type : String,uid:String, completion : ((Error?) -> ())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore()
        .collection(DatabaseReference.REPORT_REF)
        .document(id)
        .collection(DatabaseReference.REPORT_IDS)
        .document(uid)
        .setData([
          DatabaseReference.DATE_CREATED : NCDate.dateToString(),
          DatabaseReference.REPORT_TYPE : type
        ]) { (error) in
          if let error = error{
            DispatchQueue.main.async {
              completion?(error)
            }
          }else{
            DispatchQueue.main.async {
              completion?(nil)
            }
          }
      }
    }
  }
  
  //Delete the Comment
  func deleteComment(articleId: String, commentId : String,completion : ((Error?)->())?){
    let commentRef = Firestore.firestore()
      .collection(DatabaseReference.ARTICLE_REF)
      .document(articleId)
      .collection(DatabaseReference.COMMENT_REF)
      .document(commentId)
    
    let dispatchGroup : DispatchGroup = DispatchGroup()
    
    //Deleting the like IDs
    DispatchQueue.global(qos: .default).async {
      dispatchGroup.enter()
      self.deleteSingleCollection(ref: commentRef.collection(DatabaseReference.LIKE_ID_REF), completion: { (error) in
        if let _ = error{
          dispatchGroup.leave()
          return
        }
        dispatchGroup.leave()
      })
    }
    
    //Deleteting all the dislike Ids
    DispatchQueue.global(qos: .default).async {
      dispatchGroup.enter()
      self.deleteSingleCollection(ref: commentRef.collection(DatabaseReference.DISLIKE_ID_REF), completion: { (error) in
        if let _ = error{
          dispatchGroup.leave()
          return
        }
        dispatchGroup.leave()
      })
    }
    
    //Deleting the comment Itself
    dispatchGroup.notify(queue: .global(qos: .default)) {
      self.deleteSingleDocument(ref: commentRef, completion: { (error) in
        if let error = error{
          completion?(error)
          return
        }
        completion?(nil)
      })
    }
  }
  
  //Deleting the aricle
  func deleteArticle(articleId : String, completion : ((Error?)->())?){
    let articleRef = Firestore.firestore()
      .collection(DatabaseReference.ARTICLE_REF)
      .document(articleId)
    let dispatchGroup = DispatchGroup()
    
    //Getting all comments
    DispatchQueue.global(qos: .default).async {
      let commentRef = articleRef.collection(DatabaseReference.COMMENT_REF)
      commentRef.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(error)
          return
        }
        
        guard let snapshot = snapshot else {
          completion?(NSError.init(domain: "No Snapshot", code: -1, userInfo: nil))
          return
        }
        
        let documents = snapshot.documents
        documents.forEach({ (document) in
          dispatchGroup.enter()
          let data = document.data()
          guard let commentId = data[DatabaseReference.COMMENT_ID] as? String else{
            dispatchGroup.leave()
            return
          }
          
          self.deleteComment(articleId: articleId, commentId: commentId, completion: { (error) in
            if let _ = error{
              dispatchGroup.leave()
              return
            }
            dispatchGroup.leave()
          })
        })
      })
    }
    
    //Deleteting all the dislike Ids
    DispatchQueue.global(qos: .default).async {
      dispatchGroup.enter()
      self.deleteSingleCollection(ref: articleRef.collection(DatabaseReference.DISLIKE_ID_REF), completion: { (error) in
        if let _ = error{
          dispatchGroup.leave()
          return
        }
        dispatchGroup.leave()
      })
    }
    
    //Deleting the dislike IDs
    DispatchQueue.global(qos: .default).async {
      dispatchGroup.enter()
      self.deleteSingleCollection(ref: articleRef.collection(DatabaseReference.LIKE_ID_REF), completion: { (error) in
        if let _ = error{
          dispatchGroup.leave()
          return
        }
        dispatchGroup.leave()
      })
    }
    
    //Deleting the Article Itself
    dispatchGroup.notify(queue: .global(qos: .default)) {
      self.deleteSingleDocument(ref: articleRef, completion: { (error) in
        if let error = error{
          completion?(error)
          return
        }
        completion?(nil)
      })
    }
    
  }
  
  //Delete the single Colletion
  func deleteSingleCollection(ref : CollectionReference, completion : ((Error?)->())?){
    DispatchQueue.global(qos: .default).async {
      
      let dispatchGroup = DispatchGroup()
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(error)
          return
        }
        
        guard let snapshot = snapshot else {
          completion?(NSError.init(domain: "No Snapshot", code: -1, userInfo: nil))
          return
        }
        
        let documents = snapshot.documents
        documents.forEach({ (document) in
          dispatchGroup.enter()
          guard let id = document.data()[DatabaseReference.USER_ID] as? String else {
            dispatchGroup.leave()
            return
          }
          
          let documentRef = ref.document(id)
          self.deleteSingleDocument(ref: documentRef, completion: { (error) in
            if let _ = error {
              dispatchGroup.leave()
              return
            }
            
            //Successful
            dispatchGroup.leave()
          })
        })
      })
      
      dispatchGroup.notify(queue: .main, execute: {
        completion?(nil)
      })
    }
  }
  
  //Deletion of the single Document
  func deleteSingleDocument(ref : DocumentReference, completion : ((Error?) -> ())?){
    DispatchQueue.global(qos: .default).async {
      ref.delete(completion: { (error) in
        if let error = error {
          completion?(error)
        }
        completion?(nil)
      })
    }
  }
  
  //Register Like Articles
  func registerLikedArticle(uid : String, aritcleid:String, completion :((Error?)->())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(uid)
        .collection(DatabaseReference.LIKED_ARTICLE)
        .document(aritcleid)
        .setData([DatabaseReference.ARTICLE_ID:aritcleid,
                  DatabaseReference.DATE_CREATED : NCDate.dateToString()], completion: { (error) in
                    if let error = error {
                      completion?(error)
                    }
                    completion?(nil)
        })
    }
  }
  
  
  //Register Dislike Articles
  func registerDislikeArticle(uid : String, aritcleid:String, completion :((Error?)->())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(uid)
        .collection(DatabaseReference.DISLIKE_ARTICLE)
        .document(aritcleid)
        .setData([DatabaseReference.ARTICLE_ID:aritcleid,
                  DatabaseReference.DATE_CREATED : NCDate.dateToString()], completion: { (error) in
                    if let error = error {
                      completion?(error)
                    }
                    completion?(nil)
        })
    }
  }
  
  //Remove Like Article
  func removeLikedArticle(uid : String, aritcleid:String, completion :((Error?)->())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(uid)
        .collection(DatabaseReference.LIKED_ARTICLE)
        .document(aritcleid)
        .delete(completion: { (error) in
          if let error = error{
            completion?(error)
          }
          completion?(nil)
        })
    }
  }
  
  //Remove Dislike Article
  func removeDislikedArticle(uid : String, aritcleid:String, completion :((Error?)->())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(uid)
        .collection(DatabaseReference.DISLIKE_ARTICLE)
        .document(aritcleid)
        .delete(completion: { (error) in
          if let error = error{
            completion?(error)
          }
          completion?(nil)
        })
    }
  }
  
  //Edit Profile
  func editField(uid : String, name : String, url : String, completion : ((NCUser?,Error?)->())?){
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(uid)
        .updateData([
          DatabaseReference.USERNAME : name,
          DatabaseReference.ICON_URL : url
          ], completion: { (error) in
            if let error = error{completion?(nil,error)}
            
            Firestore.firestore().collection(DatabaseReference.USERS_REF).document(uid).getDocument(completion: { (snapshot, error) in
              if let error = error{
                completion?(nil,error)
                return
              }
              
              guard let snapshot = snapshot,
                let data = snapshot.data()
                else {
                  completion?(nil,NSError.init(domain: "Error", code: -1, userInfo: nil))
                  return
              }
              
              do{
                let user = try FirestoreDecoder().decode(NCUser.self, from: data)
                completion?(user,nil)
              }catch{
                completion?(nil,error)
              }
            })
        })
    }
  }
}
