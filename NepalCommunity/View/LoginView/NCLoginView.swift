//
//  NCLoginView.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints


class NCLoginView : NCBaseView{
  //MARK: Variables
  var signUpDelegate : NCLoginViewDelegate?
  var delegate : NCButtonDelegate?{
    didSet{
      signInBtn?.delegate = delegate
      fbBtn?.delegate = delegate
    }
  }
  
  //MARK: Fields
  private var scrollView: UIScrollView?
  private var contentViewHeightConstraint: Constraint?
  private var contentView: UIView?
  
//  private var topGradientView : NCGradientView?
  
  private var titleText : UILabel?
  private var emailFieldBG : UIView?//Was changed to email from user name
  private var emailTitle :UILabel?
  var emailField: UITextField?
  private var passwordFieldBG: UIView?
  private var passwordTitle:UILabel?
  var passwordField: UITextField?
  private var signInBtnBG :NCGradientView?
  var signInBtn: NCTextButton?
  private var fbBtnBG: NCGradientView?
  var fbBtn: NCTextButton?
  private var noAccountLbl: UILabel?
  private var signUpLbl: UILabel?
  private var bottomLblStack : UIStackView?

  //MARK: Methods
  override func didInit() {
    super.didInit()
    setup()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    guard let contentViewHeightConstraint = self.contentViewHeightConstraint,
          let scrollView = self.scrollView,
          contentViewHeightConstraint.constant == 0 else { return }
    
    self.layoutIfNeeded()
    self.setNeedsLayout()
    
    contentViewHeightConstraint.constant = scrollView.frame.height
  }
  
  
  private func setup(){
    
  //Setting Tap Gesture
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    
    //SCroll View
    let scrollView = UIScrollView()
    self.scrollView = scrollView
    scrollView.bounces  = false
    self.addSubview(scrollView)
    
    let contentView = UIView()
    self.contentView = contentView
    scrollView.addSubview(contentView)
    
    
    //GradientView
//    let topGradientView = NCGradientView(
//      colors: [NCColors.red.cgColor, NCColors.lightRed.cgColor, NCColors.white.cgColor],
//      cornerRadius: LoginConstant.CORNER_RADIUS_ZERO,
//      startPoint: CGPoint(x: 0, y: 0),
//      endPoint: CGPoint(x:0, y:1)
//    )
//
//    self.topGradientView = topGradientView
//    contentView.addSubview(topGradientView)
    
    //Title Text
    let titleText = UILabel()
    self.titleText = titleText
    titleText.textColor = NCColors.blue
    titleText.font = NCFont.normal(size: 32)
    contentView.addSubview(titleText)
    titleText.text = LOCALIZE("Sign In")

    
  //Username
    let emailTitle = UILabel()
    self.emailTitle = emailTitle
    emailTitle.font = NCFont.normal(size: LoginConstant.FONT_SIZE)
    emailTitle.textColor = NCColors.black
    emailTitle.text = LOCALIZE("Your email address")
    contentView.addSubview(emailTitle)
    
    let usernameFieldBG = UIView()
    self.emailFieldBG = usernameFieldBG
    usernameFieldBG.backgroundColor = NCColors.white
    usernameFieldBG.layer.cornerRadius = LoginConstant.CORNER_RADIUS_ZERO
    usernameFieldBG.layer.borderColor = NCColors.gray.cgColor
    usernameFieldBG.layer.borderWidth = 2
    contentView.addSubview(usernameFieldBG)
    
    let usernameField = UITextField()
    self.emailField = usernameField
    usernameField.backgroundColor = NCColors.white
    usernameField.placeholder = LOCALIZE("Email")
    usernameField.font = NCFont.normal(size: LoginConstant.FONT_SIZE)
    usernameField.delegate = self
    usernameFieldBG.addSubview(usernameField)
    
    //Password
    let passwordTitle = UILabel()
    self.passwordTitle = passwordTitle
    passwordTitle.font = NCFont.normal(size: LoginConstant.FONT_SIZE)
    passwordTitle.textColor = NCColors.black
    passwordTitle.text = LOCALIZE("Password")
    contentView.addSubview(passwordTitle)
    
    let passwordFieldBG = UIView()
    self.passwordFieldBG = passwordFieldBG
    passwordFieldBG.backgroundColor = NCColors.white
    passwordFieldBG.layer.cornerRadius = LoginConstant.CORNER_RADIUS_ZERO
    passwordFieldBG.layer.borderColor = NCColors.gray.cgColor
    passwordFieldBG.layer.borderWidth = 2
    contentView.addSubview(passwordFieldBG)
    
    let passwordField = UITextField()
    self.passwordField = passwordField
    passwordField.backgroundColor = NCColors.white
    passwordField.placeholder = LOCALIZE("Password")
    passwordField.font = NCFont.normal(size: LoginConstant.FONT_SIZE)
    passwordField.delegate = self
    passwordFieldBG.addSubview(passwordField)
    
    //SignIn Button
    let signInBtnBG = NCGradientView(
      colors: [NCColors.blue.cgColor, NCColors.blue.cgColor],
      cornerRadius: LoginConstant.CORNER_RADIUS_ZERO,
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x:1, y:0)
    )
    self.signInBtnBG = signInBtnBG
    signInBtnBG.layer.cornerRadius = LoginConstant.CORNER_RADIUS_ZERO
    signInBtnBG.dropShadow()
    contentView.addSubview(signInBtnBG)
    
