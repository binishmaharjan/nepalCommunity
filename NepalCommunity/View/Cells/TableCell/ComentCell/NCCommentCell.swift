//
//  NCCommentCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/07.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore

class NCCommentCell : UITableViewCell, NCDatabaseAccess{
  //Variables
  private var container: UIView?
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  private var nameLabel: UILabel?
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
  private var menuIconBG: UIView?
  private var menuIcon: NCImageButtonView?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var comment : NCComment?{
    didSet{
      self.checkLiked()
      self.checkDislike()
      self.observeLike()
      self.observeDislike()
      self.reloadDataWithComment()
    }
  }
  
  private var likeListener : ListenerRegistration?
  private var disLikeListener : ListenerRegistration?
  
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
  
  private func setup(){
    self.backgroundColor = NCColors.white
    
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
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byTruncatingTail
    titleLabel.adjustsFontSizeToFitWidth = false
    
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
  }
  
  private func setupConstraints(){
    guard let userImage = self.userImage,
      let userImageBG = self.userImageBG,
      let nameLabel = self.nameLabel,
      let titleLabel = self.titleLabel,
      let likeIconBG = self.likeIconBG,
      let likeIcon = self.likeIcon,
      let likeLabel = self.likeLabel,
      let dislikeIconBG = self.dislikeIconBG,
      let dislikeIcon = self.dislikeIcon,
      let dislikeLabel = self.dislikeLabel,
      let container = self.container,
      let menuIconBG = self.menuIconBG,
      let seperatorTwo = self.seperatorTwo,
      let menuIcon = self.menuIcon else { return }
    
    container.topToSuperview(offset : 4)
    container.leftToSuperview(offset : 8)
    container.bottomToSuperview(offset : -4)
    container.rightToSuperview(offset : -8)
    
    
    userImageBG.topToSuperview(offset : 8)
    userImageBG.leftToSuperview(offset : 8)
    userImageBG.width(32)
    userImageBG.height(to: userImageBG, userImageBG.widthAnchor)
    
    userImage.edgesToSuperview()
    
    nameLabel.top(to: userImageBG)
    nameLabel.leftToRight(of: userImageBG, offset : 8)
    nameLabel.rightToLeft(of: menuIconBG)
    
    dateLabel?.topToBottom(of: nameLabel,offset: 1)
    dateLabel?.leftToRight(of: userImage, offset: 8)
    
    menuIconBG.rightToSuperview(offset: -8)
    menuIconBG.centerY(to: nameLabel)
    menuIconBG.width(28)
    menuIconBG.height(19)
    
    menuIcon.edgesToSuperview()
    
    titleLabel.topToBottom(of: userImageBG, offset : 8)
    titleLabel.left(to: userImageBG)
    titleLabel.rightToSuperview(offset : -8)

    likeIconBG.left(to: userImageBG)
    likeIconBG.topToBottom(of: titleLabel, offset: 6)
    likeIconBG.height(25)
    
    likeIcon.topToSuperview()
    likeIcon.leftToSuperview()
    likeIcon.width(25)
    likeIcon.height(25)
    
    likeLabel.leftToRight(of: likeIcon, offset: 12)
    likeLabel.centerY(to: likeIconBG)
    likeLabel.width(30)
    likeLabel.height(to: likeIconBG)
    likeIconBG.right(to: likeLabel)
    
    seperatorTwo.leftToRight(of: likeLabel, offset: 12)
    seperatorTwo.centerY(to: likeIconBG)
    seperatorTwo.height(25)
    seperatorTwo.width(1)
    
    dislikeIconBG.leftToRight(of: seperatorTwo, offset: 12)
    dislikeIconBG.centerY(to: likeIconBG)
    dislikeIconBG.height(25)
    
    dislikeIcon.topToSuperview()
    dislikeIcon.leftToSuperview()
    dislikeIcon.width(25)
    dislikeIcon.height(25)
    
    dislikeLabel.leftToRight(of: dislikeIcon, offset: 12)
    dislikeLabel.centerY(to: likeIconBG)
    dislikeLabel.width(30)
    dislikeLabel.height(to: dislikeIconBG)
    
    dislikeIconBG.right(to: dislikeLabel)
    dislikeIconBG.bottomToSuperview(offset : -4)
  }
  
