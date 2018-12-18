//
//  DetailView.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/06.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore

class NCDetailView : NCBaseView{

  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  
  //TableView
  private var tableView: UITableView?
  
  //Cells
  typealias Cell1 = NCArticleTopCell
  let CELL1_CLASS = Cell1.self
  let CELL1_ID = NSStringFromClass(Cell1.self)
  
  typealias Cell2 = NCCommentCell
  let CELL2_CLASS = Cell2.self
  let CELL2_ID = NSStringFromClass(Cell2.self)
  
  //Pull Down refresh control
  private let refreshControl = UIRefreshControl()
  private var commentFieldView : UIView?
  private var commentFieldBG : UIView?
  private var commentField : UITextView?
  private var commentBtn : NCImageButtonView?
  
  //Delegate
  var delegate: NCButtonDelegate?{
    didSet{
      backBtn?.delegate = delegate
    }
  }
  
  var imageDelegate : NCImageDelegate?
  //Article
  var article :NCArticle?{didSet{titleLbl?.text = article?.articleTitle}}
  var user: NCUser?{
    didSet{
      
    }
  }
  
  override func didInit() {
    super.didInit()
    self.backgroundColor = NCColors.white
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
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Title")
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
    
    let tableView = UITableView()
    self.tableView = tableView
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.register(CELL2_CLASS, forCellReuseIdentifier: CELL2_ID)
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    refreshControl.backgroundColor = NCColors.clear
    refreshControl.tintColor = NCColors.blue
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    
    refreshControl.addTarget(self, action: #selector(refreshControlDragged), for: .valueChanged)
    
    
    let commentFieldView = UIView()
    self.commentFieldView = commentFieldView
    commentFieldView.backgroundColor = NCColors.white
    self.addSubview(commentFieldView)
    
    let shadowLayer: CALayer = commentFieldView.layer
    shadowLayer.shadowColor = NCColors.black.cgColor
    shadowLayer.shadowOffset = CGSize(width: 0.0, height: -1.0)
    shadowLayer.shadowRadius = 1.0
    shadowLayer.shadowOpacity = 0.1
    
    let commentFieldBG = UIView()
    self.commentFieldBG = commentFieldBG
    commentFieldBG.backgroundColor = NCColors.gray
    commentFieldBG.layer.borderColor = NCColors.blue.cgColor
    commentFieldBG.layer.borderWidth = 1
    commentFieldBG.layer.cornerRadius = 5
    commentFieldView.addSubview(commentFieldBG)
    
    let commentField = UITextView()
    self.commentField = commentField
    commentFieldBG.addSubview(commentField)
    
    let commentBtn = NCImageButtonView()
    self.commentBtn = commentBtn
    commentBtn.image = UIImage(named: "icon_plus_comment")
    //commentBtn.buttonMargin = .zero
    commentFieldView.addSubview(commentBtn)
  }
  
  private func setupConstraints(){
    guard let tableView = self.tableView,
          let header = self.header,
          let backBtn = self.backBtn,
          let titleLbl = self.titleLbl,
          let commentFieldView = self.commentFieldView,
          let commentFieldBG = self.commentFieldBG,
          let commentField = self.commentField,
          let commentBtn = self.commentBtn
    else { return }
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
    tableView.leftToSuperview()
    tableView.rightToSuperview()
    tableView.topToBottom(of: header)
    tableView.bottomToTop(of: commentFieldView)
    
    commentFieldView.edgesToSuperview(excluding: .top)
    commentFieldView.height(44)
    
    commentFieldBG.edgesToSuperview(excluding: .right, insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4))
    commentFieldBG.rightToLeft(of: commentBtn, offset: -4)
    
    commentBtn.rightToSuperview(offset : -4)
    commentBtn.topToSuperview(offset : 4)
    commentBtn.bottomToSuperview(offset : -4)
    commentBtn.width(36)
    
    commentField.edgesToSuperview()
  }
  
  @objc private func refreshControlDragged(){
    refreshControl.endRefreshing()
  }
}

extension NCDetailView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0, let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for : indexPath)  as? Cell1 {
      cell.article = self.article
      cell.user = self.user
      cell.cellToTableViewDelegate = self
      cell.selectionStyle = .none
      return cell
    }
    
    if indexPath.row > 0, let cell = tableView.dequeueReusableCell(withIdentifier: CELL2_ID, for: indexPath) as? Cell2{
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? Cell1 else {
      return
    }
    cell.removeObserverLike()
    cell.removeObserveDisLike()
  }
}


//ImageDelegate
extension NCDetailView : NCCellToTableViewDelegate{
  func passImageFromCellToTable(image: UIImage) {
    imageDelegate?.imagePressed(image: image)
  }
}
