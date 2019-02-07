//
//  MQPager+push.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/30.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit

extension NCPager{
  
  func showFollowerList(user : NCUser){
    let vc = NCUserListController()
    vc.user = user
    vc.titleString = NCUserListType.follower
    push(viewController: vc)
  }
  
  func showFollowingList(user : NCUser){
    let vc = NCUserListController()
    vc.user = user
    vc.titleString = NCUserListType.following
    push(viewController: vc)
  }
  
  func showSettingPage(){
    let vc = NCSettingController()
    vc.titleString = LOCALIZE("Setting")
    push(viewController: vc)
  }
  
  func showLikedArticlePage(user : NCUser,title :NCArticleListType){
    let vc = NCArticleListController()
    vc.user = user
    vc.titleString = title
    push(viewController: vc)
  }
  
  func showDislikeArticlePage(user : NCUser, title : NCArticleListType){
    let vc = NCArticleListController()
    vc.user = user
    vc.titleString = title
    push(viewController: vc)
  }
  
  func showDetailPage(article : NCArticle, user : NCUser, shouldKeyBoardShowUp : Bool){
    let vc = NCDetailViewController()
    vc.article = article
    vc.user = user
    vc.hidesBottomBarWhenPushed = true
    vc.shouldKeyboardShowUp = shouldKeyBoardShowUp
    push(viewController: vc)
  }
  
  func showUserProfile(user : NCUser){
    let vc = NCUserProfileController()
    vc.user = user
    push(viewController: vc)
  }
  
  func showUserPage(user : NCUser){
    let vc = NCUserProfileController()
    vc.hidesBottomBarWhenPushed = true
    vc.user = user
    push(viewController: vc)
  }
}
