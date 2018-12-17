//
//  NCSingleHomeView.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/19.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase

class NCSingleHomeView : NCBaseView{
  
  //mainTableView
  private var tableView: UITableView?
  private var emptyView: NCEmptyTableView?
  var homeViewDelegate : NCSingleHomeViewDelegate?
  
  //TableView Cell
  typealias Cell = NCArticleCell
  let CELL_CLASS = Cell.self
  let CELL_ID = NSStringFromClass(Cell.self)
  
  //Cells
  var articles : [NCArticle] = [NCArticle]()
  //Reference the categories store in the storage
  var referenceTitle : String?{
    didSet{
      self.loadArticles()
    }
  }
  
  //Last SnapShot
  private var lastSnapshot : QueryDocumentSnapshot?
  private var isLastPage : Bool = false
  private var isLoading: Bool = false
  private var LAST_COUNT : Int = 1
  
  //Pull Down refresh control
  private let refreshControl = UIRefreshControl()
  
  private var userCells : [NCUser]?
  
  
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  private func setup(){
    //TableView
    let tableView = UITableView()
    self.tableView = tableView
    tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 15, right: 0)
    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL_CLASS, forCellReuseIdentifier: CELL_ID)
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    
    let emptyView = NCEmptyTableView()
    self.emptyView = emptyView
    tableView.backgroundView = emptyView
    
    refreshControl.backgroundColor = NCColors.clear
    refreshControl.tintColor = NCColors.blue
    
    
    //Refresh Control
    refreshControl.addTarget(self, action: #selector(refreshControlDragged), for: .valueChanged)
    
  }
  
  private func setupConstraints(){
    guard let tableView = self.tableView else { return }
    tableView.edgesToSuperview()
  }
  
  
  
  
  private func loadArticles(){
    guard let referenceTitle = self.referenceTitle else {
      Dlog("No Reference")
      return
    }
    
    self.isLastPage = false
    DispatchQueue.main.async {self.emptyView?.startAnimating()}
    
    //Data loading in global thread
    DispatchQueue.global(qos: .default).async {
      var articleRefrence = Firestore.firestore()
        .collection(DatabaseReference.ARTICLE_REF)
        .order(by: DatabaseReference.DATE_CREATED, descending: true)
        .limit(to: 6)
      
      if referenceTitle != NCCategories.popular.rawValue{
        articleRefrence = Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .whereField(DatabaseReference.ARTICLE_CATEGORY, isEqualTo: referenceTitle)
          .order(by: DatabaseReference.DATE_CREATED, descending: true)
          .limit(to: 6)
      }
      //Getting All Documents
      self.isLoading = true
      articleRefrence.getDocuments { (snapshot, error) in
          if let error = error {
            Dlog("Error : \(error.localizedDescription)")
            self.isLoading = false
            DispatchQueue.main.async {self.emptyView?.stopAnimating()}
            return
          }
          
          guard let snapshot = snapshot else {
            Dlog("\(referenceTitle) : No Data")
            self.isLoading = false
            DispatchQueue.main.async {self.emptyView?.stopAnimating()}
            return
          }
        
        //No results
        guard let lastSnapshot = snapshot.documents.last else {
          self.isLoading = false
          self.isLastPage = true
          self.emptyView?.stopAnimating()
          return
        }
        
        self.lastSnapshot = lastSnapshot
          
          self.articles.removeAll()
          
          for document in snapshot.documents{
            let data = document.data()
            do{
              let article =  try FirebaseDecoder().decode(NCArticle.self, from: data)
              self.articles.append(article)
            }catch{
              Dlog("\(error.localizedDescription)")
              self.isLoading = false
              DispatchQueue.main.async {self.emptyView?.stopAnimating()}
            }
          }
          //UIchange in main thread
          DispatchQueue.main.async {
            self.isLoading = false
            self.refreshControl.endRefreshing()
            self.tableView?.reloadData()
            self.emptyView?.stopAnimating()
          }
      }
    }
  }
  
  
  private func loadMoreArticle(){
    guard !isLastPage else {Dlog("Last Page"); return }
    guard !isLoading else {Dlog("Still Loading"); return }
    
      guard let referenceTitle = self.referenceTitle else {
        Dlog("No Reference")
        return
      }
      
      DispatchQueue.main.async {self.emptyView?.startAnimating()}
      
      guard let lastSnapshot = self.lastSnapshot else{ Dlog("No Last Snapshot"); return }
      
      //Loading in global thread global
      self.isLoading = true
      DispatchQueue.global(qos: .default).async {
        var articleReference = Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .order(by: DatabaseReference.DATE_CREATED, descending: true)
          .start(afterDocument: lastSnapshot)
          .limit(to: 6)
        
        if referenceTitle != NCCategories.popular.rawValue{
          articleReference = Firestore.firestore()
            .collection(DatabaseReference.ARTICLE_REF)
            .whereField(DatabaseReference.ARTICLE_CATEGORY, isEqualTo: referenceTitle)
            .order(by: DatabaseReference.DATE_CREATED, descending: true)
            .start(afterDocument: lastSnapshot).limit(to: 6)
        }
        //Getting All Documents
        articleReference.getDocuments { (snapshot, error) in
          if let error = error {
            self.isLoading = false
            Dlog("Error : \(error.localizedDescription)")
            return
          }
          
          guard let snapshot = snapshot else {
            self.isLoading = false
            Dlog("\(referenceTitle) : No Data")
            return
          }
          
          //No results
          guard let lastSnapshot = snapshot.documents.last else {
            self.isLoading = false
            self.isLastPage = true
            return
          }
          
          self.lastSnapshot = lastSnapshot
          
          for document in snapshot.documents{
            let data = document.data()
            do{
              let article =  try FirebaseDecoder().decode(NCArticle.self, from: data)
              self.articles.append(article)
            }catch{
              self.isLoading = false
              Dlog("\(error.localizedDescription)")
            }
          }
          //UIchange in main thread
          DispatchQueue.main.async {
            self.isLoading = false
            self.tableView?.reloadData()
          }
        }
      }
  }
  
  @objc private func refreshControlDragged(){
    loadArticles()
  }
}

//MARK: TableView delegate and datasource
extension NCSingleHomeView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.articles.count == 0{
      tableView.backgroundView?.isHidden = false
    }else{
      tableView.backgroundView?.isHidden = true
    }
   return self.articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? NCArticleCell{
      cell.selectionStyle = .none
      cell.article = articles[indexPath.row]
      cell.articleCellSingleHomeDelegate = self
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 142
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let startLoadingIndex = self.articles.count - LAST_COUNT
    if !isLoading, indexPath.row >= startLoadingIndex{
      loadMoreArticle()
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? NCArticleCell else {
      return
    }
    cell.removeObserverLike()
    cell.removeObserveDisLike()
  }
}

extension NCSingleHomeView : NCArticleCellToSingleHomeDelegate{
  func passArticleAndUser(article: NCArticle, user: NCUser) {
    homeViewDelegate?.cellWasTapped(article: article, user: user)
  }
}

