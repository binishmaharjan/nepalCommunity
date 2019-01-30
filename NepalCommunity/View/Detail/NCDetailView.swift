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
import CodableFirebase
import SDWebImage


protocol NCDetailViewDelegate {
  func userImageOrNameIsTapped(user : NCUser)
}

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
  
  typealias  Cell3 = NCTitleCell
  let CELL3_CLASS = Cell3.self
  let CELL3_ID = NSStringFromClass(Cell3.self)
  
  //Pull Down refresh control
  private let refreshControl = UIRefreshControl()
  private var commentFieldView : UIView?
  private var commentFieldBG : UIView?
  var commentField : GrowingTextView?
  private var commentBtn : NCImageButtonView?
  private var commentFieldHeight: Constraint?
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  
  //Delegate
  var delegate: NCButtonDelegate?{
    didSet{
      backBtn?.delegate = delegate
    }
  }
  
  var imageDelegate : NCImageDelegate?
  //Article
  var article :NCArticle?{
    didSet{
      titleLbl?.text = article?.articleTitle
      self.loadComments()
    }
  }
  
  var detailDelegate : NCDetailViewDelegate?
  var user: NCUser?
  
  //Comment
  var comments : [NCComment] = [NCComment]()
  
  override func didInit() {
    super.didInit()
    self.backgroundColor = NCColors.white
    self.setup()
    self.setupConstraints()
    self.loadComments()
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
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.register(CELL2_CLASS, forCellReuseIdentifier: CELL2_ID)
    tableView.register(CELL3_CLASS, forCellReuseIdentifier: CELL3_ID)
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    refreshControl.backgroundColor = NCColors.clear
    refreshControl.tintColor = NCColors.blue
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    
    refreshControl.addTarget(self, action: #selector(refreshControlDragged), for: .valueChanged)
    
    
    /*
     When creating the constraints for the growing view like this one
     size increases when the number of line is entered
     dont fix all four constraints or give the view height
     let the child constraints decide the height of the view
     if you fix the constraints then that would br priotized and the height wont
     increase in the desired way.x
     */
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
    
    let commentField = GrowingTextView()
    self.commentField = commentField
    commentFieldBG.addSubview(commentField)
    commentField.minHeight = 25.0
    commentField.maxHeight = 70.0
    commentField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    commentField.font = NCFont.normal(size: 14)
    
    
    let commentBtn = NCImageButtonView()
    self.commentBtn = commentBtn
    commentBtn.image = UIImage(named: "icon_plus_comment")
    commentBtn.delegate = self
    commentFieldView.addSubview(commentBtn)
    
    //User Image
    let userImageBG = UIView()
    self.userImageBG = userImageBG
    commentFieldView.addSubview(userImageBG)
    userImageBG.layer.cornerRadius = 5.0
    userImageBG.dropShadow(opacity : 0.3)
    
    let userImage = UIImageView()
    self.userImage = userImage
    userImageBG.addSubview(userImage)
    userImage.image = UIImage(named: "50")
    userImage.sd_setImage(with: URL(string: (NCSessionManager.shared.user?.iconUrl)!)) { (image, error, _, _) in
      userImage.image = image
    }
    userImage.layer.cornerRadius = 5.0
    userImage.contentMode = .scaleAspectFill
    userImage.clipsToBounds = true
  }
  
  private func setupConstraints(){
    guard let tableView = self.tableView,
          let header = self.header,
          let backBtn = self.backBtn,
          let titleLbl = self.titleLbl,
          let commentFieldView = self.commentFieldView,
          let commentFieldBG = self.commentFieldBG,
          let commentField = self.commentField,
          let commentBtn = self.commentBtn,
          let userImageBG = self.userImageBG,
          let userImage = self.userImage
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
    
    commentFieldView.leftToSuperview()
    commentFieldView.rightToSuperview()
    commentFieldView.bottomToSuperview()
//    commentFieldHeight = commentFieldView.height(44)
    
    userImageBG.leftToSuperview(offset : 8)
    userImageBG.bottomToSuperview(offset : -4)
    userImageBG.width(32)
    userImageBG.height(to: userImageBG,userImageBG.widthAnchor)
    
    userImage.edgesToSuperview()

    commentFieldBG.rightToLeft(of: commentBtn, offset: -4)
    commentFieldBG.topToSuperview(offset : 4)
    commentFieldBG.bottomToSuperview(offset : -4)
    commentFieldBG.leftToRight(of: userImageBG, offset: 8)
    
    commentBtn.rightToSuperview(offset : -4)
//    commentBtn.topToSuperview(offset : 4)
    commentBtn.bottomToSuperview(offset : -4)
    commentBtn.width(36)
    commentBtn.height(to: commentBtn,commentBtn.widthAnchor)
    
    commentField.edgesToSuperview()
  }
  
  @objc private func refreshControlDragged(){
    self.loadComments()
  }
}

