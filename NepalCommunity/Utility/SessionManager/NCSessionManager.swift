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
import InstantSearch

class NCSessionManager{
  private  init(){}
  
  static let shared = NCSessionManager()
  
  //Algoria
  #if DEBUG
  let client = Client(appID: "TEX8MYT9UR", apiKey: "878e7eed2af88d0f48b5b180bc1d92ea")
  #else
  let client = Client(appID: "TEX8MYT9UR", apiKey: "878e7eed2af88d0f48b5b180bc1d92ea")
  #endif
  
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
        NCNotificationManager.postSessionUserDownloaded()
      }catch{
        Dlog(error.localizedDescription)
      }
      
    }
    
  }
  
  func signOut(){
    
  }
}
