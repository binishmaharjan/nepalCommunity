//
//  NCNotificationView.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/07.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase

class NCNotificationView : NCBaseView{
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  
  //Cell
  typealias CELL_1 = NCNotificationCell
  private var CELL1_CLASS = CELL_1.self
  private var CELL1_ID = NSStringFromClass(CELL_1.self)
  
  //TableView
  private weak var tableView : UITableView?
  
  //Last SnapShot
  private var lastSnapshot : QueryDocumentSnapshot?
  private var isLastPage : Bool = false
  private var isLoading: Bool = false
  private var LAST_COUNT : Int = 1
  
  //Refresh Control
  private var refreshControl : UIRefreshControl = UIRefreshControl()
  
  
  //Notification
  var notifiations: [NCNotification] = [NCNotification]()
  
  //User
  var user : NCUser?{
    didSet{
      loadNotification()
    }
  }
  
  //MARK : Overrides
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstranits()
  }
  
  private func setup(){
    let header = UIView()
    header.backgroundColor = NCColors.blue
    self.addSubview(header)
    self.header = header
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Notifications")
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
    
    let tableView = UITableView()
    self.tableView = tableView
    self.addSubview(tableView)
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    tableView.separatorStyle = .none
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    
    refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
    refreshControl.backgroundColor = NCColors.clear
    refreshControl.tintColor = NCColors.blue
    refreshControl.addTarget(self, action: #selector(refreshControlWasDragged), for: .valueChanged)
  }
  
  
  private func setupConstranits(){
    guard let header = self.header,
      let titleLbl = self.titleLbl,
      let tableView = self.tableView
      else {return}
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
    tableView.topToBottom(of: header)
    tableView.edgesToSuperview(excluding: .top)
    
  }
}

//MARK: TableView
extension NCNotificationView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notifiations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? CELL_1{
      cell.notification = notifiations[indexPath.row]
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let startLoadingIndex = self.notifiations.count - LAST_COUNT
    if !isLoading, indexPath.row >= startLoadingIndex{
      loadMoreNotification()
    }
  }
  
  //Refresh Action
  @objc private func refreshControlWasDragged(){
    self.loadNotification()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      appDelegate.tabBarController?.showBadge(isShow: false)
    }
  }
}

//MARK: Data
extension NCNotificationView{
  
  private func loadNotification(){
    
    guard let user = self.user else{return}
    self.isLastPage = false
    
    DispatchQueue.global(qos: .default).async {
      let notificaitonRef = Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(user.uid)
        .collection(DatabaseReference.NOTIFICATION_REF)
        .order(by: DatabaseReference.DATE_CREATED, descending: true)
        .limit(to: 10)
      
      self.isLoading = true
      notificaitonRef.getDocuments(completion: { (snapshot, error) in
        if let error = error {
          Dlog(error.localizedDescription)
          self.isLoading = false
          self.refreshControl.endRefreshing()
          return
        }
        
        guard let snapshot = snapshot else {
          Dlog("No Snapshot")
          self.isLoading = false
          self.refreshControl.endRefreshing()
          return
        }
        
        guard let lastSnapshot = snapshot.documents.last else{
          Dlog("No last snapshot")
          self.isLoading = false
          self.isLastPage = true
          self.refreshControl.endRefreshing()
          return
        }
        
        self.lastSnapshot = lastSnapshot
        self.notifiations.removeAll()
        
        for document in snapshot.documents{
          let data = document.data()
          do{
            let notification = try FirebaseDecoder().decode(NCNotification.self, from: data)
            self.notifiations.append(notification)
          }catch{
            Dlog(error.localizedDescription)
            self.isLoading = false
          }
        }
        
        DispatchQueue.main.async {
          self.refreshControl.endRefreshing()
          self.isLoading = false
          self.tableView?.reloadData()
        }
        
      })
    }
  }
  
  private func loadMoreNotification(){
    guard !isLastPage else {Dlog("last Page"); return}
    guard !isLoading else {Dlog("Still Loading"); return }
    
    guard let lastSnapShot = self.lastSnapshot,
          let user  = self.user
    else{ Dlog("No Last Snapshot"); return }
    
    self.isLoading = true
    DispatchQueue.global(qos: .default).async {
        let notificaitonRef = Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(user.uid)
          .collection(DatabaseReference.NOTIFICATION_REF)
          .order(by: DatabaseReference.DATE_CREATED, descending: true)
          .limit(to: 10)
          .start(afterDocument: lastSnapShot)
      
      notificaitonRef.getDocuments(completion: { (snapshot, error) in
        if let error = error {
          self.isLoading = false
          Dlog(error.localizedDescription)
          return
        }
        
        guard let snapshot = snapshot else{
          self.isLoading = false
          Dlog("No Data")
          return
        }
        
        guard let lastSnapshot = snapshot.documents.last else {
           Dlog("No last snapshot")
          self.isLoading = false
          self.isLastPage = true
          return
        }
        self.lastSnapshot = lastSnapshot
        
        let _ = snapshot.documents.map{
          let data = $0.data()
          do{
            let notification = try FirebaseDecoder().decode(NCNotification.self, from: data)
            self.notifiations.append(notification)
          }catch{
            self.isLoading = false
            Dlog(error.localizedDescription)
          }
        }
        DispatchQueue.main.async {
          self.isLoading = false
          self.tableView?.reloadData()
        }
      })
    }
  }
}

