//
//  NCProfileUserDetailCell.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/18.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore

class NCMyUserProfileCell : UITableViewCell{
  
  private var container : UIView?
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  private var nameLabel: UILabel?
  private var emailLabel : UILabel?
  private var followView : UIView?
  private var followLabel : UIView?
  private var followCountLabel : UILabel?
  private var followingView : UIView?
  private var followingLabel : UILabel?
  private var followingCountLabel : UILabel?
  private var seperatorView : UIView?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var user : NCUser?{
    didSet{
      self.relayout()
      self.observeFollowing()
      self.observeFollower()
    }
  }
  
  //Listener
  private var followerListener : ListenerRegistration?
  private var followingListener : ListenerRegistration?
  
  private func setup(){
    self.backgroundColor = NCColors.white
    
    //Container
    let container = UIView()
    self.container = container
    container.backgroundColor = NCColors.white
    container.dropShadow(opacity: 0.3,offset: CGSize(width: 1, height: 1), radius: 2.0)
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
    nameLabel.font = NCFont.bold(size: 18)
    nameLabel.textAlignment = .center
    nameLabel.adjustsFontSizeToFitWidth = true
    container.addSubview(nameLabel)
    
    //Email label
    let emailLabel = UILabel()
    self.emailLabel = emailLabel
    emailLabel.text = LOCALIZE("Email")
    emailLabel.textColor = NCColors.orange
    emailLabel.font = NCFont.normal(size: 14)
    emailLabel.textAlignment = .center
    emailLabel.adjustsFontSizeToFitWidth = true
    container.addSubview(emailLabel)
    
    let seperator = UIView()
    seperator.backgroundColor = NCColors.orange
    self.seperatorView = seperator
    container.addSubview(seperator)
    
    let followView = UIView()
    self.followView = followView
    container.addSubview(followView)
    followView.isUserInteractionEnabled = true
    followView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followersAreaTapped)))
    
    let followingView = UIView()
    self.followingView = followingView
    container.addSubview(followingView)
    followingView.isUserInteractionEnabled = true
    followingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingAreaTapped)))
    
    //Follow Label
    let followLabel = UILabel()
    self.followLabel = followLabel
    followLabel.text = LOCALIZE("Followers" )
    followLabel.textColor = NCColors.black
    followLabel.font = NCFont.bold(size: 18)
    followLabel.adjustsFontSizeToFitWidth = true
    followLabel.textAlignment = .center
    followView.addSubview(followLabel)
    
    //Follow Label
    let followCountLabel = UILabel()
    self.followCountLabel = followCountLabel
    followCountLabel.text = LOCALIZE("0" )
    followCountLabel.textColor = NCColors.black
    followCountLabel.font = NCFont.bold(size: 18)
    followCountLabel.adjustsFontSizeToFitWidth = true
    followCountLabel.textAlignment = .center
    followView.addSubview(followCountLabel)
    
    //Follow Label
    let followingLabel = UILabel()
    self.followingLabel = followingLabel
    followingLabel.text = LOCALIZE("Following" )
    followingLabel.textColor = NCColors.black
    followingLabel.font = NCFont.bold(size: 18)
    followingLabel.adjustsFontSizeToFitWidth = true
    followingLabel.textAlignment = .center
    followingView.addSubview(followingLabel)
    
    //Follow Label
    let followingCountLabel = UILabel()
    self.followingCountLabel = followingCountLabel
    followingCountLabel.text = LOCALIZE("0" )
    followingCountLabel.textColor = NCColors.black
    followingCountLabel.font = NCFont.bold(size: 18)
    followingCountLabel.adjustsFontSizeToFitWidth = true
    followingCountLabel.textAlignment = .center
    followingView.addSubview(followingCountLabel)
    
  }
  
  private func setupConstraints(){
    
    guard let container = self.container,
      let userImageBG = self.userImageBG,
      let userImage = self.userImage,
      let nameLabel = self.nameLabel,
      let emailLabel = self.emailLabel,
      let followView = self.followView,
      let followLabel = self.followLabel,
      let followCountLabel = self.followCountLabel,
      let followingView = self.followingView,
      let followingLabel = self.followingLabel,
      let followingCountLabel = self.followingCountLabel,
      let seperator = self.seperatorView else {return}
    
    container.topToSuperview(offset : 0)
    container.leftToSuperview(offset : 0)
    container.bottomToSuperview(offset : -8)
    container.rightToSuperview(offset : 0)
    
    userImageBG.topToSuperview(offset : 18)
    userImageBG.centerXToSuperview()
    userImageBG.width(96)
    userImage.height(to: userImage, userImage.widthAnchor)
    
    userImage.edgesToSuperview()
    
    nameLabel.topToBottom(of: userImageBG, offset: 8)
    nameLabel.leftToSuperview(offset : 8)
    nameLabel.rightToSuperview(offset : -8)
    
    emailLabel.topToBottom(of: nameLabel, offset : 2)
    emailLabel.leftToSuperview(offset : 8)
    emailLabel.rightToSuperview(offset : -8)
    
    seperator.topToBottom(of: emailLabel, offset:16)
    seperator.centerXToSuperview()
    seperator.width(2)
    seperator.height(45)
    
    followView.top(to: seperator)
    followView.bottom(to: seperator)
    followView.leftToSuperview(offset : 8)
    followView.rightToLeft(of: seperator, offset: -8)
    
    followCountLabel.topToSuperview()
    followCountLabel.leftToSuperview()
    followCountLabel.rightToSuperview()
    
    followLabel.topToBottom(of: followCountLabel)
    followLabel.leftToSuperview()
    followLabel.rightToSuperview()
    
    followingView.top(to: seperator)
    followingView.bottom(to: seperator)
    followingView.rightToSuperview(offset: -8)
    followingView.leftToRight(of: seperator, offset:  8)
    
    followingCountLabel.topToSuperview()
    followingCountLabel.leftToSuperview()
    followingCountLabel.rightToSuperview()
    
    followingLabel.topToBottom(of: followingCountLabel)
    followingLabel.leftToSuperview()
    followingLabel.rightToSuperview()
    
    container.bottom(to: seperator, offset : 8)

  }
  
  private func relayout(){
    guard let user = self.user
      else {return}
    
    nameLabel?.text = user.username
    emailLabel?.text = user.email
    userImage?.sd_setImage(with: URL(string: user.iconUrl), completed: { (image, error, _, _) in
      guard let _ = error else {return}
      self.userImage?.image = image
    })
  }
}

