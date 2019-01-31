//
//  UserProfileCell.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/28.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseFirestore

class NCUserProfileCell : UITableViewCell {
  private var container : UIView?
  private var userImageBG : UIView?
  private var userImage: UIImageView?
  private var nameLabel: UILabel?
  private var emailLabel : UILabel?
  private var followView : UIView?
  private var followLabel : UILabel?
  private var followCountLabel : UILabel?
  private var followingView : UIView?
  private var followingLabel : UILabel?
  private var followingCountLabel : UILabel?
  private var seperatorView : UIView?
  private var followBtnBG : UIView?
  private var followBtn : UIButton?
  private var FOLLOWBTN_HEIGHT : CGFloat = 30
  private var followBtnHeightConstraints : Constraint?
  
  private var isFollowed : Bool = false{
    didSet{
      followBtnBG?.layer.borderWidth = isFollowed ? 0 : 2
      followBtn?.setTitleColor(isFollowed ? NCColors.white : NCColors.blue, for: .normal)
      followBtnBG?.backgroundColor = isFollowed ? NCColors.blue : NCColors.white
      followBtn?.setTitle(isFollowed ? LOCALIZE("Following") : LOCALIZE("Follow"), for: .normal)
    }
  }
  
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
      self.checkFollow()
      self.relayout()
      self.observeFollower()
      self.observeFollowing()
      //if user is self
      if user?.uid == NCSessionManager.shared.user?.uid{
        followBtnHeightConstraints?.constant = 0
      }
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
    
    let followBtnBG = UIView()
    self.followBtnBG = followBtnBG
    followBtnBG.backgroundColor = NCColors.white
    followBtnBG.layer.cornerRadius = 5
    followBtnBG.layer.borderColor = NCColors.blue.cgColor
    followBtnBG.layer.borderWidth = 2
    followBtnBG.clipsToBounds = true
    container.addSubview(followBtnBG)
    
    let followBtn = UIButton()
    self.followBtn = followBtn
    followBtn.setTitle(LOCALIZE("Follow"), for: .normal)
    followBtn.setTitleColor(NCColors.blue, for: .normal)
    followBtn.titleLabel?.font = NCFont.bold(size: 14)
    followBtnBG.addSubview(followBtn)
    followBtn.addTarget(self, action: #selector(followBtnPressed), for: .touchUpInside)
    
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
      let followBtn = self.followBtn,
      let followBtnBG = self.followBtnBG,
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
    //Hiding the email....just too lazy too delete this
    emailLabel.height(0)
    
    followBtnBG.topToBottom(of: emailLabel, offset : 4)
    followBtnBG.width(150)
    followBtnHeightConstraints =  followBtnBG.height(FOLLOWBTN_HEIGHT)
    followBtnBG.centerXToSuperview()
    
    followBtn.edgesToSuperview()
    
    seperator.topToBottom(of: followBtn, offset:16)
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

//MARK : Check Follow
extension NCUserProfileCell : NCDatabaseAccess{
  private func checkFollow(){
    guard let otherUser = self.user,
      let myUser = NCSessionManager.shared.user
      else {return}
    
    self.checkFollow(uid: myUser.uid, ouid: otherUser.uid) { (isFollowed, error) in
      if let error = error {
        Dlog(error.localizedDescription)
        return
      }
      
      guard let isFollowed = isFollowed else {return}
      self.isFollowed = isFollowed
    }
  }
  
  private func followFunction(){
    guard let otherUser = self.user,
      let myUser = NCSessionManager.shared.user
      else {return}
    
    if !isFollowed{
      self.isFollowed = true
      cacheFollow.setObject(BoolWrapper(self.isFollowed), forKey: NSString(string: "\(otherUser.uid)"))
      //Writing following id to own database
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(myUser.uid)
          .collection(DatabaseReference.FOLLOWING)
          .document(otherUser.uid).setData([
            "uid" : "\(otherUser.uid)",
            "date_created" : NCDate.dateToString()
            ], completion: { (error) in
              if let error = error{
                DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
              }
          })
      }
      
      //Writing followed id to other user database
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(otherUser.uid)
          .collection(DatabaseReference.FOLLOWERS)
          .document(myUser.uid).setData([
            "uid" : "\(myUser.uid)",
            "date_created" : NCDate.dateToString()
            ], completion: { (error) in
              if let error = error{
                DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
              }
          })
      }
    }else{
      self.isFollowed = false
      cacheFollow.setObject(BoolWrapper(self.isFollowed), forKey: NSString(string: "\(otherUser.uid)"))
      
      //Adding in own following list
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(myUser.uid)
          .collection(DatabaseReference.FOLLOWING)
          .document(otherUser.uid).delete(completion: { (error) in
            if let error = error{
              DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
            }
          })
      }
      
      //Deleting user followers
      DispatchQueue.global(qos: .default).async {
        Firestore.firestore()
          .collection(DatabaseReference.USERS_REF)
          .document(otherUser.uid)
          .collection(DatabaseReference.FOLLOWERS)
          .document(myUser.uid).delete(completion: { (error) in
            if let error = error{
              DispatchQueue.main.async {Dlog("\(error.localizedDescription)")}
            }
          })
      }
    }
  }
  
  
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
extension NCUserProfileCell{
  @objc private func followBtnPressed(){
    self.followFunction()
  }
  
  @objc func followingAreaTapped(){
    guard let user = self.user else {return}
    NCPager.shared.showFollowingList(user: user)
  }
  
  @objc func followersAreaTapped(){
    guard let user = self.user else {return}
    NCPager.shared.showFollowerList(user: user)
  }
  
}

