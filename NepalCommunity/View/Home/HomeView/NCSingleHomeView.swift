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
  
  //Pull Down refresh control
  private let refreshControl = UIRefreshControl()
  
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
    
    DispatchQueue.main.async {
      self.emptyView?.startAnimating()
    }
    
    //Data loading in global thread
    DispatchQueue.global(qos: .default).async {
      Firestore.firestore().collection(DatabaseReference.ARTICLE_REF)
        .whereField(DatabaseReference.ARTICLE_CATEGORY, isEqualTo: referenceTitle)
        .order(by: DatabaseReference.DATE_CREATED, descending: true)
        .getDocuments { (snapshot, error) in
          if let error = error {
            Dlog("Error : \(error.localizedDescription)")
            DispatchQueue.main.async {
              self.emptyView?.startAnimating()
            }
            return
          }
          
          guard let snapshot = snapshot else {
            Dlog("\(referenceTitle) : No Data")
            DispatchQueue.main.async {
              self.emptyView?.startAnimating()
            }
            return
          }
          
          for document in snapshot.documents{
            let data = document.data()
            do{
              let article =  try FirebaseDecoder().decode(NCArticle.self, from: data)
              self.articles.append(article)
            }catch{
              Dlog("\(error.localizedDescription)")
              DispatchQueue.main.async {
                self.emptyView?.startAnimating()
              }
            }
          }
          //UIchange in main thread
          DispatchQueue.main.async {
            self.tableView?.reloadData()
            self.emptyView?.stopAnimating()
          }
      }
    }
  }
  
  @objc private func refreshControlDragged(){
    self.articles.removeAll()
    loadArticles()
    refreshControl.endRefreshing()
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
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 142
  }
 
}
