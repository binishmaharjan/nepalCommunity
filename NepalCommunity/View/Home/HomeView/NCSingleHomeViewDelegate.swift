//
//  NCSingleHomeViewDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/06.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit


//Single Home View
protocol NCSingleHomeViewDelegate{
  func cellWasTapped(article : NCArticle, user: NCUser)
  func menuButtonWasPressed(article : NCArticle)
}

protocol NCSingleToPagerDelegate{
  func passSingleToDelegate(article:NCArticle, user : NCUser)
  func menuButtonWasPressed(article : NCArticle)
}

protocol NCPagerToHomeDelegate{
  func passPagerToHome(article:NCArticle, user :NCUser)
  func menuButtonWasPressed(article : NCArticle)
}

protocol NCArticleCellToSingleHomeDelegate{
  func passArticleAndUser(article: NCArticle, user: NCUser)
  func menuButtonWasPressed(article : NCArticle)
}



//Image
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

