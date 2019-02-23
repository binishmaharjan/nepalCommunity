//
//  NCNotificationController.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/07.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase

class NCNotificationController : NCViewController{
  
  //MARK : Variables
  var mainView : NCNotificationView?
  
  //Listener
  var notificationListener : ListenerRegistration?
  
  var isFlag = false
  
  //MARK: Overrides
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.blue
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
    self.setupNotifications()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setup(){
    let mainView = NCNotificationView()
    self.mainView = mainView
    self.view.addSubview(mainView)
    
  }
  
  private func setupConstraints(){
    guard  let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
  
  //Observers
  private func observeListener(){
    guard let user = NCSessionManager.shared.user else {return}
    if notificationListener != nil {self.removeObserver()}
    DispatchQueue.global(qos: .default).async {
      self.notificationListener = Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(user.uid)
        .collection(DatabaseReference.NOTIFICATION_REF)
        .order(by: DatabaseReference.DATE_CREATED, descending: true)
        .limit(to: 1)
        .addSnapshotListener({ (snapshot, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
          guard let snapshot = snapshot else {
            Dlog("No Snapshot")
            return
          }
          
          let _ = snapshot.documents.map{
            let data = $0.data()
            do{
              let notification = try FirebaseDecoder().decode(NCNotification.self, from: data)
              Dlog(notification.notificationId)
            }catch{
              Dlog(error.localizedDescription)
            }
          }
          if self.isFlag{
            appDelegate.tabBarController?.showBadge(isShow: true)
          }else{
            self.isFlag = true
          }
      })
    }
  }
  
  private func removeObserver(){
    guard let notificationListener = self.notificationListener else {return}
    notificationListener.remove()
  }
  
  //Notification
  private func setupNotifications(){
    self.tearDownNotifications()
    
    NCNotificationManager.receive(sessionUserDownloaded: self, selector: #selector(receieveSessionUserDownloaded(_:)))
  }
  
  private func tearDownNotifications(){
    NCNotificationManager.remove(self)
  }
  
  @objc private func receieveSessionUserDownloaded(_ notification : Notification){
    self.observeListener()
    guard let mainView = self.mainView else {return}
    mainView.user = NCSessionManager.shared.user
  }
}
