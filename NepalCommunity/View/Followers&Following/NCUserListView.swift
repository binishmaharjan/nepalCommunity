//
//  NCUserListView.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/30.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase

enum NCUserListType : String{
  case follower = "Followers"
  case following = "Following"
}

class NCUserListView : NCBaseView{
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  
  //TableView
  private var tableView : UITableView?
  
  typealias Cell1 = NCUserCell
  let CELL1_CLASS = Cell1.self
  let CELL1_ID = NSStringFromClass(Cell1.self)
  
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  var user : NCUser?
  
  var title :NCUserListType?{
    didSet{
      titleLbl?.text = title?.rawValue
      self.loadUserList()
    }
  }
  
  //Users
  private var users : [NCUser] = [NCUser]()
  
  private func setup(){
    //Header
    let header = UIView()
    header.backgroundColor = NCColors.blue
    self.addSubview(header)
    self.header = header
    
    let backBtn = NCImageButtonView()
    backBtn.image = UIImage(named:"icon_back_white")
    header.addSubview(backBtn)
    backBtn.delegate = self
    self.backBtn = backBtn
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
    
    let tableView = UITableView()
    self.tableView = tableView
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    
  }
  
  private func setupConstraints(){
    guard let header = self.header,
      let backBtn = self.backBtn,
      let titleLbl = self.titleLbl,
      let tableView = self.tableView
    else {return}
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
    tableView.topToBottom(of: header)
    tableView.edgesToSuperview(excluding: .top)
  }
}

//MARK : UITableView Delegate
extension NCUserListView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? Cell1{
      cell.selectionStyle = .none
      cell.user = self.users[indexPath.row]
      return cell
    }
    return UITableViewCell()
  }
}

//MARK: Button Delegate
extension NCUserListView : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    NCPager.shared.pop(animated : true)
  }
}

//MARK : Download Data
extension NCUserListView{
  private func loadUserList(){
    guard let user = self.user,
      let title = self .title else {return}
    
    let ref : CollectionReference?
    switch title {
    case .follower :
      ref = Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(user.uid)
        .collection(DatabaseReference.FOLLOWERS)
    case .following:
      ref = Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(user.uid)
        .collection(DatabaseReference.FOLLOWING)
    }
    
    guard let tRef = ref else {return}
    
    DispatchQueue.global(qos: .default).async {
      tRef.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        
        guard let snapshot = snapshot else {
          Dlog("No Snapshot")
          return
        }
        
        let documents = snapshot.documents
        let dispatchGroup = DispatchGroup()
        self.users.removeAll()
        
        documents.forEach({ (document) in
          guard let id = document.get("uid") as? String else {return}
         dispatchGroup.enter()
          self.downloadUser(id: id, completion: { (u, error) in
            if let error = error{
              Dlog(error.localizedDescription)
              dispatchGroup.leave()
              return
            }
            
            guard let u = u else {
              dispatchGroup.leave()
              return
            }
            
            self.users.append(u)
            dispatchGroup.leave()
          })
        })
        
        dispatchGroup.notify(queue: .main){
          self.tableView?.reloadData()
        }
      })
    }
  }
  
  private func downloadUser(id : String,completion: (( NCUser?,Error?) -> ())?){
    let ref = Firestore.firestore().collection(DatabaseReference.USERS_REF).whereField(DatabaseReference.USER_ID, isEqualTo: id)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error {
          completion?(nil,error)
          return
        }
        
        guard let snapshot = snapshot else {
          completion?(nil,NSError.init(domain: "No Snap", code: -1, userInfo: nil))
          return
        }
        
        let documents = snapshot.documents
        if documents.count > 0{
          let document = documents.first
          do{
            let data = document?.data()
            let u = try FirebaseDecoder().decode(NCUser.self, from: data)
            completion?(u,nil)
          }catch{
            completion?(nil,error)
          }
        }
      })
    }
  }
}
