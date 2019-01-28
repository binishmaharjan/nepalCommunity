//
//  NCUserProfileView.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/28.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase

class NCUserProfileView : NCBaseView{
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private let SETTING_C_X:CGFloat = 16.0
  //  weak var settingBtn :NCImageButtonView?
  private weak var border:UIView?
  
  //TableView
  private var tableView: UITableView?
  
  //Pull Down refresh control
  private let refreshControl = UIRefreshControl()
  
  //CELLS
  typealias Cell1 = NCUserProfileCell
  let CELL1_CLASS = Cell1.self
  let CELL1_ID = NSStringFromClass(Cell1.self)
  
  typealias Cell2 = NCArticleCell
  let CELL2_CLASS = Cell2.self
  let CELL2_ID = NSStringFromClass(Cell2.self)
  
  //Cell Delegate
  var cellDelegate : NCSingleHomeViewDelegate?
  var buttonDelegate : NCButtonDelegate?{
    didSet{
      backBtn?.delegate = buttonDelegate
    }
  }
  
  var user : NCUser?{
    didSet{
      loadArticles()
    }
  }
  
  private var articles : [NCArticle] = [NCArticle]()
  
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
    self.backBtn = backBtn
    
    //    let settingBtn = NCImageButtonView()
    //    settingBtn.image = UIImage(named: "icon_setting")
    //    self.settingBtn = settingBtn
    //    header.addSubview(settingBtn)
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Profile")
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
    //    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    refreshControl.backgroundColor = NCColors.clear
    refreshControl.tintColor = NCColors.blue
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.register(CELL2_CLASS, forCellReuseIdentifier: CELL2_ID)
    
    self.loadArticles()
  }
  
  private func setupConstraints(){
    guard let header = self.header,
      let titleLbl = self.titleLbl,
      //      let settingBtn = self.settingBtn,
      let backBtn = self.backBtn,
      let tableView = self.tableView
      else {return}
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    //    settingBtn.centerYToSuperview()
    //    settingBtn.rightToSuperview(offset : -SETTING_C_X)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset : BACK_C_X)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
    tableView.leftToSuperview()
    tableView.rightToSuperview()
    tableView.topToBottom(of: header)
    tableView.bottomToSuperview()
  }
}

//MARK : TableView Datasource and Delegate
extension NCUserProfileView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1 + articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0, let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? Cell1{
      cell.user = user
      cell.selectionStyle = .none
      return cell
    }
    
    if indexPath.row != 0, let cell = tableView.dequeueReusableCell(withIdentifier: CELL2_ID, for: indexPath) as? Cell2{
      cell.article = articles[indexPath.row - 1]
      cell.selectionStyle = .none
      cell.articleCellSingleHomeDelegate = self
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? NCArticleCell else {
      return
    }
    cell.removeObserverLike()
    cell.removeObserveDisLike()
    cell.removeObserveComment()
  }
  
}


//MARK : Load Data
extension NCUserProfileView {
  private func loadArticles(){
    guard let user = self.user else {return}
    DispatchQueue.global(qos: .default).async {
      let articleRefrence = Firestore.firestore()
        .collection(DatabaseReference.ARTICLE_REF)
        .whereField(DatabaseReference.USER_ID, isEqualTo: user.uid)
        .order(by: DatabaseReference.DATE_CREATED, descending: true)
      
      //Downloading the data, all at once not paging(NG)
      articleRefrence.getDocuments(completion: { (snapshot, error) in
        if let error = error {
          Dlog(error.localizedDescription)
          DispatchQueue.main.async {self.refreshControl.endRefreshing()}
          return
        }
        
        guard let snapshot = snapshot else {
          DispatchQueue.main.async {self.refreshControl.endRefreshing()}
          Dlog("No snapshot")
          return
        }
        
        self.articles.removeAll()
        
        for document in snapshot.documents{
          let data = document.data()
          do{
            let article =  try FirebaseDecoder().decode(NCArticle.self, from: data)
            self.articles.append(article)
          }catch{
            Dlog("\(error.localizedDescription)")
          }
        }
        
        DispatchQueue.main.async {
          DispatchQueue.main.async {self.refreshControl.endRefreshing()}
          self.tableView?.reloadData()
        }
      })
    }
  }
}

//MARK : Cell Delegate
extension NCUserProfileView : NCArticleCellToSingleHomeDelegate{
  func passArticleAndUser(article: NCArticle, user: NCUser) {
    cellDelegate?.cellWasTapped(article: article, user: user)
  }
  
  func menuButtonWasPressed(article: NCArticle) {
    cellDelegate?.menuButtonWasPressed(article: article)
  }
}

