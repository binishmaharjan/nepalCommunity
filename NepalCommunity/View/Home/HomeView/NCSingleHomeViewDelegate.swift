//
//  NCSingleHomeViewDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/06.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation


protocol NCSingleHomeViewDelegate{
  func cellWasTapped(article : NCArticle)
}

protocol NCSingleToPagerDelegate{
  func passSingleToDelegate(article:NCArticle)
}

protocol NCPagerToHomeDelegate{
  func passPagerToHome(article:NCArticle)
}
