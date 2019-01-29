//
//  ArticleCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/19.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase

class NCArticleCell : UITableViewCell, NCDatabaseAccess{
  
  //Variables
  private var container: UIView?
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  private var nameLabel: UILabel?
  private var categoryBG: UIView?
  private var categoryLabel: UILabel?
  private var dateLabel: UILabel?
  private var titleLabel :UILabel?
  private var likeIconBG: UIView?
  private var likeIcon: NCImageButtonView?
  private var likeLabel: UILabel?
  private var seperatorOne: UIView?
  private var dislikeIconBG : UIView?
  private var dislikeIcon: NCImageButtonView?
  private var dislikeLabel: UILabel?
  private var seperatorTwo: UIView?
  private var commentIconBG : UIView?
  private var commentIcon : NCImageButtonView?
  private var commentLabel: UILabel?
  private var menuIconBG: UIView?
  private var menuIcon: NCImageButtonView?
  
  
  private var isLiked : Bool = false{
    didSet{
      self.setLikeImage()
    }
  }
  private var isDisliked : Bool = false{
    didSet{
     self.setDislikeImage()
    }
  }
  private var likeListener : ListenerRegistration?
  private var disLikeListener : ListenerRegistration?
  private var commentListener : ListenerRegistration?
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //Delegate
  var articleCellSingleHomeDelegate : NCArticleCellToSingleHomeDelegate?
  
  var article: NCArticle?{
    didSet{
      self.checkLiked()
      self.checkDislike()
      self.observeLike()
      self.observeDislike()
      self.observeComment()
      self.relayout()
    }
  }
  
  var user: NCUser?{
    didSet{
      self.nameLabel?.text = "\(user?.username ?? "")"
      DispatchQueue.global(qos: .default).async {
        self.userImage?.sd_setImage(with: URL(string: self.user?.iconUrl ?? ""), completed: { (image, error, _, _) in
          DispatchQueue.main.async {
            self.userImage?.image = image
          }
        })
      }
    }
  }
  
