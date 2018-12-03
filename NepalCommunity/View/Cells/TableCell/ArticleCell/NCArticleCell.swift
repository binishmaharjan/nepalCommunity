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

class NCArticleCell : UITableViewCell{
  
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
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var article: NCArticle?{
    didSet{
      self.relayout()
    }
  }
  
  var user: NCUser?{
    didSet{
      self.nameLabel?.text = "\(user?.username ?? "")"
      userImage?.sd_setImage(with: URL(string: user?.iconUrl ?? ""), completed: { (image, error, _, _) in
        self.userImage?.image = image
      })
    }
  }
  
  private func setup(){
    //Container
    let container = UIView()
    self.container = container
    container.backgroundColor = NCColors.white
    container.dropShadow(opacity: 0.1,radius: 2.0)
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
    userImage.clipsToBounds = true
    
    //NameLabel Label
    let nameLabel = UILabel()
    self.nameLabel = nameLabel
    nameLabel.text = LOCALIZE("Maharjan Binish" )
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
    commentIconBG.addSubview(commentIcon)
    
    let commentLabel = UILabel()
    self.commentLabel = commentLabel
    commentLabel.text = LOCALIZE("127")
    commentLabel.textColor = NCColors.black
    commentLabel.font = NCFont.bold(size: 12)
    container.addSubview(commentLabel)
    
    //Dislike Lablel
    let dislikeIconBG = UIView()
    self.dislikeIconBG = dislikeIconBG
    container.addSubview(dislikeIconBG)
    
    let dislikeIcon = NCImageButtonView()
    self.dislikeIcon = dislikeIcon
    dislikeIcon.buttonMargin = .zero
    dislikeIcon.image = UIImage(named: "icon_dislike_h")
    dislikeIconBG.addSubview(dislikeIcon)
    
    let dislikeLabel = UILabel()
    self.dislikeLabel = dislikeLabel
    dislikeLabel.text = LOCALIZE("1.2K")
    dislikeLabel.textColor = NCColors.black
    dislikeLabel.font = NCFont.bold(size: 12)
    container.addSubview(dislikeLabel)
    
    //Like Label
    let likeIconBG = UIView()
    self.likeIconBG = likeIconBG
    container.addSubview(likeIconBG)
    
    let likeIcon = NCImageButtonView()
    self.likeIcon = likeIcon
    likeIcon.image = UIImage(named: "icon_like")
    likeIcon.buttonMargin = .zero
    likeIconBG.addSubview(likeIcon)
    
    let likeLabel = UILabel()
    self.likeLabel = likeLabel
    likeLabel.text = LOCALIZE("5.6K")
    likeLabel.textColor = NCColors.black
    likeLabel.font = NCFont.bold(size: 12)
    container.addSubview(likeLabel)
    
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
    
    container.topToSuperview(offset : 8)
    container.leftToSuperview(offset : 8)
    container.bottomToSuperview(offset : 0)
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
    titleLabel.rightToSuperview(offset : -8)
    
    commentIconBG.left(to: userImageBG)
    commentIconBG.topToBottom(of: titleLabel, offset: 6)
    commentIconBG.width(25)
    commentIconBG.height(25)
    
    commentIcon.edgesToSuperview()
    
    commentLabel.leftToRight(of: commentIconBG, offset: 12)
    commentLabel.centerY(to: commentIconBG)
    
    seperatorOne.leftToRight(of: commentLabel, offset: 12)
    seperatorOne.centerY(to: commentIconBG)
    seperatorOne.height(15)
    seperatorOne.width(1)
    
    likeIconBG.leftToRight(of: seperatorOne, offset: 12)
    likeIconBG.centerY(to: commentIconBG)
    likeIconBG.width(25)
    likeIconBG.height(25)
    
    likeIcon.edgesToSuperview()
    
    likeLabel.leftToRight(of: likeIconBG, offset: 12)
    likeLabel.centerY(to: commentIconBG)
    
    seperatorTwo.leftToRight(of: likeLabel, offset: 12)
    seperatorTwo.centerY(to: commentIconBG)
    seperatorTwo.height(15)
    seperatorTwo.width(1)
    
    dislikeIconBG.leftToRight(of: seperatorTwo, offset: 12)
    dislikeIconBG.centerY(to: commentIconBG)
    dislikeIconBG.width(25)
    dislikeIconBG.height(25)
    
    dislikeIcon.edgesToSuperview()
    
    dislikeLabel.leftToRight(of: dislikeIconBG, offset: 12)
    dislikeLabel.centerY(to: commentIconBG)
  }
  
  
  private func relayout(){
    guard let article = self.article else {
      Dlog("Error: Article Error")
      return
    }
    self.titleLabel?.text = article.articleTitle
    
    Firestore.firestore().collection(DatabaseReference.USERS_REF).whereField(DatabaseReference.USER_ID, isEqualTo: article.uid).getDocuments { (snapshot, error) in
      
      if let error = error {
        Dlog("\(error.localizedDescription)")
        return
      }
     
        let document = snapshot?.documents.first
        let data = document?.data()
      
      do{
        let user = try FirebaseDecoder().decode(NCUser.self, from: data)
        self.user = user
      }catch{
        Dlog(error.localizedDescription)
      }
      
    }
  }
  
  
}
