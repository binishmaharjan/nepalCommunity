//
//  NCNaviagtionController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/14.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class NCNaviagtionController: UINavigationController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Bar tint color of the navigation bar
    self.navigationBar.barTintColor = NCColors.blue
    
    //tint color of the navigation bar
    self.navigationBar.tintColor = NCColors.red
    
    //changing the color of title of the navigation bar
    let attrs = [
      NSAttributedString.Key.foregroundColor : NCColors.white
    ]
    self.navigationBar.titleTextAttributes = attrs
    
    //Making the navigationbar non translucent
    self.navigationBar.isTranslucent = false
    
  
  }
  /*
  Changing the color of the status bar
  If viewcontroller is embedded in navigation bar overriding prederredStatusStyle doesnot chagnes the color.you have to change in the navigation controller. change the setting in  info plist to YES
 */
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
}