  private func setup(){
    self.backgroundColor = NCColors.white
    
    //Tap Gesture to the cell
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellWasTapped)))
    
    //Container
    let container = UIView()
    self.container = container
    container.backgroundColor = NCColors.white
    container.dropShadow(opacity: 0.3,offset: CGSize(width: 1, height: 1), radius: 2.0)
    container.layer.cornerRadius = 5
    container.layer.zPosition = 5
    self.addSubview(container)
    
    //User Image
    let userImageBG = UIView()
    self.userImageBG = userImageBG
    container.addSubview(userImageBG)
    userImageBG.layer.cornerRadius = 5.0
    userImageBG.dropShadow()
    
    let userImage = UIImageView()
    self.userImage = userImage
    userImageBG.addSubview(userImage)
    userImage.image = UIImage(named: "50")
    userImage.layer.cornerRadius = 5.0
    userImage.contentMode = .scaleAspectFill
    userImage.clipsToBounds = true
    
    //NameLabel Label
    let nameLabel = UILabel()
    self.nameLabel = nameLabel
    nameLabel.text = LOCALIZE("Fullname" )
    nameLabel.textColor = NCColors.black
    nameLabel.font = NCFont.bold(size: 14)
    nameLabel.adjustsFontSizeToFitWidth = true
    container.addSubview(nameLabel)
    
    //Category Label
    let categoriesBG = UIView()
    self.categoryBG = categoriesBG
    container.addSubview(categoriesBG)
    categoriesBG.layer.borderWidth = 1.0
    categoriesBG.layer.cornerRadius = 5.0
    categoriesBG.layer.borderColor = NCColors.darKGray.cgColor
    
    let categoriesLbl = UILabel()
    self.categoryLabel = categoriesLbl
    categoriesLbl.text = LOCALIZE(NCCategories.food_travel.rawValue)
    categoriesLbl.textColor = NCColors.darKGray
    categoriesLbl.font = NCFont.bold(size: 12)
    categoriesBG.addSubview(categoriesLbl)
    
    let dateLabel = UILabel()
    self.dateLabel = dateLabel
    dateLabel.text = LOCALIZE(NCDate.dateToString())
    container.addSubview(dateLabel)
    dateLabel.font = NCFont.bold(size: 12)
    dateLabel.textColor = NCColors.darKGray
    
    //Menu Icon
    let menuIconBG = UIView()
    self.menuIconBG = menuIconBG
    container.addSubview(menuIconBG)
    
    let menuIcon = NCImageButtonView()
    self.menuIcon = menuIcon
    menuIconBG.addSubview(menuIcon)
    menuIcon.delegate = self
    menuIcon.image = UIImage(named: "icon_menu")
    
    //Title Label
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleLabel.text = LOCALIZE("What shoud i cook for dinner?pork or chicken with rice.")
    container.addSubview(titleLabel)
    titleLabel.font = NCFont.bold(size: 16)
    titleLabel.textColor = NCColors.black
    titleLabel.numberOfLines = 2
    titleLabel.lineBreakMode = .byTruncatingTail
    titleLabel.adjustsFontSizeToFitWidth = false
    
    //Comment Label
    let commentIconBG = UIView()
    self.commentIconBG = commentIconBG
    container.addSubview(commentIconBG)
    
    let commentIcon = NCImageButtonView()
    self.commentIcon = commentIcon
    commentIcon.image = UIImage(named: "icon_comment")
    commentIcon.buttonMargin = .zero
    commentIcon.delegate = self
    commentIconBG.addSubview(commentIcon)
    
    let commentLabel = UILabel()
    self.commentLabel = commentLabel
    commentLabel.text = LOCALIZE("127")
    commentLabel.textColor = NCColors.black
    commentLabel.font = NCFont.bold(size: 12)
    commentIconBG.addSubview(commentLabel)
    
    //Dislike Lablel
    let dislikeIconBG = UIView()
    self.dislikeIconBG = dislikeIconBG
    dislikeIconBG.isUserInteractionEnabled = true
    dislikeIconBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dislikeButtonPressed)))
    container.addSubview(dislikeIconBG)
    
    let dislikeIcon = NCImageButtonView()
    self.dislikeIcon = dislikeIcon
    dislikeIcon.buttonMargin = .zero
    dislikeIcon.image = UIImage(named: "icon_dislike")
    dislikeIcon.delegate = self
    dislikeIconBG.addSubview(dislikeIcon)
    
    let dislikeLabel = UILabel()
    self.dislikeLabel = dislikeLabel
    dislikeLabel.text = LOCALIZE("1.2K")
    dislikeLabel.textColor = NCColors.black
    dislikeLabel.font = NCFont.bold(size: 12)
    dislikeLabel.isUserInteractionEnabled = true
    dislikeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dislikeButtonPressed)))
    dislikeIconBG.addSubview(dislikeLabel)
    
    //Like Label
    let likeIconBG = UIView()
    self.likeIconBG = likeIconBG
    likeIconBG.isUserInteractionEnabled = true
    likeIconBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeButtonPressed)))
    container.addSubview(likeIconBG)
    
    let likeIcon = NCImageButtonView()
    self.likeIcon = likeIcon
    likeIcon.image = UIImage(named: "icon_like")
    likeIcon.buttonMargin = .zero
    likeIcon.delegate = self
    likeIconBG.addSubview(likeIcon)
    
    let likeLabel = UILabel()
    self.likeLabel = likeLabel
    likeLabel.text = LOCALIZE("5.6K")
    likeLabel.textColor = NCColors.black
    likeLabel.font = NCFont.bold(size: 12)
    likeLabel.isUserInteractionEnabled = true
    likeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeButtonPressed)))
    likeIconBG.addSubview(likeLabel)
    
    //Seperator
    let seperatorOne = UIView()
    self.seperatorOne = seperatorOne
    container.addSubview(seperatorOne)
    seperatorOne.backgroundColor = NCColors.orange
    
    let seperatorTwo = UIView()
    self.seperatorTwo = seperatorTwo
    container.addSubview(seperatorTwo)
    seperatorTwo.backgroundColor = NCColors.orange
    container.bottom(to: commentIcon, offset : 4)
    
  }
  
  private func setupConstraints(){
    guard let userImage = self.userImage,
      let userImageBG = self.userImageBG,
      let nameLabel = self.nameLabel,
      let categoryBG = self.categoryBG,
      let categoryLabel = self.categoryLabel,
      let titleLabel = self.titleLabel,
      let commentIconBG = self.commentIconBG,
      let commentIcon = self.commentIcon,
      let commentLabel = self.commentLabel,
      let likeIconBG = self.likeIconBG,
      let likeIcon = self.likeIcon,
      let likeLabel = self.likeLabel,
      let dislikeIconBG = self.dislikeIconBG,
      let dislikeIcon = self.dislikeIcon,
      let dislikeLabel = self.dislikeLabel,
      let container = self.container,
      let menuIconBG = self.menuIconBG,
      let seperatorOne = self.seperatorOne,
      let seperatorTwo = self.seperatorTwo,
      let menuIcon = self.menuIcon else { return }
    
    container.topToSuperview(offset : 4)
    container.leftToSuperview(offset : 8)
    container.bottomToSuperview(offset : -4)
    container.rightToSuperview(offset : -8)
    
    
    userImageBG.topToSuperview(offset : 8)
    userImageBG.leftToSuperview(offset : 8)
    userImageBG.width(42)
    userImageBG.height(to: userImageBG, userImageBG.widthAnchor)
    
    userImage.edgesToSuperview()
    
    nameLabel.top(to: userImageBG)
    nameLabel.leftToRight(of: userImageBG, offset : 8)
    nameLabel.rightToLeft(of: menuIconBG)
    
    categoryBG.left(to: nameLabel)
    categoryBG.bottom(to: userImageBG)
    categoryBG.right(to: categoryLabel, offset: 8)
    categoryBG.topToBottom(of: nameLabel, offset: 5)
    
    categoryLabel.leftToSuperview(offset:8)
    categoryLabel.centerYToSuperview()
    
    menuIconBG.rightToSuperview(offset: -8)
    menuIconBG.centerY(to: nameLabel)
    menuIconBG.width(28)
    menuIconBG.height(19)
    
    menuIcon.edgesToSuperview()
    
    titleLabel.topToBottom(of: userImageBG, offset : 8)
    titleLabel.left(to: userImageBG)
    titleLabel.height(40)
    titleLabel.rightToSuperview(offset : -8)
    
    commentIconBG.left(to: userImageBG)
    commentIconBG.topToBottom(of: titleLabel, offset: 6)
    commentIconBG.height(25)
    
    commentIcon.topToSuperview()
    commentIcon.leftToSuperview()
    commentIcon.width(25)
    commentIcon.height(25)
    
    commentLabel.leftToRight(of: commentIcon, offset: 12)
    commentLabel.centerY(to: commentIconBG)
    commentLabel.width(30)
    commentLabel.height(to: commentIconBG)
    commentIconBG.right(to: commentLabel)
    
    seperatorOne.leftToRight(of: commentLabel, offset: 12)
    seperatorOne.centerY(to: commentIconBG)
    seperatorOne.height(15)
    seperatorOne.width(1)
    
    likeIconBG.leftToRight(of: seperatorOne, offset: 12)
    likeIconBG.centerY(to: commentIconBG)
    likeIconBG.height(25)
    
    likeIcon.topToSuperview()
    likeIcon.leftToSuperview()
    likeIcon.width(25)
    likeIcon.height(25)
    
    likeLabel.leftToRight(of: likeIcon, offset: 12)
    likeLabel.centerY(to: commentIconBG)
    likeLabel.width(30)
    likeLabel.height(to: likeIconBG)
    likeIconBG.right(to: likeLabel)
    
    seperatorTwo.leftToRight(of: likeLabel, offset: 12)
    seperatorTwo.centerY(to: commentIconBG)
    seperatorTwo.height(25)
    seperatorTwo.width(1)
    
    dislikeIconBG.leftToRight(of: seperatorTwo, offset: 12)
    dislikeIconBG.centerY(to: commentIconBG)
    dislikeIconBG.height(25)
    
    dislikeIcon.topToSuperview()
    dislikeIcon.leftToSuperview()
    dislikeIcon.width(25)
    dislikeIcon.height(25)
    
    dislikeLabel.leftToRight(of: dislikeIcon, offset: 12)
    dislikeLabel.centerY(to: commentIconBG)
    dislikeLabel.width(30)
    dislikeLabel.height(to: dislikeIconBG)
    
    dislikeIconBG.right(to: dislikeLabel)
  }
  
  
  private func relayout(){
    guard let article = self.article else {
      Dlog("Error: Article Error")
      return
    }
    self.titleLabel?.text = article.articleTitle
    self.commentLabel?.text = String(article.commentCount)
    self.likeLabel?.text = String(article.likeCount)
    self.dislikeLabel?.text = String(article.dislikeCount)
    self.categoryLabel?.text = article.articleCategory
    
    // Checking the cache user then downloading if not there
    if let savedUser = cacheUsers.object(forKey: NSString(string: "\(article.uid)")) as? StructWrapper<NCUser>{
      let u = savedUser.value
      self.user = u
    }else{
      self.downloadUser(uid: article.uid) { (user, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        self.user = user
        cacheUsers.setObject(StructWrapper<NCUser>(user!), forKey: NSString(string: "\(article.uid)"))
      }
    }
  }
}

