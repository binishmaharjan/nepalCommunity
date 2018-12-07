//
//  NCEmailSignUp.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/30.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FirebaseAuth
import SwiftyJSON

protocol NCSignUpAndSignIn{
  func registerEmail(email : String, password : String, username : String,completion:((_ userId:String?, _ error:Error?)->())?)
  
  func registerWithFacebook(viewController : UIViewController, completion : ((Error?) -> ())?)
  func loginWithFacebook(completion: ((Error?) -> ())?)
  func fetchFacebookUser(completion : ((_ name : String?, _ id : String?,_ email : String? , _ image : UIImage?, _ error : Error?) -> ())?)
  func loginWithEmail(email : String, password : String,completion: ((Error?) -> ())?)
}

extension NCSignUpAndSignIn{
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
  
  func registerWithFacebook(viewController : UIViewController, completion : ((Error?) -> ())?){
    Dlog("facebook register")
    let loginManager = LoginManager()
    loginManager.logIn(readPermissions: [.publicProfile,.email,], viewController: viewController) { (result) in
      switch result{
      case .success(grantedPermissions: _, declinedPermissions: _, token: _):
        Dlog("Successfully logged into facebook")
        completion?(nil)
      //Login With Facebook
      case .cancelled:
        completion?(NSError(domain: "Cancelled", code: -1, userInfo: nil))
        Dlog("Cancelled")
      case .failed(let error):
        completion?(error)
        Dlog(error)
      }
    }
  }
  
  
  func loginWithFacebook(completion: ((Error?) -> ())?){
    Dlog("facebook login")
    //Process to sign in to the facebook
    guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
    let credential = FacebookAuthProvider.credential(withAccessToken : authenticationToken)
    Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
      if let error = error{
        completion?(error)
        return
      }
      
      completion?(nil)
      //Fetch The Facebook Information
    }
    
  }
  
  func fetchFacebookUser(completion : ((_ name : String?, _ id : String?,_ email : String? , _ image : UIImage?, _ error : Error?) -> ())?){
    let graphRequestConnection = GraphRequestConnection()
    let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "id,email,name,picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
    graphRequestConnection.add(graphRequest){ (httpResponse, result) in
      switch result{
      case .success(response: let response):
        guard let responseDictionary = response.dictionaryValue else {
          completion?(nil,nil,nil,nil,NSError(domain: "No Response", code: -1, userInfo: nil))
          return
        }
        
        //Converting the response into json using swifty json
        let json = JSON(responseDictionary)
        let name = json["name"].string
        let email = json["email"].string
        guard let urlString = json["picture"]["data"]["url"].string,
          let url = URL(string: urlString) else {
            completion?(nil,nil,nil,nil,NSError(domain: "No Image Url", code: -1, userInfo: nil))
            return
        }
        
        //Downloading the image form the facebook
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            completion?(nil,nil,nil,nil,error)
            return
          }
          
          //If there is no data
          guard let data = data else {
            completion!(nil,nil,nil,nil,NSError(domain: "No Image", code: -1, userInfo: nil))
            return
          }
          let image = UIImage(data: data)!
          
          //Since user is logged in get current user
          let uid = Auth.auth().currentUser?.uid
          
          completion?(name, uid,email,image,nil)
          //Save the image to storage
        }).resume()
        
      case .failed(let error):
        Dlog(error.localizedDescription)
      }
    }
    
    //Starting the connection to the get information form the facebook
    graphRequestConnection.start()
  }
  
  //Signing in the wmail
  func loginWithEmail(email : String, password : String,completion: ((Error?) -> ())?){
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if let error = error{
        completion?(error)
        return
      }
      completion?(nil)
    }
  }
  
}
