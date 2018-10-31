//
//  GradientView.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/28.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class GradientView: UIView{
  private let gradient : CAGradientLayer = CAGradientLayer()
  private var startColor: UIColor!
  private var endColor : UIColor!
  
  init(startColor: UIColor, endColor: UIColor) {
    self.startColor = startColor
    self.endColor = endColor
    super.init(frame: .zero)
  }

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    self.gradient.frame = self.bounds
  }
  
  override public func draw(_ rect: CGRect) {
    self.gradient.frame = self.bounds
    self.gradient.colors = [startColor.cgColor, endColor.cgColor]
    self.gradient.cornerRadius = 5.0
    self.gradient.startPoint = CGPoint.init(x: 0, y: 0)
    self.gradient.endPoint = CGPoint.init(x: 1, y: 0)
    if self.gradient.superlayer == nil {
      self.layer.insertSublayer(self.gradient, at: 0)
    }
  }
}
