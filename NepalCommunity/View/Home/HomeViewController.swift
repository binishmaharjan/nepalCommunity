//
//  HomeViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/09.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController : UIViewController{
  
  //handler to the state change of the Auth user
  private var handle: AuthStateDidChangeListenerHandle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 150, height: 50))
    button.setTitle("Sign Out", for: .normal)
    button.addTarget(self, action: #selector(signoutButtonPressed), for: .touchUpInside)
    self.view.addSubview(button)
  }
  
  
  @objc func signoutButtonPressed(){
    let firebaseAuth = Auth.auth()
    do{
      try firebaseAuth.signOut()
    }catch{
      debugPrint("Error signing out \(error.localizedDescription)")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user == nil{
        let loginvc = UINavigationController(rootViewController: NCLoginViewController())
        self.present(loginvc, animated: true, completion: nil)
      }else{
        //User is logged in
      }
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}
