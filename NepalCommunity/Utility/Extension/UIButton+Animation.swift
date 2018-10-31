//
//  UIButton+Animation.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/26.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

extension UIButton{
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    UIView.animate(withDuration: 0.2) {
      self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
  }
  
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
      self.transform = CGAffineTransform.identity
    }, completion: nil)
  }
}
