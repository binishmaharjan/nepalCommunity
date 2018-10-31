//
//  NCEmailSignUp.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/30.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import Firebase

protocol NCEmailSignUpProtocol {
  func registerEmail(email : String, password : String, username : String,completion:((_ userId:String?, _ error:Error?)->())?)
}

extension NCEmailSignUpProtocol{
  func registerEmail(email: String, password : String,username: String, completion: ((String?, Error?) -> ())?) {
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      if let error = error{
        completion?(nil,error)
        return
      }
      
      //User
      guard let result  = result else {
        completion?(nil,error)
        return
      }
    
      let user = result.user
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = username
      changeRequest.commitChanges(completion: { (error) in
        if let error = error{
          completion?(nil, error)
          return
        }
      })
      
      //Getting the userid
      let userId = user.uid
      
      completion?(userId,nil)
    }
  }
}
