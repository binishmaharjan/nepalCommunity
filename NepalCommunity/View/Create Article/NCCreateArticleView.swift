//
//  NCCreateArticleView.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/21.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit
import TinyConstraints
import Photos
import SDWebImage

class NCCreateArticleView : NCBaseView{
  
  //MARK: Variables
  private var scrollView: UIScrollView?
  private var contentView: UIView?
  
  //All Photos
   var images:[UIImage] = []
  
  //Header
  private let HEADER_H:CGFloat = 44
  private weak var header:UIView?
  private weak var titleLbl:UILabel?
  private let BACK_C_X:CGFloat = 12.0
  weak var backBtn:NCImageButtonView?
  private weak var border:UIView?
  private var postBtnBG: UIView?
  var postBtn: NCTextButton?
  
  private var userImageBG: UIView?
  private var userImage: UIImageView?
  private var usernameLbl: UILabel?
  
  private var categoriesBG : UIView?
  private var categoriesLBl: UILabel?
  private var downIcon: UIImageView?
  var categoriesDelegate: NCCategoriesSelectionDelegate?
  private var _categories: NCCategories = NCCategories.food_travel{
    didSet{
      categoriesLBl?.text = LOCALIZE(_categories.rawValue)
    }
  }
  var categories:NCCategories{
    get{
      return _categories
    }
    set{
      _categories = newValue
    }
  }
  
  private var stackView : UIStackView?
  
  var titleField: UITextView?
  private var titleHeight:CGFloat = 24
  private var titleFieldHeightConstraints: Constraint?
  var isTitlePlaceholder: Bool = true
  
  private var seperator : UIView?
  private var seperatorTopConstraints: Constraint?
  
  var descriptionField: UITextView?
  private var descriptionHeight:CGFloat = 22
  private var descriptionFieldHeightConstraints: Constraint?
  var isDescriptionPlaceholder: Bool = true
  
  var selectedImageView: UIImageView?
  private var imageSelectionView: UICollectionView?
  private var _hasImage:Bool = false{
    didSet{
      if _hasImage{
        selectedImageHeightConstraints?.constant = selectedImageHeight
        cancelButtonBG?.isHidden = false
      }else{
        selectedImageHeightConstraints?.constant = 0
        cancelButtonBG?.isHidden = true
      }
      self.setNeedsUpdateConstraints()
    }
  }
  var hasImage: Bool{
    get{
      return _hasImage
    }
    set{
      _hasImage  = newValue
    }
  }
  private var cancelButtonBG:UIView?
  private var cancelButton: UIButton?
  private var selectedImageHeightConstraints: Constraint?
  var imageDelegate : NCImageSelectionDelegate?
  
  //Select Image Colletion View
  private var selectedImageHeight = ((UIScreen.main.bounds.width - 32))
  
  //CollectionView Cell
  typealias Cell = NCImageSelectionCell
  let CELL_CLASS = Cell.self
  let CELL_ID = NSStringFromClass(Cell.self)
  
  //Delegate
  var delegate: NCButtonDelegate?{
    didSet{
      backBtn?.delegate = delegate
      postBtn?.delegate = delegate
    }
  }
  
