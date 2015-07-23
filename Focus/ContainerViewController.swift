//
//  ContainerViewController.swift
//  Focus
//
//  Created by Shuo Tong on 6/30/15.
//  Copyright (c) 2015 Shuo Tong. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var menuContainerView: UIView!
  @IBOutlet weak var detailContainerView: UIView!
  
  var findNavigationController = UIStoryboard.findNavigationController()
  
  var menuItem: NSDictionary? {
    didSet {
      hideOrShowMenu(false, animated: true)
      
    }
  }
  
  var showingMenu = false
  
  func hideOrShowMenu(show: Bool, animated: Bool) {
    let xOffset = CGRectGetWidth(menuContainerView.bounds)
    scrollView.setContentOffset(show ? CGPointZero : CGPointMake(xOffset, 0), animated: animated)
    showingMenu = show
  }
  
  override func viewDidLoad() {
    
    addChildViewController(findNavigationController!)
    findNavigationController!.didMoveToParentViewController(self)
    detailContainerView.addSubview(findNavigationController!.view)
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    menuContainerView.layer.anchorPoint = CGPointMake(1.0, 0.5)
    hideOrShowMenu(showingMenu, animated: false)
    
  }
  
  func transformForFraction(fraction:CGFloat) -> CATransform3D {
    var identity = CATransform3DIdentity
    identity.m34 = -1.0 / 1000.0;
    let angle = Double(1.0 - fraction) * -M_PI_2
    let xOffset = CGRectGetWidth(menuContainerView.bounds) * 0.5
    let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
    let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
    return CATransform3DConcat(rotateTransform, translateTransform)
  }
  
}

extension ContainerViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(scrollView: UIScrollView) {
    let multiplier = 1.0 / CGRectGetWidth(menuContainerView.bounds)
    let offset = scrollView.contentOffset.x * multiplier
    let fraction = 1.0 - offset
    println("didScroll offset \(offset)")
    menuContainerView.layer.transform = transformForFraction(fraction)
    menuContainerView.alpha = fraction
    
    if let findNavigationController = findNavigationController {
      if let findViewController = findNavigationController.childViewControllers[0] as? FindTableViewController  {
        if let rotatingView = findViewController.hamburgerView {
          rotatingView.rotate(fraction)
        }
      }
      
    }
    
    /*
    Fix for the UIScrollView paging-related issue mentioned here:
    http://stackoverflow.com/questions/4480512/uiscrollview-single-tap-scrolls-it-to-top
    */
    scrollView.pagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))
    
    let menuOffset = CGRectGetWidth(menuContainerView.bounds)
    showingMenu = !CGPointEqualToPoint(CGPoint(x: menuOffset, y: 0), scrollView.contentOffset)
    println("didEndDecelerating showingMenu \(showingMenu)")
  }
  
}


