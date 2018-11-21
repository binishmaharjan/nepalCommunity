//
//  NCSingleHomeView.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/19.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class NCSingleHomeView : NCBaseView{
  
  //mainTableView
  private var tableView: UITableView?
  
  //TableView Cell
  typealias Cell = NCArticleCell
  let CELL_CLASS = Cell.self
  let CELL_ID = NSStringFromClass(Cell.self)
  
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  private func setup(){
    let tableView = UITableView()
    self.tableView = tableView
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL_CLASS, forCellReuseIdentifier: CELL_ID)
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    
  }
  
  private func setupConstraints(){
    guard let tableView = self.tableView else { return }
    tableView.edgesToSuperview()
  }
}

//MARK: TableView delegate and datasource
extension NCSingleHomeView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? NCArticleCell{
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 113
  }
  
  
  
}
