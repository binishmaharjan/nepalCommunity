//
//  NCPager+Menu.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/05.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit


extension NCPager : NCDatabaseWrite, NCDatabaseAccess{
  
  func showMenu(article: NCArticle){
    guard let user = NCSessionManager.shared.user else {return}
    let articleId = article.articleId
    
    let title = LOCALIZE("Menu")
    let sheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
    //Delete Menu
    let deleteMenu = UIAlertAction(title: LOCALIZE("Delete"), style: .default) { (_) in
      Dlog("Delete")
    }
    
    //Report Menu
    let reportMenu = UIAlertAction(title: LOCALIZE("Report"), style: .default) { (_) in
      NCPager.shared.showAlert(messsage: "Do You Really Want To Report", ok: {
        self.report(id: articleId, type: DatabaseReference.ARTICLE_REF, uid: user.uid, completion: { (error) in
          if let error = error{
            NCDropDownNotification.shared.showError(message: "Error: \(error.localizedDescription)")
            return
          }
          NCDropDownNotification.shared.showSuccess(message: "Reported Successfully")
        })
      })
    }
    
    //Cancel Menu
    let cancelMenu = UIAlertAction(title: LOCALIZE("Cancel"), style: .cancel, handler: nil)
    
    sheet.addAction(article.uid == user.uid ? deleteMenu : reportMenu)
    sheet.addAction(cancelMenu)
    present(viewController: sheet)
  }
}
