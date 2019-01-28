//
//  NCSearchView.swift
//  
//
//  Created by guest on 2019/01/22.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import CodableFirebase


protocol NCSearchDelegate : NSObjectProtocol{
  func cellWasTapped(user :NCUser)
}

class NCSearchView : NCBaseView{
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  
  private var searchArea : UIView?
  private var searchBG : UIView?
  private var searchIcon : UIImageView?
  private var searchTextField : UITextField?
  private var cancelBtn : UIButton?
  private var cancelBtnWidth : CGFloat = 0
  private var cancelBtnWidthConstraints : Constraint?
  
  private var tableView : UITableView?
  private let refreshControl = UIRefreshControl()
  
  var searchDelegate : NCSearchDelegate?
  
  typealias Cell1 = NCUserCell
  let CELL1_CLASS = Cell1.self
  let CELL1_ID = NSStringFromClass(Cell1.self)
  
  var users : [NCUser] = [NCUser]()
  
  
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
  }
  
  override func updateConstraints() {
    cancelBtnWidthConstraints?.constant = cancelBtnWidth
    super.updateConstraints()
  }
  
  
  private func setup(){
    self.backgroundColor = NCColors.white
    
    //Header
    let header = UIView()
    header.backgroundColor = NCColors.blue
    self.addSubview(header)
    self.header = header
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Search")
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
    
    let searchArea = UIView()
    self.addSubview(searchArea)
    searchArea.backgroundColor = NCColors.blue
    self.searchArea = searchArea
    
    let searchBG = UIView()
    self.searchBG = searchBG
    searchArea.addSubview(searchBG)
    searchBG.layer.borderWidth = 2
    searchBG.layer.borderColor = NCColors.white.cgColor
    
    let searchIcon = UIImageView()
    self.searchIcon = searchIcon
    searchIcon.contentMode = .scaleAspectFit
    searchIcon.image = UIImage(named: "icon_search_white")?.withRenderingMode(.alwaysOriginal)
    searchBG.addSubview(searchIcon)
    
    let searchTextField = UITextField()
    self.searchTextField = searchTextField
    searchBG.addSubview(searchTextField)
    searchTextField.attributedPlaceholder = NSAttributedString(string: LOCALIZE("Search"), attributes: [NSAttributedString.Key.foregroundColor: NCColors.white])
    searchTextField.textColor = NCColors.white
    searchTextField.delegate = self
    searchTextField.returnKeyType = .search
    searchTextField.font = NCFont.normal(size: 14)
    searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    
    let cancelBtn = UIButton()
    self.cancelBtn = cancelBtn
    cancelBtn.setTitle("Cancel", for: .normal)
    cancelBtn.tintColor = NCColors.white
    cancelBtn.addTarget(self, action: #selector(canceButtonPressed), for: .touchUpInside)
    searchArea.addSubview(cancelBtn)
    
    let tableView = UITableView()
    self.tableView = tableView
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CELL1_CLASS, forCellReuseIdentifier: CELL1_ID)
    tableView.separatorStyle = .none
    self.addSubview(tableView)
    refreshControl.backgroundColor = NCColors.clear
    refreshControl.tintColor = NCColors.blue
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    
    refreshControl.addTarget(self, action: #selector(refreshControlDragged), for: .valueChanged)
  }
  
  private func setupConstraints(){
    guard let header = self.header,
      let titleLbl = self.titleLbl,
      let searchArea = self.searchArea,
      let searchBG = self.searchBG,
      let searchIcon = self.searchIcon,
      let searchTextField = self.searchTextField,
      let cancelBtn = self.cancelBtn,
      let tableView = self.tableView
      else {return}
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    titleLbl.centerInSuperview()
    titleLbl.width(200)
    
    searchArea.topToBottom(of: header)
    searchArea.leftToSuperview()
    searchArea.rightToSuperview()
    searchArea.height(46)
    
    searchBG.topToSuperview(offset : 5)
    searchBG.bottomToSuperview(offset : -5)
    searchBG.leftToSuperview(offset : 16)
    searchBG.rightToLeft(of: cancelBtn)
    
    searchBG.setNeedsLayout()
    searchBG.layoutIfNeeded()
    
    cancelBtn.rightToSuperview(offset : -8)
    cancelBtnWidthConstraints = cancelBtn.width(cancelBtnWidth)
    cancelBtn.topToSuperview(offset : 5)
    cancelBtn.bottomToSuperview(offset :-5)
    
    searchBG.layer.cornerRadius = searchBG.bounds.height / 2
    
    searchIcon.leftToSuperview(offset : 16)
    searchIcon.centerYToSuperview()
    
    searchTextField.edgesToSuperview(excluding : .left)
    searchTextField.leftToRight(of: searchIcon, offset : 8)
    
    tableView.edgesToSuperview(excluding : .top)
    tableView.topToBottom(of: searchArea)
  }
  
  @objc private func refreshControlDragged(){
    Dlog("Refreshed")
    refreshControl.endRefreshing()
  }
  
  
  private func loadUser(searchText : String){
    Dlog(searchText)
    let searchRef = Firestore.firestore()
      .collection(DatabaseReference.USERS_REF)
    
    DispatchQueue.global(qos: .default).async {
      searchRef.getDocuments(completion: { (snapshot, error) in
        if let error = error  {
          Dlog("\(error.localizedDescription)")
          return
        }
        
        guard let snapshot = snapshot else {
          Dlog("No Snapshot")
          return
        }
        
        self.users.removeAll()
        
        for document in snapshot.documents{
          let data = document.data()
          do{
            let user = try FirebaseDecoder().decode(NCUser.self, from: data)
            
            let username = user.username
            
            if username.contains(searchText){
              self.users.append(user)
            }
          }catch{
            Dlog("\(error.localizedDescription)")
          }
        }
        
        DispatchQueue.main.async {
          self.tableView?.reloadData()
          self.refreshControl.endRefreshing()
        }
      })
    }
  }
  
}

//MARK : TextView Delegate
extension NCSearchView : UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    cancelBtnWidth = 80
    self.setNeedsUpdateConstraints()
    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    cancelBtnWidth = 0
    self.setNeedsUpdateConstraints()
    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    return true
  }
  
  @objc func textDidChange(_ textField : UITextField){
    guard let searchText = textField.text else {return}
    self.loadUser(searchText: searchText)
  }
  
  @objc func canceButtonPressed(){
    self.searchTextField?.text = ""
    self.users.removeAll()
    self.tableView?.reloadData()
    self.searchTextField?.resignFirstResponder()
  }
}

//MARK : TableView Delegate and Datasource
extension NCSearchView : UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CELL1_ID, for: indexPath) as? Cell1{
      cell.user = users[indexPath.row]
      cell.selectionStyle = .none
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchDelegate?.cellWasTapped(user: self.users[indexPath.row])
  }
}
