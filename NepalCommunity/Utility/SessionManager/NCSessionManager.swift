//
//  NCSessionManager.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

class NCSessionManager{
  private  init(){}
  
  static let shared = NCSessionManager()
  
  var user : NCUser?
  
  func userLoggedIn(){
    guard let currentUser = Auth.auth().currentUser else {
      Dlog("No Current User")
      return
    }
    let uid = currentUser.uid

    Firestore.firestore().collection(DatabaseReference.USERS_REF).document(uid).getDocument { (snapshot, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        return
      }
      
      guard let snapshot = snapshot else {
        Dlog("No snapshot")
        return
      }
      
      guard let data = snapshot.data() else {
        Dlog("NO Data")
        return
      }
      
      do{
        self.user  = try FirebaseDecoder().decode(NCUser.self, from: data)
      }catch{
        Dlog(error.localizedDescription)
      }
      
    }
    
  }
  
  func signOut(){
    
  }
}
