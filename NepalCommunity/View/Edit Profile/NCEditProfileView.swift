//
//  NCEditProfileView.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/07.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

protocol NCEditProfileDelegate : NSObjectProtocol{
  func cameraIconPressed()
}

class NCEditProfileView : NCBaseView{
  //MARK: Variables
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  
  //Scroll View
  private var scrollView: UIScrollView?
  private var contentView: UIView?
  
  //Icon
  var iconView : UIImageView?
  var cameraIcon : NCImageButtonView?
  
  //Fields
  private var usernameTitle : UILabel?
  private var usernameFieldBG : UIView?
  var usernameField: UITextField?
  
  private var saveButtonBG: UIView?
  private var saveButton : UIButton?
  
  var isProfileChange : Bool = false{didSet{checkButtonState()}}
  private var isNameChange : Bool = false{didSet{checkButtonState()}}
  
  private var userName : String?{didSet{usernameField?.text = userName}}
  
  //Delegate
  var editDelegate : NCEditProfileDelegate?
  
  var title :String = ""{didSet{titleLbl?.text = title}}
  var shouldEnableSave : Bool = false{didSet{changeButtonState(state: shouldEnableSave)}}
  
  //Flag
  var isLoading : Bool = false
  
  
  //MARK: Overrides
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
    self.loadInitialData()
  }
  
  //MARK : Setup
  private func setup(){
    //Scroll View
    let scrollView = UIScrollView()
    self.scrollView = scrollView
    scrollView.bounces  = false
    self.addSubview(scrollView)
    
    let contentView = UIView()
    self.contentView = contentView
    scrollView.addSubview(contentView)
    
    let iconView = UIImageView()
    self.iconView = iconView
    contentView.addSubview(iconView)
    iconView.backgroundColor = NCColors.white
    iconView.image = UIImage(named: "50")
    iconView.contentMode = .scaleAspectFill
    iconView.layer.borderColor = NCColors.gray.cgColor
    iconView.layer.borderWidth = 5
    iconView.clipsToBounds = true
    
    let cameraIcon = NCImageButtonView()
    self.cameraIcon = cameraIcon
    cameraIcon.backgroundColor = NCColors.clear
    contentView.addSubview(cameraIcon)
    cameraIcon.image = UIImage(named: "icon_camera")
    cameraIcon.delegate = self
    cameraIcon.contentMode = .scaleAspectFit
    
    
    //Header
    let header = UIView()
    header.backgroundColor = NCColors.blue
    contentView.addSubview(header)
    self.header = header
    
    let backBtn = NCImageButtonView()
    backBtn.image = UIImage(named:"icon_back_white")
    header.addSubview(backBtn)
    backBtn.delegate = self
    self.backBtn = backBtn
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.textAlignment = .center
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    titleLbl?.adjustsFontSizeToFitWidth = false
    titleLbl?.lineBreakMode = .byTruncatingTail
    titleLbl?.numberOfLines = 1
    header.addSubview(titleLabel)
    
    //Username
    let usernameTitle = UILabel()
    self.usernameTitle = usernameTitle
    usernameTitle.font = NCFont.normal(size: 14)
    usernameTitle.textColor = NCColors.black
    usernameTitle.text = LOCALIZE("Username")
    contentView.addSubview(usernameTitle)
    
    let usernameFieldBG = UIView()
    self.usernameFieldBG = usernameFieldBG
    usernameFieldBG.backgroundColor = NCColors.white
    usernameFieldBG.layer.cornerRadius = 0
    contentView.addSubview(usernameFieldBG)
    
    let usernameField = UITextField()
    self.usernameField = usernameField
    usernameField.backgroundColor = NCColors.white
    usernameField.placeholder = LOCALIZE("Fullname")
    usernameField.font = NCFont.normal(size: 14)
    usernameFieldBG.layer.borderColor = NCColors.gray.cgColor
    usernameFieldBG.layer.borderWidth = 2
    usernameFieldBG.addSubview(usernameField)
    usernameField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    usernameField.delegate = self
    
    
    let saveButtonBG = UIView()
    self.saveButtonBG = saveButtonBG
    self.header?.addSubview(saveButtonBG)
    saveButtonBG.backgroundColor = NCColors.blue
    saveButtonBG.layer.borderWidth = 1
    saveButtonBG.layer.borderColor = NCColors.white.cgColor
    saveButtonBG.layer.cornerRadius = 5
    
    let saveButton = UIButton()
    self.saveButton = saveButton
    saveButton.setTitle("Save", for: .normal)
    saveButtonBG.addSubview(saveButton)
    saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    saveButton.titleLabel?.font = NCFont.bold(size: 12)
    shouldEnableSave = false
  }
  
  private func setupConstraints(){
    guard let header = self.header,
      let backBtn = self.backBtn,
      let titleLbl = self.titleLbl,
      let usernameFieldBG = self.usernameFieldBG,
      let usernameField = self.usernameField,
      let  usernameTitle = self.usernameTitle,
      let cameraIcon = self.cameraIcon,
      let iconView = self.iconView,
      let scrollView = self.scrollView,
      let contentView = self.contentView,
      let saveButton = self.saveButton,
      let saveButtonBG = self.saveButtonBG
      else {return}
    
    scrollView.edgesToSuperview()
    contentView.edgesToSuperview()
    contentView.width(to: scrollView)
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    saveButtonBG.rightToSuperview(offset : -BACK_C_X)
    saveButtonBG.centerYToSuperview()
    saveButtonBG.width(70)
    saveButtonBG.height(29)
    
    saveButton.edgesToSuperview()
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    titleLbl.centerInSuperview()
    
    iconView.topToBottom(of: header, offset: 16)
    iconView.centerXToSuperview()
    iconView.width(100)
    iconView.height(to:iconView, iconView.widthAnchor)
    iconView.layer.cornerRadius = 5.0
    
    cameraIcon.width(35)
    cameraIcon.height(to: cameraIcon, cameraIcon.widthAnchor)
    cameraIcon.right(to: iconView, offset : 35 / 4)
    cameraIcon.bottom(to: iconView, offset : 35 / 4)
    
    usernameTitle.topToBottom(of: iconView, offset: 36)
    usernameTitle.leftToSuperview(offset : 30)
    
    usernameFieldBG.topToBottom(of: usernameTitle, offset: 6)
    usernameFieldBG.leftToSuperview(offset : 30)
    usernameFieldBG.rightToSuperview(offset : -30)
    usernameFieldBG.height(44)
    
    usernameField.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    
    usernameFieldBG.bottom(to: contentView)
  }
}

