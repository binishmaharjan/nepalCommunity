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
  
  //Article
  var article : NCArticle? {didSet{mainView?.article = article}}
  
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
  
  private func setup(){
    let mainView = NCDetailView()
    self.mainView = mainView
    mainView.delegate = self
    mainView.imageDelegate = self
    self.view.addSubview(mainView)
  }
  
  private func setupConstraints(){
    guard let mainView = self.mainView else { return }
    mainView.edgesToSuperview(usingSafeArea : true)
  }
}


extension NCDetailViewController : NCButtonDelegate{
  func buttonViewTapped(view: NCButtonView) {
    if view == mainView?.backBtn{
      self.navigationController?.popViewController(animated: true)
    }
  }
}

extension NCDetailViewController : NCImageDelegate{
  func imagePressed(image: UIImage) {
    let vc = NCFullImageController()
    vc.image = image
    self.present(vc, animated: true, completion: nil)
  }
}