//MARK : Followers
extension NCMyUserProfileCell{
  private func observeFollower(){
    guard let user = self.user else {return}
    if followerListener != nil {self.removeObserveFollower()}
    DispatchQueue.global(qos: .default).async {
      self.followerListener = Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(user.uid)
        .collection(DatabaseReference.FOLLOWERS)
        .addSnapshotListener({ (snapshotListerner, error) in
          if let error = error{
            Dlog("\(error.localizedDescription)")
            return
          }
          
          guard let snapshot = snapshotListerner else {return}
          let documents = snapshot.documents
          let documentCounts = documents.count
          
          DispatchQueue.main.async {
            self.followCountLabel?.text = String(documentCounts)
          }
        })
    }
  }
  
  func removeObserveFollower(){
    guard let followerListener = self.followerListener else {return}
    followerListener.remove()
  }
  
  private func observeFollowing(){
    guard let user = self.user else {return}
    if followingListener != nil {self.removeObserveFollowing()}
    DispatchQueue.global(qos: .default).async {
      self.followerListener = Firestore.firestore()
        .collection(DatabaseReference.USERS_REF)
        .document(user.uid)
        .collection(DatabaseReference.FOLLOWING)
        .addSnapshotListener({ (snapshotListerner, error) in
          if let error = error{
            Dlog("\(error.localizedDescription)")
            return
          }
          
          guard let snapshot = snapshotListerner else {return}
          let documents = snapshot.documents
          let documentCounts = documents.count
          
          DispatchQueue.main.async {
            self.followingCountLabel?.text = String(documentCounts)
          }
        })
    }
  }
  
  func removeObserveFollowing(){
    guard let followerListener = self.followerListener else {return}
    followerListener.remove()
  }
}

//MARK : Following & Followers Pressed
extension NCMyUserProfileCell{
  @objc func followingAreaTapped(){
    guard let user = self.user else {return}
    NCPager.shared.showFollowingList(user: user)
  }
  
  @objc func followersAreaTapped(){
    guard let user = self.user else {return}
    NCPager.shared.showFollowerList(user: user)
  }
}
