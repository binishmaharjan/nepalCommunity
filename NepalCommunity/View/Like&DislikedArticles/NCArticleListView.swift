//
//  NCArticleListView.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/04.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase

enum NCArticleListType : String{
  case likedArticle = "like_article"
  case dislikeArticle = "dislike_article"
}


class NCArticleListView : NCBaseView{
  //MARK: Variables
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  
  //TableView
  private var tableView : UITableView?
  
  typealias Cell1 = NCArticleCell
  let CELL1_CLASS = Cell1.self
  let CELL1_ID = NSStringFromClass(Cell1.self)
  
  //User
  var user : NCUser?
  
  var title : NCArticleListType = .likedArticle{
    didSet{
      switch title {
      case .likedArticle:
        titleLbl?.text = LOCALIZE("Like Articles")
      case .dislikeArticle:
        titleLbl?.text = LOCALIZE("Dislike Articles")
      }
      self.downloadArticleList()
    }
  }
  
  private var articles : [NCArticle] = [NCArticle]()
  
  //MARK: Default Functions
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
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
extension NCArticleListView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? Cell1,
      let user = self.user{
      cell.user = user
      cell.article = articles[indexPath.row]
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
}

//MARK: Button Delegate
extension NCArticleListView : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    NCPager.shared.pop(animated : true)
  }
}

//MARK : Download Data
extension NCArticleListView{
  private func downloadArticleList(){
    guard let user = self.user
      else {return}
    
    let ref  = Firestore.firestore()
      .collection(DatabaseReference.USERS_REF)
      .document(user.uid)
      .collection(title.rawValue)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error {
          Dlog(error.localizedDescription)
          return
        }
        
        guard let snapshot = snapshot else {return}
        let documents = snapshot.documents
        
        let dispatchGroup : DispatchGroup = DispatchGroup()
        
        documents.forEach({ (document) in
          let data = document.data()
          guard let articleId = data[DatabaseReference.ARTICLE_ID] as? String else {return}
          
          dispatchGroup.enter()
          self.downloadArticle(articleId: articleId, completion: { (article, error) in
            if let error = error{
              Dlog(error.localizedDescription)
              dispatchGroup.leave()
              return
            }
            
            guard let a = article else {
              dispatchGroup.leave()
              return
            }
            
            self.articles.append(a)
            dispatchGroup.leave()
          })
        })
        
        dispatchGroup.notify(queue: .main, execute: {
          self.tableView?.reloadData()
        })
      })
    }
  }
  
  private func downloadArticle(articleId : String, completion : ((NCArticle?, Error?) ->())?){
    let ref = Firestore.firestore()
      .collection(DatabaseReference.ARTICLE_REF)
      .whereField(DatabaseReference.ARTICLE_ID, isEqualTo: articleId)
    
    DispatchQueue.global(qos: .default).async {
      ref.getDocuments(completion: { (snapshot, error) in
        if let error = error{
          completion?(nil,error)
          return
        }
        
        guard let snapshot = snapshot else {
          completion?(nil, NSError.init(domain: "No Snapshot", code: -1, userInfo: nil))
          return
        }
        
        guard let document = snapshot.documents.first else{
          completion?(nil,NSError.init(domain: "No Document", code: -1, userInfo: nil))
          return
        }
        
        let data = document.data()
        do{
          let article = try FirebaseDecoder().decode(NCArticle.self, from: data)
          completion?(article,nil)
        }catch{
          completion?(nil,error)
        }
      })
    }
  }
}

