//
//  ArticleTopCell.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/07.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCArticleTopCell: UITableViewCell, NCDatabaseAccess {
  //Variables
  private var container: UIView?
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  private var nameLabel: UILabel?
  private var categoryBG: UIView?
  private var categoryLabel: UILabel?
  private var dateLabel: UILabel?
  private var titleLabel :UILabel?
  private var descriptionLabel: UILabel?
  private var articleImage: UIImageView?
  private var articleImageHeightConstraints:Constraint?
  private var articleImageHeight:CGFloat = 200
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
  private var cellBottomConstraints: Constraint?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //ImageDelagate: Cell To TableView
  var cellToTableViewDelegate : NCCellToTableViewDelegate?
  
  //Article
  var article: NCArticle?{
    didSet{
      if let article = article{
        let uid = article.uid
      }
      self.relayout()
    }
  }

  //User
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
    
    //Container
    let container = UIView()
    self.container = container
    container.backgroundColor = NCColors.white
    container.dropShadow(opacity: 0.1,radius: 2.0)
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
    menuIcon.image = UIImage(named: "icon_menu")
    
    //Title Label
    let titleLabel = UILabel()
    self.titleLabel = titleLabel
    titleLabel.text = LOCALIZE("Title")
    container.addSubview(titleLabel)
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.black
    titleLabel.numberOfLines = 0
    
    //Description
    let descriptionLabel = UILabel()
    self.descriptionLabel = descriptionLabel
    descriptionLabel.text = LOCALIZE("Description")
    container.addSubview(descriptionLabel)
    descriptionLabel.textColor = NCColors.blueBlack
    descriptionLabel.font = NCFont.normal(size: 14)
    descriptionLabel.numberOfLines = 0
    
    //Image
    let articleImage = UIImageView()
    self.articleImage = articleImage
    articleImage.image = UIImage(named: "51")
    articleImage.layer.borderWidth = 1
    articleImage.layer.borderColor = NCColors.darKGray.cgColor
    articleImage.layer.cornerRadius = 5
    articleImage.clipsToBounds = true
    container.addSubview(articleImage)
    articleImage.isUserInteractionEnabled = true
    articleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageWasTapped(_:))))
    articleImage.contentMode = .scaleAspectFill
    
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
    dislikeIcon.image = UIImage(named: "icon_dislike")
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
      let descriptionLabel = self.descriptionLabel,
      let articleImage = self.articleImage,
      let menuIcon = self.menuIcon else { return }
    
    container.topToSuperview(offset : 0)
    container.leftToSuperview(offset : 0)
    container.bottomToSuperview(offset : -4)
    container.rightToSuperview(offset : 0)
    
    userImageBG.topToSuperview(offset : 8)
    userImageBG.leftToSuperview(offset : 8)
    userImageBG.width(42)
    userImageBG.height(to: userImageBG, userImageBG.widthAnchor)
    userImage.edgesToSuperview()
    
    nameLabel.leftToRight(of: userImageBG, offset: 8)
    nameLabel.top(to: userImageBG)
    
    categoryBG.left(to: nameLabel)
    categoryBG.bottom(to: userImageBG)
    categoryBG.right(to: categoryLabel, offset: 8)
    categoryBG.topToBottom(of: nameLabel, offset: 5)
    categoryLabel.leftToSuperview(offset:8)
    categoryLabel.centerYToSuperview()
    
    menuIconBG.rightToSuperview(offset: -8)
    menuIconBG.centerY(to: nameLabel)
    menuIconBG.width(28)
    menuIcon.height(19)
    menuIcon.edgesToSuperview()
    
    titleLabel.leftToSuperview(offset : 8)
    titleLabel.rightToSuperview(offset : -8)
    titleLabel.topToBottom(of: userImageBG, offset: 8)
    
    descriptionLabel.left(to: titleLabel)
    descriptionLabel.right(to: titleLabel)
    descriptionLabel.topToBottom(of: titleLabel, offset: 8)
    
    articleImage.topToBottom(of: descriptionLabel, offset: 8)
    articleImage.left(to: descriptionLabel)
    articleImage.right(to: descriptionLabel)
    articleImageHeightConstraints =  articleImage.height(articleImageHeight)
    
    commentIconBG.leftToSuperview(offset: 8)
    commentIconBG.topToBottom(of: articleImage, offset: 6)
    commentIconBG.width(25)
    commentIconBG.height(to: commentIconBG, commentIconBG.widthAnchor)
    commentIcon.edgesToSuperview()
    
    commentLabel.centerY(to: commentIconBG)
    commentLabel.leftToRight(of: commentIconBG, offset: 6)
    
    seperatorOne.leftToRight(of: commentLabel, offset: 12)
    seperatorOne.height(15)
    seperatorOne.width(1)
    seperatorOne.centerY(to: commentIconBG)
    
    likeIconBG.leftToRight(of: seperatorOne, offset: 12)
    likeIconBG.top(to: commentIconBG)
    likeIconBG.width(25)
    likeIconBG.height(to: likeIconBG, likeIconBG.widthAnchor)
    likeIcon.edgesToSuperview()
    
    likeLabel.centerY(to: likeIconBG)
    likeLabel.leftToRight(of: likeIconBG, offset: 6)
    
    seperatorTwo.leftToRight(of: likeLabel, offset: 12)
    seperatorTwo.height(15)
    seperatorTwo.width(1)
    seperatorTwo.centerY(to: likeIconBG)
    
    dislikeIconBG.leftToRight(of: seperatorTwo, offset: 12)
    dislikeIconBG.top(to: commentIconBG)
    dislikeIconBG.width(25)
    dislikeIconBG.height(to: likeIconBG, likeIconBG.widthAnchor)
    dislikeIcon.edgesToSuperview()
    
    dislikeLabel.centerY(to: dislikeIconBG)
    dislikeLabel.leftToRight(of: dislikeIconBG, offset: 6)
    
    dislikeIconBG.bottomToSuperview(offset : -4)
    
  }
  
  
  private func relayout(){
    guard let article = self.article else {
      Dlog("NO ARTICLE")
      return}
    self.titleLabel?.text = article.articleTitle
    self.descriptionLabel?.text = article.articleDescription
    self.commentLabel?.text = String(article.commentCount)
    self.likeLabel?.text = String(article.likeCount)
    self.dislikeLabel?.text = String(article.dislikeCount)
    
    if article.hasImage == 0 {
      articleImageHeight = 0
      articleImageHeightConstraints?.constant = articleImageHeight
    }else{
      articleImageHeight = 200
      articleImageHeightConstraints?.constant = articleImageHeight
      DispatchQueue.global(qos: .default).async {
        self.articleImage?.sd_setImage(with: URL(string: article.imageUrl ), completed: { (image, error, _, _) in
          DispatchQueue.main.async {
            self.articleImage?.image = image
          }
        })
      }
    }

  }
  
}

//ImagePressed
extension NCArticleTopCell{
  @objc func imageWasTapped(_ sender : UITapGestureRecognizer){
    guard let articleImage = self.articleImage,
      let image = articleImage.image else {return}
    
    cellToTableViewDelegate?.passImageFromCellToTable(image: image)
  }
}
