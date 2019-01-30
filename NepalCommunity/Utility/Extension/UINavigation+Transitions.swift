//
//  UINavigation+Transitions.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/30.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit

extension UINavigationController {
  public func pushViewController(_ viewController: UIViewController,
                                 animated: Bool,
                                 completion:@escaping (()->())) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    pushViewController(viewController, animated: animated)
    CATransaction.commit()
  }
  
  public func popViewController(animated: Bool,
                                completion:(()->())?) {
    guard let completion = completion else { popViewController(animated: animated); return }
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    popViewController(animated: animated)
    CATransaction.commit()
  }
  
  public func popToRootViewController(animated: Bool,
                                      completion:(()->())?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    popToRootViewController(animated: animated)
    CATransaction.commit()
  }
}
