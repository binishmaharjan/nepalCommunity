//
//  NCImageSelectionDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/27.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit



protocol NCImageDelegate{
  func imagePressed(image : UIImage)
}

protocol NCCellToTableViewDelegate{
  func passImageFromCellToTable(image: UIImage)
}

protocol NCImageSelectionDelegate: NCImageDelegate {
  func showLibrary()
  func openCamera()
}
