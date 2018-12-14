//
//  StructWrapper.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/14.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation


class StructWrapper<T>: NSObject {
  
  let value: T
  
  init(_ _struct: T) {
    self.value = _struct
  }
}
