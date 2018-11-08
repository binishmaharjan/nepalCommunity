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
  
  private var topGradientView : NCGradientView?
  
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
  private var iconViewBG : UIView?
  var iconView : UIImageView?
  var cameraIcon : NCImageButtonView?
  
  //Fields
  private var usernameFieldBG : UIView?
  private var usernameIcon: UIImageView?
  var usernameField: UITextField?
  private var passwordFieldBG: UIView?
  private var passwordIcon : UIImageView?
  var passwordField: UITextField?
  private var emailFieldBG : UIView?
  private var emailIcon : UIImageView?
  var emailField :UITextField?
  private weak var signUpBtnBG :NCGradientView?
  weak var signUpBtn: NCTextButton?

  
  //MARK: Methods
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  private func setupHeaderConstraints(){
    guard let header = self.header,
      let backBtn = self.backBtn else { return }
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
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
    
    //GradientView
    let topGradientView = NCGradientView(
      colors: [NCColors.red.cgColor, NCColors.lightRed.cgColor, NCColors.white.cgColor],
      cornerRadius: SignUpConstants.CORNER_RADIUS_ZERO,
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x:0, y:1)
    )
    
    self.topGradientView = topGradientView
    contentView.addSubview(topGradientView)
    
    //Icon
    let iconViewBG = UIView()
    self.iconViewBG = iconViewBG
    contentView.addSubview(iconViewBG)
    iconViewBG.backgroundColor = NCColors.lightRed
    iconViewBG.dropShadow()
    
    let iconView = UIImageView()
    self.iconView = iconView
    iconViewBG.addSubview(iconView)
    iconView.backgroundColor = NCColors.white
    iconView.image = UIImage(named: "icon_default")
    iconView.contentMode = .scaleAspectFill
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
    
    
    //Username
    let usernameFieldBG = UIView()
    self.usernameFieldBG = usernameFieldBG
    usernameFieldBG.backgroundColor = NCColors.white
    usernameFieldBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS
    usernameFieldBG.dropShadow()
    contentView.addSubview(usernameFieldBG)
    
    let usernameIcon = UIImageView()
    self.usernameIcon = usernameIcon
    usernameIcon.contentMode = .scaleAspectFit
    usernameIcon.image = UIImage(named: "icon_user")
    usernameFieldBG.addSubview(usernameIcon)
    
    let usernameField = UITextField()
    self.usernameField = usernameField
    usernameField.backgroundColor = NCColors.white
    usernameField.placeholder = LOCALIZE("USERNAME")
    usernameField.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    usernameFieldBG.addSubview(usernameField)
    usernameField.delegate = self
    
    //Password
    let passwordFieldBG = UIView()
    self.passwordFieldBG = passwordFieldBG
    passwordFieldBG.backgroundColor = NCColors.white
    passwordFieldBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS
    passwordFieldBG.dropShadow()
    contentView.addSubview(passwordFieldBG)
    
    let passwordIcon = UIImageView()
    self.passwordIcon = passwordIcon
    passwordIcon.contentMode = .scaleAspectFit
    passwordIcon.image = UIImage(named: "icon_lock")
    passwordFieldBG.addSubview(passwordIcon)
    
    let passwordField = UITextField()
    self.passwordField = passwordField
    passwordField.backgroundColor = NCColors.white
    passwordField.placeholder = LOCALIZE("PASSWORD")
    passwordField.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    passwordFieldBG.addSubview(passwordField)
    passwordField.delegate = self
    
    //Email
    let emailFieldBG = UIView()
    self.emailFieldBG = emailFieldBG
    emailFieldBG.backgroundColor = NCColors.white
    emailFieldBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS
    emailFieldBG.dropShadow()
    contentView.addSubview(emailFieldBG)
    
    let emailIcon = UIImageView()
    self.emailIcon = emailIcon
    emailIcon.contentMode = .scaleAspectFit
    emailIcon.image = UIImage(named: "icon_mail")
    emailFieldBG.addSubview(emailIcon)
    
    let emailField = UITextField()
    self.emailField = emailField
    emailField.backgroundColor = NCColors.white
    emailField.placeholder = LOCALIZE("EMAIL")
    emailField.font = NCFont.normal(size: SignUpConstants.FONT_SIZE)
    emailFieldBG.addSubview(emailField)
    emailField.delegate = self
    
    //SignIn Button
    let signUpBtnBG = NCGradientView(
      colors: [NCColors.red.cgColor, NCColors.lightRed.cgColor],
      cornerRadius: SignUpConstants.CORNER_RADIUS,
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x:1, y:0)
    )
    self.signUpBtnBG = signUpBtnBG
    signUpBtnBG.layer.cornerRadius = SignUpConstants.CORNER_RADIUS
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
      let passwordIcon = self.passwordIcon,
      let passwordField = self.passwordField,
      let usernameFieldBG = self.usernameFieldBG,
      let usernameField = self.usernameField,
      let usernameIcon = self.usernameIcon,
      let signUpBtnBg = self.signUpBtnBG,
      let signUpBtn = self.signUpBtn,
      let emailFieldBG = self.emailFieldBG,
      let emailIcon = self.emailIcon,
      let emailField  = self.emailField,
      let scrollView = self.scrollView,
      let contentView = self.contentView,
      let header = self.header,
      let backBtn = self.backBtn,
      let iconViewBG = self.iconViewBG,
      let iconView = self.iconView,
      let cameraIcon = self.cameraIcon,
      let topGradientView = self.topGradientView else { return }
    
    let TOP_OFFSET = (UIScreen.main.bounds.height * 30 ) / 100
    
    
    //Height of the contentView is decidec by the bottom view i.e signupbtn
    scrollView.edgesToSuperview()
    contentView.edgesToSuperview()
    contentView.width(to: scrollView)
    //In this method the height of the content view is decided by the bottom signupBottom
    
    topGradientView.edgesToSuperview(excluding: .bottom)
    topGradientView.height(TOP_OFFSET)
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    iconViewBG.centerX(to: topGradientView)
    iconViewBG.width(SignUpConstants.ICON_WIDTH)
    iconViewBG.height(to: iconViewBG,iconViewBG.widthAnchor)
    iconViewBG.centerY(to: topGradientView)
    
    iconView.centerInSuperview()
    iconView.widthToSuperview(offset: -SignUpConstants.ICON_OFF)
    iconView.height(to: iconView, iconView.widthAnchor)
    
    iconViewBG.setNeedsLayout()
    iconViewBG.layoutIfNeeded()
    iconView.setNeedsLayout()
    iconView.layoutIfNeeded()
    
    iconViewBG.layer.cornerRadius = iconViewBG.bounds.width / 2
    iconView.layer.cornerRadius = iconView.bounds.width / 2
    
    cameraIcon.width(SignUpConstants.CAMERA_ICON_WIDTH)
    cameraIcon.height(to: cameraIcon, cameraIcon.widthAnchor)
    cameraIcon.right(to: iconViewBG)
    cameraIcon.bottom(to: iconViewBG)
    
    usernameFieldBG.topToBottom(of: topGradientView, offset: SignUpConstants.TOP_GRADIENT_BOTTOM_OFF)
    usernameFieldBG.leftToSuperview(offset : SignUpConstants.SIDE_OFF)
    usernameFieldBG.rightToSuperview(offset : -SignUpConstants.SIDE_OFF)
    usernameFieldBG.height(SignUpConstants.FIELD_HEIGHT)
    
    usernameIcon.leftToSuperview(offset : SignUpConstants.USER_ICON_LEFT_OFF)
    usernameIcon.centerYToSuperview()
    usernameIcon.width(SignUpConstants.USER_ICON_WIDTH)
    usernameIcon.height(to: usernameIcon, usernameIcon.widthAnchor)
    
    usernameField.leftToRight(of: usernameIcon, offset: SignUpConstants.USER_ICON_RIGHT_OFF)
    usernameField.edgesToSuperview(excluding: .left, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5))
    
    
    passwordFieldBG.topToBottom(of: usernameFieldBG, offset: SignUpConstants.FIELD_TOP_OFF)
    passwordFieldBG.left(to: usernameFieldBG)
    passwordFieldBG.right(to: usernameFieldBG)
    passwordFieldBG.height(to: usernameFieldBG)
    
    passwordIcon.leftToSuperview(offset : SignUpConstants.USER_ICON_LEFT_OFF)
    passwordIcon.centerYToSuperview()
    passwordIcon.width(SignUpConstants.USER_ICON_WIDTH)
    passwordIcon.height(to: passwordIcon, passwordIcon.widthAnchor)
    
    passwordField.leftToRight(of: usernameIcon, offset: SignUpConstants.USER_ICON_RIGHT_OFF)
    passwordField.edgesToSuperview(excluding: .left, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5))
    
    emailFieldBG.topToBottom(of: passwordFieldBG, offset: SignUpConstants.FIELD_TOP_OFF)
    emailFieldBG.left(to: usernameFieldBG)
    emailFieldBG.right(to: usernameFieldBG)
    emailFieldBG.height(to: usernameFieldBG)
    
    emailIcon.leftToSuperview(offset : SignUpConstants.USER_ICON_LEFT_OFF)
    emailIcon.centerYToSuperview()
    emailIcon.width(SignUpConstants.USER_ICON_WIDTH)
    emailIcon.height(to: emailIcon, emailIcon.widthAnchor)
    
    emailField.leftToRight(of: usernameIcon, offset: SignUpConstants.USER_ICON_RIGHT_OFF)
    emailField.edgesToSuperview(excluding: .left, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5))
    
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
