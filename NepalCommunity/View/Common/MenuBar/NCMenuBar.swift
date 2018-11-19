//
//  NCMenuBar.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/15.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCMenuBar : UIView{
  
  //Collection View for the menus
  var collectionView : UICollectionView?
  
  //PageViewController
  var pageView: NCPageViewController?
  
  //CollectionView Cell
  typealias Cell = NCMenuCell
  let CELL_CLASS = Cell.self
  let CELL_ID = NSStringFromClass(Cell.self)
  
  //Items
  private var menus = ["Popular", "Recent","Latest","Trend"]
  
  //MenuBar
  private var menuBar: UIView?
  var menuBarLeftConstraints : Constraint?
  var menuBarX: CGFloat = 0.0 {
    didSet {
      menuBarLeftConstraints?.constant = menuBarX
    }
  }
  
  //MARK : Defaults
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: Setups
  private func setup(){
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.collectionView = collectionView
    collectionView.backgroundColor = NCColors.blue
    collectionView.register(CELL_CLASS, forCellWithReuseIdentifier: CELL_ID)
    collectionView.delegate = self
    collectionView.dataSource = self
    let selectedIndexPath = NSIndexPath(row: 0, section: 0)
    collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .bottom)
    self.addSubview(collectionView)
    
    let menuBar = UIView()
    self.menuBar = menuBar
    menuBar.backgroundColor = NCColors.white
    self.addSubview(menuBar)
  }
  
  private func setupConstraints(){
    guard let collectionView = self.collectionView,
      let menuBar = self.menuBar
      else { return }
    collectionView.edgesToSuperview()
    
    menuBarLeftConstraints =  menuBar.leftToSuperview()
    menuBar.bottomToSuperview()
    menuBar.height(4)
    menuBar.width(UIScreen.main.bounds.size.width / 4)
  }
}

//MARK: Datasource and delegate
extension NCMenuBar : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! NCMenuCell
    cell.title = menus[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width / 4, height: frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //Moving the menu Bar to selected item position
    let x = CGFloat(indexPath.item) * frame.width / 4
    menuBarLeftConstraints?.constant = x
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
      self.layoutIfNeeded()//Animate the change in constraints
    }, completion: nil)
    
    //Changing the view of the pageView Controller
    guard let pageView = self.pageView else { return }
    pageView.menuBarMenuWasPresssed(at: indexPath.row)
  }
  
}
