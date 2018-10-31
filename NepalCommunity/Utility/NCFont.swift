//
//  NCFont.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/25.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCFont: NSObject{
  
  static func normal(size:CGFloat, weight:UIFont.Weight = UIFont.Weight.regular) -> UIFont?{
    return UIFont.systemFont(ofSize: size)
  }
  
  static func bold(size: CGFloat) -> UIFont?{
    return UIFont.boldSystemFont(ofSize: size)
  }
}