    let signInBtn = NCTextButton()
    self.signInBtn = signInBtn
    signInBtn.backgroundColor = NCColors.clear
    signInBtn.text = LOCALIZE("Sign In")
    signInBtn.font = NCFont.bold(size: LoginConstant.FONT_SIZE)
    signInBtn.textColor = NCColors.white
    signInBtnBG.addSubview(signInBtn)

    
    //FaceBook Button
    let fbBtnBG = NCGradientView(
      colors: [NCColors.fbBlue.cgColor, NCColors.fbBlue.cgColor],
      cornerRadius: LoginConstant.CORNER_RADIUS_ZERO,
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x:1, y:0)
    )

    self.fbBtnBG = fbBtnBG
    fbBtnBG.layer.cornerRadius = LoginConstant.CORNER_RADIUS_ZERO
    fbBtnBG.dropShadow()
    contentView.addSubview(fbBtnBG)
    
    let fbBtn = NCTextButton()
    self.fbBtn = fbBtn
    fbBtn.backgroundColor = NCColors.clear
    fbBtn.text = LOCALIZE("Sign In With Facebook")
    fbBtn.font = NCFont.bold(size: LoginConstant.FONT_SIZE)
    fbBtn.textColor = NCColors.white
    fbBtnBG.addSubview(fbBtn)
  
    
    //Sign Up Label
    
    
    let bottomLblStack = UIStackView()
    self.bottomLblStack = bottomLblStack
    contentView.addSubview(bottomLblStack)
    bottomLblStack.distribution  = .fill
    bottomLblStack.axis = .horizontal
    
    
    let noAccountLbl = UILabel()
    self.noAccountLbl = noAccountLbl
    noAccountLbl.text = LOCALIZE("Don't have an account? ")
    noAccountLbl.font = NCFont.normal(size: LoginConstant.FONT_SIZE)
    noAccountLbl.textColor = NCColors.black
    bottomLblStack.addArrangedSubview(noAccountLbl)
    
    
    let signUpLbl = UILabel()
    self.signUpLbl = signUpLbl
    signUpLbl.text = LOCALIZE("Sign Up")
    signUpLbl.font = NCFont.normal(size: LoginConstant.FONT_SIZE)
    signUpLbl.textColor = NCColors.blue
    bottomLblStack.addArrangedSubview(signUpLbl)
    signUpLbl.isUserInteractionEnabled = true
    signUpLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtonPressed)))
  }
  
  private func setupConstraints(){
    guard let passwordFieldBG = self.passwordFieldBG,
          let passwordTitle = self.passwordTitle,
          let passwordField = self.passwordField,
          let usernameFieldBG = self.emailFieldBG,
          let usernameField = self.emailField,
          let emailTitle = self.emailTitle,
          let signInBtnBG = self.signInBtnBG,
          let signInBtn = self.signInBtn,
          let fbBtnBG = self.fbBtnBG,
          let fbBtn  = self.fbBtn,
          let scrollView = self.scrollView,
          let contentView = self.contentView,
          let titleText = self.titleText,
          //let topGradientView = self.topGradientView,
          let bottomLblStack = self.bottomLblStack else { return }
    
    let TOP_OFFSET = (UIScreen.main.bounds.height * 20 ) / 100
    
    //Height of the contentView is decided scroll View(same as scroll view)
    //by since scroll view size changes as the keyboard comes up by the
    //but the size of contentview must remain same as so setting the size of the
    //content view equal to the scroll only once when content view height == 0
    //Setting in the layoutSubviews() method
    scrollView.edgesToSuperview()//Edge to SuperView
    contentView.edgesToSuperview()//Edge to SuperView
    contentViewHeightConstraint = contentView.height(0)//Currently zero but will set to same as scrollview height but only once in layoutSubviews()
    contentView.width(to: scrollView)//Should be equal to scroll View
    
    //In this method the the bottom label position is decide by the content View
    
//    topGradientView.edgesToSuperview(excluding: .bottom)
//    topGradientView.height(TOP_OFFSET)
    titleText.topToSuperview(offset : TOP_OFFSET)
    titleText.centerXToSuperview()
    
    emailTitle.topToBottom(of: titleText, offset: LoginConstant.TOP_GRADIENT_BOTTOM_OFF)
    emailTitle.leftToSuperview(offset : LoginConstant.SIDE_OFF)
    
    usernameFieldBG.topToBottom(of: emailTitle, offset: 6)
    usernameFieldBG.leftToSuperview(offset : LoginConstant.SIDE_OFF)
    usernameFieldBG.rightToSuperview(offset : -LoginConstant.SIDE_OFF)
    usernameFieldBG.height(LoginConstant.FIELD_HEIGHT)
  
    usernameField.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    
    passwordTitle.topToBottom(of: usernameFieldBG, offset: LoginConstant.FIELD_TOP_OFF)
    passwordTitle.leftToSuperview(offset : LoginConstant.SIDE_OFF)
    
    passwordFieldBG.topToBottom(of: passwordTitle, offset: 6)
    passwordFieldBG.left(to: usernameFieldBG)
    passwordFieldBG.right(to: usernameFieldBG)
    passwordFieldBG.height(to: usernameFieldBG)
    
    passwordField.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
  
    
    
    signInBtnBG.topToBottom(of: passwordFieldBG, offset: LoginConstant.BUTTON_TOP_OFF)
    signInBtnBG.leftToSuperview(offset : LoginConstant.SIDE_OFF)
    signInBtnBG.rightToSuperview(offset : -LoginConstant.SIDE_OFF)
    signInBtnBG.height(LoginConstant.FIELD_HEIGHT)
    
    signInBtn.edgesToSuperview()
    
    fbBtnBG.topToBottom(of: signInBtnBG, offset: LoginConstant.BUTTON_TOP_OFF)
    fbBtnBG.left(to: usernameFieldBG)
    fbBtnBG.right(to: usernameFieldBG)
    fbBtnBG.height(to: usernameFieldBG)
    
    fbBtn.edgesToSuperview()
    
    bottomLblStack.centerXToSuperview()
//    bottomLblStack.topToSuperview(offset : UIScreen.main.bounds.height - LoginConstant.BOTTOM_LABEL_BOTTOM_OFF)
    bottomLblStack.bottom(to: contentView, offset : -20)
  }
  
  
}

