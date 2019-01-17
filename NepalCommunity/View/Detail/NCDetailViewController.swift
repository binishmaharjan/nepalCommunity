//
//  DetailViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/06.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCDetailViewController: NCViewController{
  //MainView
  private var mainView : NCDetailView?
  private var mainViewBottomConstraints: Constraint?
  
  //Article
  var article : NCArticle? {didSet{mainView?.article = article}}
  var user: NCUser? {
    didSet{
      mainView?.user = user
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
  
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
    self.setupNotification()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.tearDownNotification()
  }
  
  private func setup(){
    let mainView = NCDetailView()
    self.mainView = mainView
    mainView.delegate = self
    mainView.imageDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.topToSuperview(usingSafeArea : true)
    mainView.leftToSuperview(usingSafeArea : true)
    mainView.rightToSuperview(usingSafeArea : true)
    mainViewBottomConstraints = mainView.bottomToSuperview(usingSafeArea : true)
  }
}

//MARK: Back Button
extension NCDetailViewController : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.backBtn{
      self.navigationController?.popViewController(animated: true)
    }
  }
}

//MARK: Full Image Detail
extension NCDetailViewController : NCImageDelegate{
  func imagePressed(image: UIImage) {
    let vc = NCImageDetailViewController()
    vc.image = image
    self.present(vc, animated: true, completion: nil)
  }
}

//MARK : KEyboard
extension NCDetailViewController : NCDatabaseWrite{
  private func setupNotification(){
    self.tearDownNotification()
    NCNotificationManager.receive(keyboardWillHide: self, selector: #selector(keyboardWillHide(_:)))
    NCNotificationManager.receive(keyboardWillShow: self, selector: #selector(keyboardWilShow(_:)))
    NCNotificationManager.receive(menuButtonPressed: self, selector: #selector(menuButtonPressed(_:)))
  }
  
  private func tearDownNotification(){
    NCNotificationManager.remove(self)
  }
  
  @objc func menuButtonPressed(_ notification : Notification){
    //Getting the important data form the notification
    if let userInfo = notification.object as? [AnyHashable : Any]{
      let id = userInfo["id"] as! String
      let type = userInfo["type"] as! String
      let uid = userInfo["uid"] as! String
      
      //Displaying the alert
      let menuAlert = UIAlertController(title: "Menu", message: "Select An Option", preferredStyle: .actionSheet)
      //Delete Option
      let deleteMenu = UIAlertAction(title: "Delete", style: .default) { (_) in
        Dlog("Delete")
      }
      
      //Report Option
      let reportMenu = UIAlertAction(title: "Report", style: .default) { (_) in
        
        let confirmationAlert = UIAlertController(title: "Report", message: "Do you really want to report", preferredStyle: .alert)
        
        let yesMenu = UIAlertAction(title: "Report", style: .default) { (_) in
          self.report(id: id, type: type, uid: uid, completion: { (error) in
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
      menuAlert.addAction(deleteMenu)
      menuAlert.addAction(reportMenu)
      menuAlert.addAction(cancelMenu)
      self.present(menuAlert, animated: true, completion: nil)
    }
  }
  
  @objc func keyboardWilShow(_ notification : Notification){
    guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let mainViewBottomConstraints = self.mainViewBottomConstraints else { return }
    
    let h = frame.height - self.view.safeAreaInsets.bottom
    mainViewBottomConstraints.constant = -h
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  @objc func keyboardWillHide(_ notification: Notification){
    guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let mainViewBottomConstraints = self.mainViewBottomConstraints else { return }
    
    let h:CGFloat = 0
    mainViewBottomConstraints.constant = h
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.view.layoutIfNeeded()
    })
  }
}
