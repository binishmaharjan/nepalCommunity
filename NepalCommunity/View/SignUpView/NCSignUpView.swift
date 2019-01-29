//
//  NCSignUpView.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/29.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints

class NCSignUpView : NCBaseView{
  
  //MARK: Fields
  private var scrollView: UIScrollView?
  private var contentView: UIView?
  
  //MARK: Delegate
  var delegate: NCButtonDelegate?{
    didSet{
      backBtn?.delegate = delegate
      signUpBtn?.delegate = delegate
      cameraIcon?.delegate = delegate
    }
  }
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  
  //Icon
  var iconView : UIImageView?
  var cameraIcon : NCImageButtonView?
  
  //Fields
  private var usernameTitle : UILabel?
  private var usernameFieldBG : UIView?
  var usernameField: UITextField?
  private var passwordTitle: UILabel?
  private var passwordFieldBG: UIView?
  var passwordField: UITextField?
  private var emailTitle :UILabel?
  private var emailFieldBG : UIView?
  var emailField :UITextField?
  private weak var signUpBtnBG :NCGradientView?
  weak var signUpBtn: NCTextButton?
  private var hideBtnBG : UIView?
  private var hideBtn : UIButton?
  private var isPasswordHidden : Bool = true
  
  
  //MARK: Methods
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  private func setup(){
    
    //Setting Tap Gesture
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    
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
    cameraIcon.contentMode = .scaleAspectFit
    
    
    //Header
    let header = UIView()
    header.backgroundColor = NCColors.clear
    contentView.addSubview(header)
    self.header = header
    
    let backBtn = NCImageButtonView()
    backBtn.image = UIImage(named:"icon_back")
    header.addSubview(backBtn)
    self.backBtn = backBtn
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Sign Up")
    titleLabel.font = NCFont.normal(size: 18)
    titleLabel.textColor = NCColors.blue
    header.addSubview(titleLabel)
    
    
    //Username
    let usernameTitle = UILabel()
    self.usernameTitle = usernameTitle
    usernameTitle.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    usernameTitle.textColor = NCColors.black
    usernameTitle.text = LOCALIZE("Your fullname")
    contentView.addSubview(usernameTitle)
    
    let usernameFieldBG = UIView()
    self.usernameFieldBG = usernameFieldBG
    usernameFieldBG.backgroundColor = NCColors.white
    usernameFieldBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS_ZERO
    contentView.addSubview(usernameFieldBG)
    
    let usernameField = UITextField()
    self.usernameField = usernameField
    usernameField.backgroundColor = NCColors.white
    usernameField.placeholder = LOCALIZE("Fullname")
    usernameField.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    usernameFieldBG.layer.borderColor = NCColors.gray.cgColor
    usernameFieldBG.layer.borderWidth = 2
    usernameFieldBG.addSubview(usernameField)
    usernameField.delegate = self
    
    //Password
    let passwordTitle = UILabel()
    self.passwordTitle = passwordTitle
    passwordTitle.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    passwordTitle.textColor = NCColors.black
    passwordTitle.text = LOCALIZE("Password")
    contentView.addSubview(passwordTitle)
    
    let passwordFieldBG = UIView()
    self.passwordFieldBG = passwordFieldBG
    passwordFieldBG.backgroundColor = NCColors.white
    passwordFieldBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS_ZERO
    passwordFieldBG.layer.borderColor = NCColors.gray.cgColor
    passwordFieldBG.layer.borderWidth = 2
    contentView.addSubview(passwordFieldBG)
    
    let passwordField = UITextField()
    self.passwordField = passwordField
    passwordField.backgroundColor = NCColors.white
    passwordField.placeholder = LOCALIZE("Password")
    passwordField.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    passwordFieldBG.addSubview(passwordField)
    passwordField.isSecureTextEntry = true
    passwordField.delegate = self
    
    let hideBtnBG = UIView()
    self.hideBtnBG = hideBtnBG
    passwordFieldBG.addSubview(hideBtnBG)
    
    let hideBtn = UIButton()
    self.hideBtn = hideBtn
    hideBtn.setImage(UIImage(named: "icon_hidden"), for: .normal)
    hideBtnBG.addSubview(hideBtn)
    hideBtn.addTarget(self, action: #selector(hideFunction), for: .touchUpInside)
    
    //Email
    let emailTitle = UILabel()
    self.emailTitle = emailTitle
    emailTitle.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    emailTitle.textColor = NCColors.black
    emailTitle.text = LOCALIZE("Your email address")
    contentView.addSubview(emailTitle)
    
    let emailFieldBG = UIView()
    self.emailFieldBG = emailFieldBG
    emailFieldBG.backgroundColor = NCColors.white
    emailFieldBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS_ZERO
    emailFieldBG.layer.borderColor = NCColors.gray.cgColor
    emailFieldBG.layer.borderWidth = 2
    contentView.addSubview(emailFieldBG)
    
    let emailField = UITextField()
    self.emailField = emailField
    emailField.backgroundColor = NCColors.white
    emailField.placeholder = LOCALIZE("Email")
    emailField.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    emailFieldBG.addSubview(emailField)
    emailField.delegate = self
    
    //SignIn Button
    let signUpBtnBG = NCGradientView(
      colors: [NCColors.blue.cgColor, NCColors.blue.cgColor],
      cornerRadius: SignUpConstants.CORNER_RADIUS_ZERO,
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x:1, y:0)
    )
    self.signUpBtnBG = signUpBtnBG
    signUpBtnBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS_ZERO
    signUpBtnBG.dropShadow()
    contentView.addSubview(signUpBtnBG)
    
    let signUpBtn = NCTextButton()
    self.signUpBtn = signUpBtn
    signUpBtn.backgroundColor = NCColors.clear
    signUpBtn.text = LOCALIZE("SIGN UP")
    signUpBtn.font = NCFont.bold(size: SignUpConstants.FONT_SIZE)
    signUpBtn.textColor = NCColors.white
    signUpBtnBG.addSubview(signUpBtn)
  }
  
