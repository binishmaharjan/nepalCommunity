//
//  NCStorage.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/08.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol NCStorage{
  func saveImageToStorage(image : UIImage, userId : String,completion: ((String?, Error?) -> ())?)
  func saveArticleImageToStorage(articleId : String,image : UIImage,completion: ((String?, Error?) -> ())?)
}


extension NCStorage{
  
  //Save user profile image
  func saveImageToStorage(image : UIImage, userId : String,completion: ((String?, Error?) -> ())?){
    //Profile Image (Downloaded from facebook or user upploaded)
    let profileImage = image
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg" // Meta type for the data
    
    let imageData : Data = profileImage.jpegData(compressionQuality: 0.5)!//Converted to JPEG WIth Compression Quality 0.5
    
    let store = Storage.storage()//Access to the storage
    let user = Auth.auth().currentUser//Current Login User
    if let user = user{
      let storeRef = store.reference().child("\(StorageReference.USER_PROFILE)/\(user.uid)/\(StorageReference.PROFILE_IMAGE)")//Reference to the user profile images file.if file is not available new file will be created
      
      //Saving the data to the storage
      DispatchQueue.main.async {
        let _ = storeRef.putData(imageData, metadata: metaData) { (metadata, error) in
          guard let _  = metadata else{
            completion?(nil,error)
            return
          }
          
          //Getting the url after storing the data to the storage
          storeRef.downloadURL(completion: { (url, error) in
            guard let url = url else {
              completion?(nil,error)
              return
            }
            //returning the url to save in the database
            completion?(url.absoluteString,error)
          })
        }
      }
     
    }
  }
  
  //Save the article image
  func saveArticleImageToStorage(articleId : String,image : UIImage,completion: ((String?, Error?) -> ())?){
    //Profile Image (Downloaded from facebook or user upploaded)
    let profileImage = image
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg" // Meta type for the data
    
    let imageData : Data = profileImage.jpegData(compressionQuality: 0.5)!//Converted to JPEG WIth Compression Quality 0.5
    
    let store = Storage.storage()//Access to the storage
    let user = Auth.auth().currentUser//Current Login User
    if let _ = user{
      let storeRef = store.reference().child("\(StorageReference.ARTICLE_IMAGES)/\(articleId)")//Reference to the article image folder
      
      //Saving the data to the storage
      DispatchQueue.main.async {
        let _ = storeRef.putData(imageData, metadata: metaData) { (metadata, error) in
          guard let _  = metadata else{
            completion?(nil,error)
            return
          }
          
          //Getting the url after storing the data to the storage
          storeRef.downloadURL(completion: { (url, error) in
            guard let url = url else {
              completion?(nil,error)
              return
            }
            //returning the url to save in the database
            completion?(url.absoluteString,error)
          })
        }
      }
    }
  }
}