  //MARK: Override Methods
  override func didInit() {
    super.didInit()
    self.setup()
    self.setupConstraints()
    self.fetchPhotos()
  }
  
  
  override func updateConstraints() {
    titleFieldHeightConstraints?.constant = titleHeight
    descriptionFieldHeightConstraints?.constant = descriptionHeight
    super.updateConstraints()
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
    
    //Header
    let header = UIView()
    header.backgroundColor = NCColors.blue
    contentView.addSubview(header)
    self.header = header
    
    let backBtn = NCImageButtonView()
    backBtn.image = UIImage(named:"icon_back_white")
    header.addSubview(backBtn)
    self.backBtn = backBtn
    
    let titleLabel = UILabel()
    self.titleLbl = titleLabel
    titleLabel.text = LOCALIZE("Create Article")
    titleLabel.font = NCFont.bold(size: 18)
    titleLabel.textColor = NCColors.white
    header.addSubview(titleLabel)
    
    let postBtnBG = UIView()
    self.postBtnBG = postBtnBG
    postBtnBG.backgroundColor = NCColors.blue
    postBtnBG.layer.borderColor = NCColors.white.cgColor
    postBtnBG.layer.borderWidth = 1.0
    postBtnBG.layer.cornerRadius = 5.0
    header.addSubview(postBtnBG)
    
    let postBtn = NCTextButton()
    self.postBtn = postBtn
    postBtn.text = LOCALIZE("POST")
    postBtn.font = NCFont.bold(size: 14)
    postBtnBG.addSubview(postBtn)
    
    //User Image
    let userImageBG = UIView()
    self.userImageBG = userImageBG
    userImageBG.dropShadow()
    userImageBG.layer.cornerRadius = 5.0
    contentView.addSubview(userImageBG)
    
    let userImage = UIImageView()
    self.userImage = userImage
    userImageBG.addSubview(userImage)
    userImage.layer.cornerRadius = 5.0
    userImage.image = UIImage(named: "50")
    userImage.clipsToBounds = true
    userImage.contentMode = .scaleAspectFill
    if let imageUrl = NCSessionManager.shared.user?.iconUrl{
      userImage.sd_setImage(with: URL(string: imageUrl)) { (image, error, _, _) in
        userImage.image = image
      }
    }
    
    let usernameLbl = UILabel()
    self.usernameLbl = usernameLbl
    usernameLbl.text = LOCALIZE(NCSessionManager.shared.user?.username ?? "")
    usernameLbl.textColor = NCColors.black
    usernameLbl.font = NCFont.bold(size: 14)
    contentView.addSubview(usernameLbl)
    
    //Categories
    let categoriesBG = UIView()
    self.categoriesBG = categoriesBG
    contentView.addSubview(categoriesBG)
    categoriesBG.layer.borderWidth = 1.0
    categoriesBG.layer.cornerRadius = 5.0
    categoriesBG.layer.borderColor = NCColors.darKGray.cgColor
    categoriesBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCategories)))
    
    let categoriesLbl = UILabel()
    self.categoriesLBl = categoriesLbl
    categoriesLbl.text = LOCALIZE(NCCategories.food_travel.rawValue)
    categoriesLbl.textColor = NCColors.darKGray
    categoriesLbl.font = NCFont.bold(size: 12)
    categoriesBG.addSubview(categoriesLbl)
    
    let downIcon = UIImageView()
    self.downIcon = downIcon
    downIcon.image = UIImage(named: "icon_drop_down")
    categoriesBG.addSubview(downIcon)
    downIcon.contentMode = .scaleAspectFit
    
    //Stack View
    let stackView = UIStackView()
    self.stackView = stackView
    stackView.distribution = .fill
    stackView.axis = .vertical
    stackView.spacing = 8
    contentView.addSubview(stackView)
    
    //titleField
    let titleField = UITextView()
    self.titleField = titleField
    titleField.text = LOCALIZE("Title...")
    titleField.font = NCFont.normal(size: 20)
    titleField.textColor = NCColors.darKGray
    titleField.delegate = self
    titleField.textContainerInset = .zero
    titleField.isScrollEnabled = false
    stackView.addArrangedSubview(titleField)
    
    //Seperator
    let seperator = UIView()
    self.seperator = seperator
    seperator.backgroundColor = NCColors.darKGray
    contentView.addSubview(seperator)
    stackView.addArrangedSubview(seperator)
    
    //Description Field
    let descriptionField = UITextView()
    self.descriptionField = descriptionField
    descriptionField.text = LOCALIZE("Type Something...")
    descriptionField.font = NCFont.normal(size: 18)
    descriptionField.textColor = NCColors.darKGray
    descriptionField.delegate = self
    descriptionField.textContainerInset = .zero
    descriptionField.isScrollEnabled = false
    stackView.addArrangedSubview(descriptionField)
    
    //Image selector
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 70, height: 70)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.imageSelectionView = collectionView
    collectionView.backgroundColor = NCColors.white
    collectionView.register(CELL_CLASS, forCellWithReuseIdentifier: CELL_ID)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.showsHorizontalScrollIndicator = false
    self.addSubview(collectionView)
    
    let selectedImageView = UIImageView()
    self.selectedImageView = selectedImageView
    selectedImageView.image = UIImage(named: "51")
    selectedImageView.layer.cornerRadius = 5
    selectedImageView.layer.borderWidth = 1
    selectedImageView.layer.borderColor = NCColors.darKGray.cgColor
    selectedImageView.clipsToBounds = true
    selectedImageView.contentMode = .scaleAspectFill
    selectedImageView.isUserInteractionEnabled = true
    selectedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageWasTapped)))
    stackView.addArrangedSubview(selectedImageView)
    
    //Cancel Button For the image selection
    let cancelButtonBG = UIView()
    self.cancelButtonBG = cancelButtonBG
    contentView.addSubview(cancelButtonBG)
    cancelButtonBG.backgroundColor = NCColors.white.withAlphaComponent(0.5)
    cancelButtonBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelButtonPressed)))
    cancelButtonBG.isHidden = true
    cancelButtonBG.layer.cornerRadius = 30 / 2

    let cancelButton = UIButton()
    self.cancelButton = cancelButton
    cancelButtonBG.addSubview(cancelButton)
    cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    cancelButton.setImage(UIImage(named: "icon_cancel"), for: .normal)
  }
  
  private func setupConstraints(){
    guard let scrollView = self.scrollView,
          let contentView = self.contentView,
          let header = self.header,
          let backBtn = self.backBtn,
          let titleLbl = self.titleLbl,
          let postBtnBG = self.postBtnBG,
          let postBtn = self.postBtn,
          let userImageBG = self.userImageBG,
          let userImage = self.userImage,
          let usernameLbl = self.usernameLbl,
          let categoriesBG = self.categoriesBG,
          let categoriesLbl = self.categoriesLBl,
          let downIcon = self.downIcon,
          let titleField = self.titleField,
          let seperator = self.seperator,
          let stackView = self.stackView,
          let imageSelectionView = self.imageSelectionView,
          let selectedImageView = self.selectedImageView,
          let cancelButtonBG = self.cancelButtonBG,
          let cancelButton = self.cancelButton
    else {return}
    
    //Height of the contentView is decided by the bottom view i.e signupbtn
    scrollView.edgesToSuperview(excluding: .bottom)
    scrollView.bottomToTop(of: imageSelectionView)
    contentView.edgesToSuperview()
    contentView.width(to: scrollView)
    contentView.bottom(to: stackView, offset : 8)    //In this method the height of the content view is decided by the bottom signupBottom
    
    header.topToSuperview()
    header.leftToSuperview()
    header.rightToSuperview()
    header.height(HEADER_H)
    
    backBtn.centerYToSuperview()
    backBtn.leftToSuperview(offset: BACK_C_X)
    
    titleLbl.centerInSuperview()
    
    postBtnBG.rightToSuperview(offset : -BACK_C_X)
    postBtnBG.centerYToSuperview()
    postBtnBG.width(70)
    postBtnBG.height(29)
    
    postBtn.edgesToSuperview()
    
    userImageBG.topToBottom(of: header, offset: 16)
    userImageBG.leftToSuperview(offset : 16)
    userImageBG.width(42)
    userImageBG.height(to: userImageBG, userImageBG.widthAnchor)
    
    userImage.edgesToSuperview()
    
    usernameLbl.leftToRight(of: userImageBG, offset: 10)
    usernameLbl.top(to: userImageBG)
    
    categoriesBG.left(to: usernameLbl)
    categoriesBG.bottom(to: userImageBG)
    categoriesBG.right(to: downIcon, offset: 8)
    categoriesBG.topToBottom(of: usernameLbl, offset: 5)
    
    categoriesLbl.leftToSuperview(offset:8)
    categoriesLbl.centerYToSuperview()
    
    downIcon.leftToRight(of: categoriesLbl, offset : 8)
    downIcon.centerY(to: categoriesLbl)
    
    stackView.topToBottom(of: userImage, offset: 16)
    stackView.leftToSuperview(offset : 16)
    stackView.rightToSuperview(offset : -16)
    
    titleFieldHeightConstraints = titleField.height(titleHeight)
  
    seperator.height(1)
    
    descriptionFieldHeightConstraints = descriptionField?.height(descriptionHeight)
    
    selectedImageView.rightToSuperview()
    selectedImageView.leftToSuperview()
    selectedImageHeightConstraints = selectedImageView.height(0)
    
    imageSelectionView.bottomToSuperview(offset: -5, usingSafeArea : true)
    imageSelectionView.leftToSuperview(offset: 16)
    imageSelectionView.rightToSuperview()
    imageSelectionView.height(70)
    
    cancelButtonBG.top(to: selectedImageView, offset : 10)
    cancelButtonBG.right(to: selectedImageView, offset: -10)
    cancelButtonBG.width(30)
    cancelButtonBG.height(to: cancelButtonBG, cancelButtonBG.widthAnchor)
    
    cancelButton.edgesToSuperview(insets: TinyEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
  }
}

