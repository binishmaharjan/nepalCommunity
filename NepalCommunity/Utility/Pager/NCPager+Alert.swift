//
//  NCPager+Alert.swift
//  NepalCommunity
//
//  Created by guest on 2019/01/30.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit

extension NCPager{
  func showAlert(messsage:String?, ok:(()->Void)?) {
    let ac = UIAlertController(title: nil, message: messsage, preferredStyle: .alert)
    let okBtn = UIAlertAction(title: "OK", style: .default) { (action) in
      ok?()
    }
    ac.addAction(okBtn)
    present(viewController: ac)
  }
  
  func showConfirm(messsage:String?, ok:(()->Void)?, cancel:(()->Void)?) {
    let ac = UIAlertController(title: nil, message: messsage, preferredStyle: .alert)
    let okBtn = UIAlertAction(title: "OK", style: .default) { (action) in
      ok?()
    }
    ac.addAction(okBtn)
    let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      cancel?()
    }
    ac.addAction(cancelBtn)
    present(viewController: ac)
  }
}