  private func reloadDataWithComment(){
    guard let comment = self.comment else {return}
    titleLabel?.text = comment.comment
    likeLabel?.text = String(comment.likeCount)
    dislikeLabel?.text = String(comment.dislikeCount)
    let date = comment.dateCreated.components(separatedBy: " ").first
    dateLabel?.text = date
    
    // Checking the cache user then downloading if not there
    if let savedUser = cacheUsers.object(forKey: NSString(string: "\(comment.uid)")) as? StructWrapper<NCUser>{
      let u = savedUser.value
      self.user = u
    }else{
      self.downloadUser(uid: comment.uid) { (user, error) in
        if let error = error{
          Dlog(error.localizedDescription)
          return
        }
        self.user = user
        cacheUsers.setObject(StructWrapper<NCUser>(user!), forKey: NSString(string: "\(comment.uid)"))
      }
    }
  }
}

extension NCCommentCell: NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    
    if view == self.likeIcon{
      self.likeFunction()
    }else if view == self.dislikeIcon{
      self.dislikeFunction()
    }else if view == self.menuIcon{
      guard let comment = self.comment,
        let user  = NCSessionManager.shared.user
        else {return}
      NCNotificationManager.post(menuButtonPressed: comment.commentId, type: DatabaseReference.COMMENT_REF, uid: user.uid, ouid: comment.uid)
    }
  }
  
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
    guard let comment = self.comment,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    
    if !isLiked{
      self.isLiked = true
      //Saving the cache and changing the ui
      cacheCommentLike.setObject(BoolWrapper(self.isLiked), forKey: NSString(string: "\(comment.commentId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(comment.articleId)
          .collection(DatabaseReference.COMMENT_REF)
          .document(comment.commentId)
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
      self.isLiked = false
      //Saving the cache and changing the ui
      cacheCommentLike.setObject(BoolWrapper(self.isLiked), forKey: NSString(string: "\(comment.commentId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(comment.articleId)
          .collection(DatabaseReference.COMMENT_REF)
          .document(comment.commentId)
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
    guard let comment  = self.comment,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    
    if !isDisliked{
      //Saving the cache and changing the ui
      self.isDisliked = true
      cacheCommentDislike.setObject(BoolWrapper(self.isDisliked), forKey: NSString(string: "\(comment.commentId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(comment.articleId)
          .collection(DatabaseReference.COMMENT_REF)
          .document(comment.commentId)
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
      cacheCommentDislike.setObject(BoolWrapper(self.isDisliked), forKey: NSString(string: "\(comment.commentId)"))
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.ARTICLE_REF)
          .document(comment.articleId)
          .collection(DatabaseReference.COMMENT_REF)
          .document(comment.commentId)
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
  
  private func checkLiked(){
    guard let comment = self.comment,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    self.checkedCommentLike(uid: uid, articleId: comment.articleId, commentId : comment.commentId) { (isLiked, error) in
      if let error = error{
        Dlog("\(error.localizedDescription)")
        return
      }
      
      guard let isLiked = isLiked else { return }
      self.isLiked = isLiked
    }
  }
  
  private func checkDislike(){
    guard let comment = self.comment,
      let user = NCSessionManager.shared.user else {return}
    let uid = user.uid
    self.checkedCommentDislike(uid: uid, articleId: comment.articleId, commentId : comment.commentId) { (isDisliked, error) in
      if let error = error{
        Dlog("\(error.localizedDescription)")
        return
      }
      
      guard let isDisliked = isDisliked else { return }
      self.isDisliked = isDisliked
    }
  }
  
  private func observeLike(){
    guard let comment = self.comment else {return}
    if likeListener != nil {self.removeObserverLike()}
    DispatchQueue.global(qos: .default).async {
      self.likeListener = Firestore.firestore()
        .collection(DatabaseReference.ARTICLE_REF)
        .document(comment.articleId)
        .collection(DatabaseReference.COMMENT_REF)
        .document(comment.commentId)
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
  
  private func observeDislike(){
    guard let comment = self.comment else {return}
    if disLikeListener != nil {self.removeObserveDisLike()}
    DispatchQueue.global(qos: .default).async {
      self.disLikeListener = Firestore.firestore()
        .collection(DatabaseReference.ARTICLE_REF)
        .document(comment.articleId)
        .collection(DatabaseReference.COMMENT_REF)
        .document(comment.commentId)
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
  
}
