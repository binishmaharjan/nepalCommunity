//
//  NCSettingView.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/01.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import FirebaseAuth

class NCSettingView : NCBaseView{
  
  //MARK: Variables
  private weak var tableView : UITableView?
  
  private let menus : [String] = ["Edit Profile","Liked Articles","Disliked Articles","Privacy Policy","Terms of use","SignOut"]
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  
  var title : String = "" {didSet{self.titleLbl?.text = title}}
  
  typealias Cell1 = NCSettingCell
  let CELL1_CLASS = Cell1.self
  let CELL1_ID = NSStringFromClass(Cell1.self)
  
  
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  private func setup(){
    //Header
    let header = UIView()
    header.backgroundColor = NCColors.blue
    self.addSubview(header)
    self.header = header
    
    let backBtn = NCImageButtonView()
    backBtn.image = UIImage(named:"icon_back_white")
    header.addSubview(backBtn)
    self.backBtn = backBtn
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Title")
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
    
    let tableView = UITableView()
    self.tableView = tableView
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    tableView.dataSource = self
    self.addSubview(tableView)
    tableView.estimatedRowHeight = 100
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
  }
  
  private func setupConstraints(){
    guard let header = self.header,
      let backBtn = self.backBtn,
      let titleLbl = self.titleLbl,
      let tableView = self.tableView
      else {return}
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
    tableView.topToBottom(of: header)
    tableView.edgesToSuperview(excluding : .top)
  }
}

//Table view delegate
extension NCSettingView : UITableViewDataSource, UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menus.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? Cell1{
      cell.title = menus[indexPath.row]
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      Dlog(menus[indexPath.row])
    case 1:
       Dlog(menus[indexPath.row])
    case 2:
       Dlog(menus[indexPath.row])
    case 3:
       Dlog(menus[indexPath.row])
    case 4:
       Dlog(menus[indexPath.row])
    case 5:
      NCPager.shared.pop(animated: true) {
        let firebaseAuth = Auth.auth()
        do{
          try firebaseAuth.signOut()
        }catch{
          debugPrint("Error signing out \(error.localizedDescription)")
        }
      }
    default:
      return
    }
  }
}
