//
//  NCStorage.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/08.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

protocol NCStorage{
  func saveImageToStorage(image : UIImage, userId : String,completion: ((String?, Error?) -> ())?)
}


extension NCStorage{
  func saveImageToStorage(image : UIImage, userId : String,completion: ((String?, Error?) -> ())?){
    //Profile IMage 
    let profileImage = image
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    
    let imageData : Data = profileImage.jpegData(compressionQuality: 0.5)!
    
    let store = Storage.storage()
    let user = Auth.auth().currentUser
    if let user = user{
      let storeRef = store.reference().child("\(StorageReference.USER_PROFILE)/\(user.uid)/\(StorageReference.PROFILE_IMAGE)")
      
      let _ = storeRef.putData(imageData, metadata: metaData) { (metadata, error) in
        guard let _  = metadata else{
          completion?(nil,error)
          return
        }
        
        storeRef.downloadURL(completion: { (url, error) in
          guard let url = url else {
            completion?(nil,error)
            return
          }
          completion?(url.absoluteString,error)
        })
      }
    }
  }
}
