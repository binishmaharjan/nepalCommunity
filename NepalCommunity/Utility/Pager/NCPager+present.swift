//
//  NCPager+present.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/08.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit


extension NCPager{
  
  func showLoginPage(){
    let vc = UINavigationController(rootViewController: NCLoginViewController())
    self.present(viewController: vc)
  }
  
}

