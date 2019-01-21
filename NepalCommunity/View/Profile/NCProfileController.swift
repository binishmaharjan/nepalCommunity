//
//  NCProfileController.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/18.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCProfileController : NCViewController{
  
  override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
  private var mainView : NCProfileView?
  
  override func didInit() {
    super.didInit()
    outsideSafeAreaTopViewTemp?.backgroundColor = NCColors.blue
    outsideSafeAreaBottomViewTemp?.backgroundColor = NCColors.white
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.setupConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    guard let mainView = self.mainView else {return}
    mainView.user = NCSessionManager.shared.user
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setup(){
    let mainView = NCProfileView()
    self.mainView = mainView
    mainView.cellDelegate = self
    mainView.buttonDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else {return}
    mainView.edgesToSuperview(usingSafeArea : true)
  }
  
}

//MARK :  Cell Delegate
extension NCProfileController : NCSingleHomeViewDelegate, NCDatabaseWrite{
  func cellWasTapped(article: NCArticle, user: NCUser) {
    let detailVc = NCDetailViewController()
    detailVc.article = article
    detailVc.hidesBottomBarWhenPushed = true
    detailVc.user = user
    self.navigationController?.pushViewController(detailVc, animated: true)
  }
  
  func menuButtonWasPressed(article: NCArticle) {
    guard let user = NCSessionManager.shared.user else { return }
    let articleId = article.articleId
    
    let menuAlert = UIAlertController(title: "Menu", message: "Select An Option", preferredStyle: .actionSheet)
    //Delete Option
    let deleteMenu = UIAlertAction(title: "Delete", style: .default) { (_) in
      Dlog("Delete")
    }
    
    //Report Option
    let reportMenu = UIAlertAction(title: "Report", style: .default) { (_) in
      
      let confirmationAlert = UIAlertController(title: "Report", message: "Do you really want to report", preferredStyle: .alert)
      
      let yesMenu = UIAlertAction(title: "Report", style: .default) { (_) in
        self.report(id: articleId, type: DatabaseReference.ARTICLE_REF, uid: user.uid, completion: { (error) in
          if let error = error {
            NCDropDownNotification.shared.showError(message: "Error : \(error.localizedDescription)")
            return
          }
          NCDropDownNotification.shared.showSuccess(message: "Reported Successfully")
        })
      }
      
      //Cancel Option
      let cancelMenu = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
      }
      
      confirmationAlert.addAction(yesMenu)
      confirmationAlert.addAction(cancelMenu)
      self.present(confirmationAlert, animated: true, completion: nil)
      
    }
    let cancelMenu = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
      Dlog("Cancel")
    }
    if article.uid == user.uid{
      menuAlert.addAction(deleteMenu)
    }else{
      menuAlert.addAction(reportMenu)
    }
    menuAlert.addAction(cancelMenu)
    self.present(menuAlert, animated: true, completion: nil)
  }  
}

//MARK: Button Delegate
extension NCProfileController : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.settingBtn{
      Dlog("Setting")
    }
  }
}
