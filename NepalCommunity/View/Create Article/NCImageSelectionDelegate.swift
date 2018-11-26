//
//  NCImageSelectionDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/27.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


protocol NCImageSelectionDelegate {
  func showLibrary()
  func openCamera()
  func imagePressed(image : UIImage)
}
