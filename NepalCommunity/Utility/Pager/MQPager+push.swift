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
}