  private func setupConstraints(){
    guard let passwordFieldBG = self.passwordFieldBG,
      let passwordTitle = self.passwordTitle,
      let passwordField = self.passwordField,
      let usernameFieldBG = self.usernameFieldBG,
      let usernameField = self.usernameField,
      let  usernameTitle = self.usernameTitle,
      let signUpBtnBg = self.signUpBtnBG,
      let signUpBtn = self.signUpBtn,
      let emailFieldBG = self.emailFieldBG,
      let emailTitle = self.emailTitle,
      let emailField  = self.emailField,
      let scrollView = self.scrollView,
      let contentView = self.contentView,
      let header = self.header,
      let titleLbl = self.titleLbl,
      let backBtn = self.backBtn,
      let iconView = self.iconView,
      let hideBtnBG = self.hideBtnBG,
      let hideBtn = self.hideBtn,
      let cameraIcon = self.cameraIcon  else { return }
    
    //Height of the contentView is decided by the bottom view i.e signupbtn
    scrollView.edgesToSuperview()
    contentView.edgesToSuperview()
    contentView.width(to: scrollView)
    //In this method the height of the content view is decided by the bottom signupBottom
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    titleLbl.centerInSuperview()
    
    iconView.topToBottom(of: header, offset: 16)
    iconView.centerXToSuperview()
    iconView.width(SignUpConstants.ICON_WIDTH)
    iconView.height(to:iconView, iconView.widthAnchor)
    iconView.layer.cornerRadius = 5.0
    
    cameraIcon.width(SignUpConstants.CAMERA_ICON_WIDTH)
    cameraIcon.height(to: cameraIcon, cameraIcon.widthAnchor)
    cameraIcon.right(to: iconView, offset : SignUpConstants.CAMERA_ICON_WIDTH / 4)
    cameraIcon.bottom(to: iconView, offset : SignUpConstants.CAMERA_ICON_WIDTH / 4)
    
    usernameTitle.topToBottom(of: iconView, offset: SignUpConstants.TOP_GRADIENT_BOTTOM_OFF)
    usernameTitle.leftToSuperview(offset : SignUpConstants.SIDE_OFF)
    
    usernameFieldBG.topToBottom(of: usernameTitle, offset: 6)
    usernameFieldBG.leftToSuperview(offset : SignUpConstants.SIDE_OFF)
    usernameFieldBG.rightToSuperview(offset : -SignUpConstants.SIDE_OFF)
    usernameFieldBG.height(SignUpConstants.FIELD_HEIGHT)
    
    usernameField.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    
    
    passwordTitle.topToBottom(of: usernameFieldBG, offset: SignUpConstants.FIELD_TOP_OFF)
    passwordTitle.leftToSuperview(offset : SignUpConstants.SIDE_OFF)
    
    passwordFieldBG.topToBottom(of: passwordTitle, offset: 6)
    passwordFieldBG.left(to: usernameFieldBG)
    passwordFieldBG.right(to: usernameFieldBG)
    passwordFieldBG.height(to: usernameFieldBG)
    
    passwordField.edgesToSuperview(excluding : .right ,insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    passwordField.rightToLeft(of: hideBtnBG)
    
    hideBtnBG.edgesToSuperview(excluding: .left,insets: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 2))
    hideBtnBG.width(SignUpConstants.FIELD_HEIGHT)
    
    hideBtn.edgesToSuperview()
    
    emailTitle.topToBottom(of: passwordFieldBG, offset: SignUpConstants.FIELD_TOP_OFF)
    emailTitle.leftToSuperview(offset : SignUpConstants.SIDE_OFF)
    
    emailFieldBG.topToBottom(of: emailTitle, offset: 6)
    emailFieldBG.left(to: usernameFieldBG)
    emailFieldBG.right(to: usernameFieldBG)
    emailFieldBG.height(to: usernameFieldBG)
    
    emailField.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    
    signUpBtnBg.topToBottom(of: emailFieldBG, offset: SignUpConstants.BUTTON_TOP_OFF)
    signUpBtnBg.leftToSuperview(offset : SignUpConstants.SIDE_OFF)
    signUpBtnBg.rightToSuperview(offset : -SignUpConstants.SIDE_OFF)
    signUpBtnBg.height(44)
    signUpBtnBg.bottom(to: contentView)
    
    signUpBtn.edgesToSuperview()
    
  }
  
  
}