//MARK:- Text View
extension NCLoginView : UITextFieldDelegate{
  @objc func viewTapped(){
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField{
      passwordField?.becomeFirstResponder()
    }else if textField == passwordField{
      passwordField?.resignFirstResponder()
    }
    return true
  }
}

//MARK :- Buttons Pressed{
extension NCLoginView{
  @objc func signUpButtonPressed(){
    guard let delegate  = self.signUpDelegate else { return }
    delegate.signUpButtonPressed()
  }
}

//MARK: Constant
extension NCLoginView{
  class LoginConstant{
    static let TOP_GRADIENT_BOTTOM_OFF : CGFloat  = 36
    static let SIDE_OFF: CGFloat = 30
    static let FIELD_HEIGHT: CGFloat = 44
    static let USER_ICON_LEFT_OFF: CGFloat = 15
    static let USER_ICON_WIDTH : CGFloat = 20
    static let USER_ICON_RIGHT_OFF: CGFloat = 12
    static let FIELD_TOP_OFF : CGFloat = 16
    static let BUTTON_TOP_OFF : CGFloat = 25
    static let BOTTOM_LABEL_BOTTOM_OFF : CGFloat = 50
    static let FONT_SIZE: CGFloat = 14
    static let CORNER_RADIUS : CGFloat = 5.0
    static let CORNER_RADIUS_ZERO : CGFloat = 0.0
  }
}