extension NCArticleCell{
  @objc private func cellWasTapped(){
    guard let article = self.article,
      let user = self.user
      else { return}
    articleCellSingleHomeDelegate?.passArticleAndUser(article: article, user: user)
  }
}

//MARK: Likes and Dislikes
extension NCArticleCell : NCButtonDelegate{
  @objc private func likeButtonPressed(){
    self.likeFunction()
  }
  
  @objc private func dislikeButtonPressed(){
    self.dislikeFunction()
  }
  
  private func setLikeImage(){
    self.likeIcon?.image = self.isLiked ? UIImage(named: "icon_like_h") : UIImage(named: "icon_like")
  }
  
  private func setDislikeImage(){
    self.dislikeIcon?.image = self.isDisliked ? UIImage(named: "icon_dislike_h") : UIImage(named: "icon_dislike")
  }
  
  private func likeFunction(){
    guard let article = self.article,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    
    if !isLiked{
      self.isLiked = true
      //Saving the cache and changing the ui
      cacheLike.setObject(BoolWrapper(self.isLiked), forKey: NSString(string: "\(article.articleId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(article.articleId)
          .collection(DatabaseReference.LIKE_ID_REF)
          .document(uid).setData(["uid" : "\(uid)"], completion: { (error) in
            if let error = error {
              DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
              return
            }
          })
      }
      //Removing the dislike since user liked this post
      if isDisliked{
        self.dislikeFunction()
      }
    }else{
      //Saving the cache and changing the ui
      self.isLiked = false
      cacheLike.setObject(BoolWrapper(self.isLiked), forKey: NSString(string: "\(article.articleId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(article.articleId)
          .collection(DatabaseReference.LIKE_ID_REF)
          .document(uid).delete(completion: { (error) in
            if let error = error {
              DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
              return
            }
          })
      }
    }
  }
  
  private func dislikeFunction(){
    guard let article  = self.article,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    
    if !isDisliked{
      //Saving the cache and changing the ui
      self.isDisliked = true
       cacheDislike.setObject(BoolWrapper(self.isDisliked), forKey: NSString(string: "\(article.articleId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(article.articleId)
          .collection(DatabaseReference.DISLIKE_ID_REF)
          .document(uid).setData(["uid" : "\(uid)"], completion: { (error) in
            if let error = error {
              DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
              return
            }
          })
      }
      //Removing the like since user disliked this post
      if isLiked{
        self.likeFunction()
      }
    }else{
      self.isDisliked = false
       cacheDislike.setObject(BoolWrapper(self.isDisliked), forKey: NSString(string: "\(article.articleId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(article.articleId)
          .collection(DatabaseReference.DISLIKE_ID_REF)
          .document(uid).delete(completion: { (error) in
            if let error = error {
              DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
              return
            }
          })
      }
    }
  }
  
  func buttonViewTapped(view: NCButtonView) {
    if view == self.menuIcon{
      self.menuButtonPressed()
    }else if view == self.dislikeIcon{
      self.dislikeFunction()
    }else if view == self.likeIcon{
      self.likeFunction()
    }
  }
  
  //MARK : Menu Button Pressed
  private func menuButtonPressed(){
    articleCellSingleHomeDelegate?.menuButtonWasPressed(article:article!)
  }
  
}

//Like Listener
extension NCArticleCell{
  
  private func checkLiked(){
    guard let article = self.article,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    self.checkedLike(uid: uid, articleId: article.articleId) { (isLiked, error) in
      if let error = error{
        Dlog("\(error.localizedDescription)")
        return
      }
      
      guard let isLiked = isLiked else { return }
      self.isLiked = isLiked
    }
  }
  
  private func checkDislike(){
    guard let article = self.article,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    self.checkedDislike(uid: uid, articleId: article.articleId) { (isDisliked, error) in
      if let error = error{
        Dlog("\(error.localizedDescription)")
        return
      }
      
      guard let isDisliked = isDisliked else {return}
      self.isDisliked = isDisliked
    }
  }
  
  func observeLike(){
    guard let article = self.article else {return}
    if likeListener != nil {self.removeObserverLike()}
    DispatchQueue.global(qos: .default).async {
      self.likeListener = Firestore.firestore()
        .collection(DatabaseReference.ARTICLE_REF)
        .document(article.articleId)
        .collection(DatabaseReference.LIKE_ID_REF)
        .addSnapshotListener({ (snapshotListerner, error) in
          if let error = error  {
            Dlog("\(error.localizedDescription)")
            return
          }
          
          guard let snapshot = snapshotListerner else{ return }
          let documents = snapshot.documents
          let documentCounts = documents.count
          
          DispatchQueue.main.async {
            self.likeLabel?.text = String(documentCounts)
            self.setLikeImage()
          }
        })
    }
  }
  
  func removeObserverLike(){
    guard  let likeListener = self.likeListener else {return}
    likeListener.remove()
  }
  
  func observeDislike(){
    guard let article = self.article else {return}
    if disLikeListener != nil {self.removeObserveDisLike()}
    DispatchQueue.global(qos: .default).async {
      self.disLikeListener = Firestore.firestore()
        .collection(DatabaseReference.ARTICLE_REF)
        .document(article.articleId)
        .collection(DatabaseReference.DISLIKE_ID_REF)
        .addSnapshotListener({ (snapshotListerner, error) in
          if let error = error{
            Dlog("\(error.localizedDescription)")
            return
          }
          
          guard let snapshot = snapshotListerner else {return}
          let documents = snapshot.documents
          let documentCounts = documents.count
          
          DispatchQueue.main.async {
            self.dislikeLabel?.text = String(documentCounts)
            self.setDislikeImage()
          }
        })
    }
    
  }
  
  func removeObserveDisLike(){
    guard let disLikeListener = self.disLikeListener else {return}
    disLikeListener.remove()
  }
  
  func observeComment(){
    guard let article = self.article else {return}
    if commentListener != nil{self.removeObserveComment()}
    DispatchQueue.global(qos: .default).async {
      self.commentListener = Firestore.firestore().collection(DatabaseReference.ARTICLE_REF).document(article.articleId).collection(DatabaseReference.COMMENT_REF).addSnapshotListener({ (snapshotListener, error) in
        if let error = error{
          Dlog("\(error.localizedDescription)")
          return
        }
        
        guard let snapshot = snapshotListener else {return}
        let documents = snapshot.documents
        let documentsCount = documents.count
        
        DispatchQueue.main.async {
          self.commentLabel?.text = String(documentsCount)
        }
      })
    }
  }
  
  func removeObserveComment(){
    guard let commentListener = self.commentListener else {return}
    commentListener.remove()
  }
}
