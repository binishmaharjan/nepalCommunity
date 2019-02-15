//
//  NCPager+Menu.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/05.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit


extension NCPager : NCDatabaseWrite, NCDatabaseAccess{
  
  //Menu For Aritcle
  func showMenu(article: NCArticle, index : Int,completion : ((Bool?)->())? = nil){
    guard let user = NCSessionManager.shared.user else {return}
    let articleId = article.articleId
    
    let title = LOCALIZE("Menu")
    let sheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
    //Delete Menu
    let deleteMenu = UIAlertAction(title: LOCALIZE("Delete"), style: .default) { (_) in
      Dlog("Delete Article : \(index)")
      NCPager.shared.showConfirm(messsage: "Do You Really Want To Delete This Article", ok: {
        self.deleteArticle(articleId: articleId, completion: { (error) in
          if let error = error{
            Dlog(error.localizedDescription)
            return
          }
          Dlog("Deleted")
        })
        completion?(true)
      }, cancel: nil)
    }
    
    //Report Menu
    let reportMenu = UIAlertAction(title: LOCALIZE("Report"), style: .default) { (_) in
      NCPager.shared.showConfirm(messsage: "Do You Really Want To Report", ok: {
        self.report(id: articleId, type: DatabaseReference.ARTICLE_REF, uid: user.uid, completion: { (error) in
          if let error = error{
            NCDropDownNotification.shared.showError(message: "Error: \(error.localizedDescription)")
            return
          }
          NCDropDownNotification.shared.showSuccess(message: "Reported Successfully")
        })
      }, cancel: nil)
    }
    
    //Cancel Menu
    let cancelMenu = UIAlertAction(title: LOCALIZE("Cancel"), style: .cancel, handler: nil)
    
    sheet.addAction(article.uid == user.uid ? deleteMenu : reportMenu)
    sheet.addAction(cancelMenu)
    present(viewController: sheet)
  }
  
  //Menu For the comment
  func showMenu(comment: NCComment, index : Int){
    guard let user = NCSessionManager.shared.user else {return}
    let commentId = comment.commentId
    let articleId = comment.articleId
    
    let title = LOCALIZE("Menu")
    let sheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
    //Delete Menu
    let deleteMenu = UIAlertAction(title: LOCALIZE("Delete"), style: .default) { (_) in
      NCPager.shared.showConfirm(messsage: "Do You Really Want To Delete This Comment", ok: {
        self.deleteComment(articleId: articleId, commentId: commentId, completion: { (error) in
          if let error = error{
           Dlog(error.localizedDescription)
            return
          }
          Dlog("Deleted")
        })
        NCNotificationManager.post(rowDeleted: index)
      }, cancel: nil)
    }
    
    //Report Menu
    let reportMenu = UIAlertAction(title: LOCALIZE("Report"), style: .default) { (_) in
      NCPager.shared.showConfirm(messsage: "Do You Really Want To Report", ok: {
        self.report(id: commentId, type: DatabaseReference.COMMENT_REF, uid: user.uid, completion: { (error) in
          if let error = error{
            NCDropDownNotification.shared.showError(message: error.localizedDescription)
            return
          }
          NCDropDownNotification.shared.showSuccess(message: "Reported Successfully")
        })
      }, cancel: nil)
    }
    
    //Cancel Menu
    let cancelMenu = UIAlertAction(title: LOCALIZE("Cancel"), style: .cancel, handler: nil)
    
    sheet.addAction(comment.uid == user.uid ? deleteMenu : reportMenu)
    sheet.addAction(cancelMenu)
    present(viewController: sheet)
  }
}
