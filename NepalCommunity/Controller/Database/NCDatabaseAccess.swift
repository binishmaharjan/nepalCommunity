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
}

extension NCDatabaseAccess{
  func downloadUser(uid: String,completion: (( NCUser?,Error?) -> ())?){
    Firestore.firestore().collection(DatabaseReference.USERS_REF)
      .whereField(DatabaseReference.USER_ID, isEqualTo: uid)
      .getDocuments { (snapshot, error) in
        if let error = error {
          completion?(nil,error)
          return
        }
        
        guard let snapshot = snapshot,
          let first =  snapshot.documents.first else {return}
        let data = first.data()
        do{
          let user = try FirebaseDecoder().decode(NCUser.self, from: data)
          completion?(user,nil)
        }catch{
          completion?(nil,error)
        }
    }
  }
}