//MARK : Load Initial Data
extension NCEditProfileView{
  private func loadInitialData(){
    guard let user = NCSessionManager.shared.user else {return}
    self.userName = user.username
    let iconURL = user.iconUrl
    self.iconView?.sd_setImage(with: URL(string: iconURL), completed: { (image, error, _, _) in
      self.iconView?.image = image
    })
  }
}

//MARK : Button Delegate
extension NCEditProfileView : NCButtonDelegate, NCDatabaseWrite, NCStorage{
  func buttonViewTapped(view: NCButtonView) {
    if view == self.backBtn{
      NCPager.shared.pop()
    }
    
    if view == self.cameraIcon{
      editDelegate?.cameraIconPressed()
    }
  }
  
  @objc private func saveButtonPressed(){
    guard let user = NCSessionManager.shared.user,
      let iconView = self.iconView,
      let image = iconView.image,
      let usernameField = self.usernameField,
      let username = usernameField.text,
      !isLoading
      else {return}
    
    isLoading = true
    NCActivityIndicator.shared.start(view: self)
    self.saveImageToStorage(image: image, userId: user.uid) { (url, error) in
      if let error = error{
        Dlog(error.localizedDescription)
        self.isLoading = false
        return
      }
      
      guard let url = url else {
        self.isLoading = false
        Dlog("No Url")
        return
      }
      
      self.editField(uid: user.uid, name: username, url: url, completion: { (newUser, error) in
        if let error = error{
          self.isLoading = false
          NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showError(message: error.localizedDescription)
          return
        }
        
        guard let newUser = newUser else {
          self.isLoading = false
          NCActivityIndicator.shared.stop()
          NCDropDownNotification.shared.showError(message: "Error")
          return
        }
        
        NCSessionManager.shared.user = newUser
        NCActivityIndicator.shared.stop()
        self.isLoading = false
        NCPager.shared.pop()
        NCDropDownNotification.shared.showSuccess(message: "Successful")
      })
    }
  }
  
  private func changeButtonState(state : Bool){
    guard let saveButton = self.saveButton,
      let saveButtonBG = self.saveButtonBG
      else {return}
    saveButton.isEnabled = state
    saveButton.setTitleColor(state ? NCColors.white : NCColors.white.withAlphaComponent(0.6), for: .normal)
    saveButtonBG.layer.borderColor = state ? NCColors.white.cgColor : NCColors.white.withAlphaComponent(0.6).cgColor
  }
  
  private func checkButtonState(){
    shouldEnableSave = (isProfileChange || isNameChange)
  }
}

//MARK: Text Field Delegate
extension NCEditProfileView : UITextFieldDelegate{
  
  @objc func textDidChange(_ textField : UITextField){
    guard let username =  self.userName else {return}
    if textField.text != username{
      self.isNameChange = true
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
