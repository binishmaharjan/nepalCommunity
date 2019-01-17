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
extension NCDetailViewController{
  private func setupNotification(){
    self.tearDownNotification()
    NCNotificationManager.receive(keyboardWillHide: self, selector: #selector(keyboardWillHide(_:)))
    NCNotificationManager.receive(keyboardWillShow: self, selector: #selector(keyboardWilShow(_:)))
  }
  
  private func tearDownNotification(){
    NCNotificationManager.remove(self)
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