extension NCDetailView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2 + comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0, let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for : indexPath)  as? Cell1 {
      cell.article = self.article
      cell.user = self.user
      cell.cellToTableViewDelegate = self
      cell.selectionStyle = .none
      return cell
    }
    
    if indexPath.row == 1, let cell = tableView.dequeueReusableCell(withIdentifier: CELL3_ID, for: indexPath) as? Cell3{
      cell.title = "Comments"
      cell.selectionStyle = .none
    return cell
    }
    
    if indexPath.row > 1, let cell = tableView.dequeueReusableCell(withIdentifier: CELL2_ID, for: indexPath) as? Cell2{
      cell.selectionStyle = .none
      cell.commentCellDelegate = self
      cell.comment =  comments[indexPath.row - 2]
      return cell
    }
    
    return UITableViewCell()
  }

  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? Cell1{
      cell.removeObserverLike()
      cell.removeObserveDisLike()
      cell.removeObserveComment()
    }
    
    if let cell = cell as? Cell2{
      cell.removeObserverLike()
      cell.removeObserveDisLike()
    }
   
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    commentField?.resignFirstResponder()
  }
}


//ImageDelegate
extension NCDetailView : NCCellToTableViewDelegate{
  func userImageOrNamePressed(user: NCUser) {
    detailDelegate?.userImageOrNameIsTapped(user: user)
  }
  
  func commentIconWasPressed() {
    self.commentField?.becomeFirstResponder()
  }
  
  func passImageFromCellToTable(image: UIImage) {
    imageDelegate?.imagePressed(image: image)
  }
}


//MARK: Comment Button
extension NCDetailView: NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    guard let commentTextField = self.commentField,
      let comment = commentTextField.text else {return}
    if comment.isEmpty{
     NCDropDownNotification.shared.showError(message: "Error")
    }else{
      self.uploadComment(comment: comment)
      commentTextField.resignFirstResponder()
      commentTextField.text = ""
    }
  }
}


//MARK: Text Field Delegate
extension NCDetailView: UITextViewDelegate{
}

//MARK: Upload comment to the server
extension NCDetailView : NCDatabaseWrite{
  
  private func uploadComment(comment : String){
    
    guard let article = self.article,
      let user = NCSessionManager.shared.user else {
        return
    }
    
    let commentId = randomID(length: 25)
    let articleId = article.articleId
    let userId = user.uid
    
    self.postComment(commentId: commentId, uid: userId, articleId: articleId, commentString: comment) { (error) in
      if let error = error{
        NCDropDownNotification.shared.showError(message: "Error")
        Dlog(error.localizedDescription)
        return
      }
      NCDropDownNotification.shared.showSuccess(message: "Comment Done")
    }
  }
  
  private func loadComments(){
    
    guard let article = self.article else {
      return
    }
    
    DispatchQueue.global(qos: .default).async {
      let commentRef = Firestore.firestore().collection(DatabaseReference.ARTICLE_REF)
        .document(article.articleId)
        .collection(DatabaseReference.COMMENT_REF)
        .order(by: DatabaseReference.DATE_CREATED, descending: true)
      
      commentRef.getDocuments { (snapshot, error) in
        if let error = error {
          Dlog(error.localizedDescription)
          self.refreshControl.endRefreshing()
          return
        }
        
        guard let snapshot = snapshot else {
          Dlog("No Data")
          self.refreshControl.endRefreshing()
          return
        }
        
        self.comments.removeAll()
        
        for document in snapshot.documents{
          let data = document.data()
          do{
            let article =  try FirebaseDecoder().decode(NCComment.self, from: data)
            self.comments.append(article)
          }catch{
            Dlog("\(error.localizedDescription)")
            self.refreshControl.endRefreshing()
          }
        }
        
        DispatchQueue.main.async {
          self.tableView?.reloadData()
          self.refreshControl.endRefreshing()
        }
        
      }
    }
  }
}