//MARK:TextField Delegate
extension NCCreateArticleView: UITextViewDelegate{
  
  func textViewDidChange(_ textView: UITextView) {
    if textView == titleField{
      let fixedWidth = textView.frame.size.width
      let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
      let size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
      titleHeight = size.height
    }else if textView == descriptionField{
      let fixedWidth = textView.frame.size.width
      let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
      let size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
      descriptionHeight = size.height
    }
    self.setNeedsUpdateConstraints()
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    
    if textView == titleField{
      if isTitlePlaceholder{
        textView.text = LOCALIZE("")
        textView.textColor = NCColors.black
        isTitlePlaceholder = false
      }
    }else if textView == descriptionField{
      if isDescriptionPlaceholder{
        textView.text = LOCALIZE("")
        textView.textColor = NCColors.black
        isDescriptionPlaceholder = false
      }
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == LOCALIZE(""){
      textView.textColor = NCColors.darKGray
      if textView == titleField{
          isTitlePlaceholder = true
          textView.text = LOCALIZE("Title...")
      }else if textView == descriptionField{
          isDescriptionPlaceholder = true
          textView.text = LOCALIZE("Type Something...")
      }
    }
  }
}

//MARK: Collection View Delegate(Image Selection)
extension NCCreateArticleView: UICollectionViewDelegate,UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count + 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as? NCImageSelectionCell{
      