//MARK:- Text View
extension NCSignUpView: UITextFieldDelegate{
  @objc func viewTapped(){
    usernameField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    emailField?.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameField{
      passwordField?.becomeFirstResponder()
    }else if textField == passwordField{
      emailField?.becomeFirstResponder()
    }else if textField == emailField{
      emailField?.resignFirstResponder()
    }
    return true
  }
}

//MARK : Password
extension NCSignUpView{
  @objc func hideFunction(){
    isPasswordHidden = !isPasswordHidden
    passwordField?.isSecureTextEntry = isPasswordHidden ? true : false
    hideBtn?.setImage(isPasswordHidden ? UIImage(named: "icon_hidden") : UIImage(named: "icon_hide"), for: .normal)
  }
}


//MARK : Constants
extension NCSignUpView{
  class SignUpConstants{
    static let TOP_GRADIENT_BOTTOM_OFF : CGFloat  = 36
    static let SIDE_OFF: CGFloat = 30
    static let FIELD_HEIGHT: CGFloat = 44
    static let USER_ICON_LEFT_OFF: CGFloat = 15
    static let USER_ICON_WIDTH : CGFloat = 20
    static let USER_ICON_RIGHT_OFF: CGFloat = 12
    static let FIELD_TOP_OFF : CGFloat = 16
    static let BUTTON_TOP_OFF : CGFloat = 25
    static let FONT_SIZE: CGFloat = 14
    static let CORNER_RADIUS : CGFloat = 5.0
    static let CORNER_RADIUS_ZERO : CGFloat = 0.0
    static let ICON_WIDTH : CGFloat = 100.0
    static let ICON_OFF : CGFloat = 5.0
    static let CAMERA_ICON_WIDTH : CGFloat = 35.0
  }
}
