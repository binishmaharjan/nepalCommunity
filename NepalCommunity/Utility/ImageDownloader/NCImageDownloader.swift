//
//  NCImageDownloader.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCImageDownloader{
  private init(){}
  
  static let shared = NCImageDownloader()
  
  func downloadImage(from url : String)->UIImage{
    DispatchQueue.global(qos: .default).async {
      
    }
    return UIImage()
  }
}