      if indexPath.row == 0{
        cell.imageView?.image = UIImage(named: "icon_camera_gray")
      }else if indexPath.row == 1{
        cell.imageView?.image = UIImage(named: "icon_gallery")
      }else{
        cell.imageView?.image = images[indexPath.row - 2]
      }
      cell.indexPath = indexPath.row
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == 0{
      imageDelegate?.openCamera()
    }else if indexPath.row == 1{
      imageDelegate?.showLibrary()
    }else{
      let index = indexPath.row
      selectedImageView?.image = images[index - 2]
      hasImage = true
    }
  }
  
}

//MARK: Import Photos from the library
extension NCCreateArticleView{
  func fetchPhotos () {
    // Sort the images by descending creation date and fetch the first 3
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
    fetchOptions.fetchLimit = 18
    
    // Fetch the image assets
    let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
    
    // If the fetch result isn't empty,
    // proceed with the image request
    if fetchResult.count > 0 {
      let totalImageCountNeeded = 18 // <-- The number of images to fetch
      fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
    }
  }
  
  // Repeatedly call the following method while incrementing
  // the index until all the photos are fetched
  func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
    
    // Note that if the request is not set to synchronous
    // the requestImageForAsset will return both the image
    // and thumbnail; by setting synchronous to true it
    // will return just the thumbnail
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = true
    
    // Perform the image request
    PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: CGSize(width: 1024, height: 768), contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
      if let image = image {
        // Add the returned image to your array
        self.images += [image]
      }
      // If you haven't already reached the first
      // index of the fetch result and if you haven't
      // already stored all of the images you need,
      // perform the fetch request again with an
      // incremented index
      if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
        self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
      } else {
        // Else you have completed creating your array
        self.imageSelectionView?.reloadData()
      }
    })
  }
}

//MARK: Categories Selection
extension NCCreateArticleView{
  
  @objc private func selectCategories(){
    categoriesDelegate?.categoriesSelectionTapped()
  }
}

//MARK :  Image Pressed and Cancel Button Pressed
extension NCCreateArticleView{
  @objc private func cancelButtonPressed(){
    hasImage = false
  }
  
  @objc private func imageWasTapped(){
    guard let imageView = self.selectedImageView,
      let image = imageView.image else {return}
    imageDelegate?.imagePressed(image: image)
  }
}
