//
//  NCPageViewController.swift
//  NepalCommunity
//
//  Created by guest on 2018/11/16.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCPageViewController : UIPageViewController{
  
  //MARK: View Controllers
  private var pages: [UIViewController] = [UIViewController]()
  
  //Menu Bar
  var homeTop : NCHomeTopView?
  
  //Current index
  var currentIndex : Int = 0
  //Previous index
  var previousIndex : Int = 0
  
  //Parent Controller
  var parentVC : NCHomeController?
  
  //Flag to scroll the Menu bar
  var shouldScrollMenuBar : Bool = true
  
  //MARK: Default Initializers
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: Default Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Delegate and Datasource
    self.dataSource = self
    self.delegate = self
    
    
    let view1 = NCSingleHomeController()
    view1.view.backgroundColor = NCColors.white
    view1.view.tag = 0
    
    let view2 = NCSingleHomeController()
    view2.view.backgroundColor = NCColors.white
    view2.view.tag = 1
    
    let view3 = NCSingleHomeController()
    view3.view.backgroundColor = NCColors.white
    view3.view.tag = 2
    
    let view4 = NCSingleHomeController()
    view4.view.backgroundColor = NCColors.white
    view4.view.tag = 3
    
    let view5 = NCSingleHomeController()
    view5.view.backgroundColor = NCColors.white
    view5.view.tag = 4
    
    let view6 = NCSingleHomeController()
    view6.view.backgroundColor = NCColors.white
    view6.view.tag = 5
    
    
    self.pages.append(view1)
    self.pages.append(view2)
    self.pages.append(view3)
    self.pages.append(view4)
    self.pages.append(view5)
    self.pages.append(view6)
    
    self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    
    setupScrollView()
  }
  
  /*
   Getting the scroll view from the pageviewController and saving as variable
   to keep track of the movement of the scroll with delegate(to move the menu bar
   along with the scroll view)
 */
  private func setupScrollView() {
    let scrollView = view.subviews.compactMap { $0 as? UIScrollView }.first
    scrollView?.scrollsToTop = false
    scrollView?.delegate = self
    scrollView?.backgroundColor = UIColor.lightGray
  }
  
}

//MARK: Delegate and DataSource
extension NCPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.index(of: viewController) {
      if viewControllerIndex == 0 {
        // wrap to last page in array
        //return self.pages.last
        return nil
      } else {
        // go to previous page in array
        return self.pages[viewControllerIndex - 1]
      }
    }
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.index(of: viewController) {
      if viewControllerIndex < self.pages.count - 1 {
        // go to next page in array
       
        
        return self.pages[viewControllerIndex + 1]
      } else {
        // wrap to first page in array
        return nil
      }
    }
    return nil
  }
  
  /*
   After transititon is complete changing the index of the current page.
   since pageview doesnt have index of current view by default
   we add the tag to  each view of the view controller and get
   the tag and recognize the current view that has been displayed
 */
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed{
      let index : Int = pageViewController.viewControllers?.first?.view.tag ?? 0
      previousIndex = currentIndex
      currentIndex = index
      Dlog(currentIndex)
    }
  }
  
  
  func menuBarMenuWasPresssed(at index : Int){
    self.shouldScrollMenuBar = false
    previousIndex = currentIndex
    self.currentIndex = index
    //homeTop!.menuBar?.menuBarX = (CGFloat(currentIndex) * UIScreen.main.bounds.width / 4)
    setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
  }
}



extension NCPageViewController: UIScrollViewDelegate{
  /*
   Delegate method to keep track of the movement of the scroll view
   Note : UIPageviewController scroll is three time the screen size
   since UIPageviewController prepares three view controller every
   time user swipes.The new view comes to the center and previous view to
   left and next view to right.
 */
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if shouldScrollMenuBar{
      /*
       Getting the contentOffset.x from the scroll view and substracting the
       (scrollView.contentSize.width / 3) since UIPageviewController scroll is
       three time the screen size and the current screen displayed is in the middle
       of the scrollview.So, contentOffset.x always starts with 375 and ends with 750.
       Once swiped the new vc becomes the middle view and the scroll view is reset to 375.
       So substacting the (scrollView.contentSize.width / 3) starts the offset from 0
       instead of the 375.
       */
      let scrollX = scrollView.contentOffset.x - (scrollView.contentSize.width / 3)
      /*
       After getting the total amount of the scrolled x value, we divide it by the
       number of tabs displayed in screen(in this case 4), exactly giving us the starting point for the
       menu bar
       */
      let menuX = scrollX / 4
      
      guard let homeTop = self.homeTop else { return }
      if menuX != 0 {
        /*
         Calculating the current point of the menu bar with the
         help of the scrollview Content offset
         */
        let a = (CGFloat(currentIndex) * UIScreen.main.bounds.width / 4) + menuX
        
        //Changing the left constarints of the menu bar
        parentVC?.menuBarXFromPageView = a
        
        //Chaning the offset of collectionview, when swiping backwards to lower index
        if a <= (UIScreen.main.bounds.width / 4) * 2{
          if previousIndex > currentIndex && currentIndex != 0{
            parentVC?.homeTop?.menuBar?.collectionView?.contentOffset.x = a
          }
        }
        
        //Chaning the offset of collectionview, when swiping forward to higher index
        if a >= (UIScreen.main.bounds.width / 4) * 3{
          if currentIndex >=  3 && previousIndex < currentIndex && currentIndex != 5{

            parentVC?.homeTop?.menuBar?.collectionView?.contentOffset.x = (a - (UIScreen.main.bounds.width / 4) * 3)

          }
        }
        
        
        
      }
    }
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.shouldScrollMenuBar = true
  }
}

