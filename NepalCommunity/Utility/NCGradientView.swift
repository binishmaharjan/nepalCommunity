//
//  NCGradientView.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/28.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class NCGradientView : UIView{
  private let gradient : CAGradientLayer = CAGradientLayer()
  private var colors : [CGColor]!
  private var cornerRadius : CGFloat!
  private var startPoint : CGPoint!
  private var endPoint : CGPoint!
  
  init(colors: [CGColor],cornerRadius : CGFloat,startPoint : CGPoint, endPoint : CGPoint) {
    self.colors = colors
    self.cornerRadius = cornerRadius
    self.startPoint = startPoint
    self.endPoint = endPoint
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
    self.gradient.colors = colors
    self.gradient.cornerRadius = cornerRadius
    self.gradient.startPoint = startPoint
    self.gradient.endPoint = endPoint
    if self.gradient.superlayer == nil {
      self.layer.insertSublayer(self.gradient, at: 0)
    }
  }
}
