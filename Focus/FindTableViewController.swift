//
//  FindTableViewController.swift
//  Focus
//
//  Created by Shuo Tong on 7/2/15.
//  Copyright (c) 2015 Shuo Tong. All rights reserved.
//

import UIKit

class FindTableViewController: UITableViewController {

  let screenSize = UIScreen.mainScreen().bounds.size
  var hamburgerView: HamburgerView?
  var pagedImagesScrollView: UIScrollView!
  var pageControl: UIPageControl!
  
  var pageViews: [UIImageView?] = []
  var pageImages = [UIImage(named:"blackwidow0.png")!,
  UIImage(named:"blackwidow1.png")!,
  UIImage(named:"blackwidow2.png")!,
  UIImage(named:"blackwidow3.png")!,
  UIImage(named:"blackwidow4.png")!]
  
  lazy var personalInfo: NSDictionary = {
    let path = NSBundle.mainBundle().pathForResource("TestData", ofType: "plist")
    return NSDictionary(contentsOfFile: path!)!
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Remove the drop shadow from the navigation bar
    navigationController!.navigationBar.clipsToBounds = true
    
    tableView.contentInset = UIEdgeInsetsMake(screenSize.width, 0, 0, 0)
    loadHamburgerView()
    loadScrollView()
    
  }
  
  // MARK: load scroll view images.
  
  func loadScrollView() {
    
    pagedImagesScrollView = UIScrollView(frame: CGRectMake(0, -screenSize.width, screenSize.width, screenSize.width))
    pagedImagesScrollView.contentMode = UIViewContentMode.ScaleAspectFill
    pagedImagesScrollView.pagingEnabled = true
    pagedImagesScrollView.bounces = false
    pagedImagesScrollView.delegate = self
    tableView.addSubview(pagedImagesScrollView)
    
    let pageCount = pageImages.count
    
    pageControl = UIPageControl(frame: CGRectZero)
    pageControl.currentPage = 0
    pageControl.numberOfPages = pageCount
    
    for _ in 0..<pageCount {
      pageViews.append(nil)
    }
    
    let pagesScrollViewSize = pagedImagesScrollView.frame.size
    pagedImagesScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagedImagesScrollView.frame.height)
    
    loadPages()
  }
  
  func loadPages() {
    
    // First, determine which page is currently visible
    let pageWidth = pagedImagesScrollView.frame.size.width
    let page = Int(floor((pagedImagesScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    
    // Update the page control
    pageControl.currentPage = page
    
    // Work out which pages you want to load
    let firstPage = 0
    let lastPage = pageImages.count - 1
    
    // Load pages in our range
    for var index = firstPage; index <= lastPage; ++index {
      loadPage(index)
    }
  }

  func loadPage(page: Int) {
    
    if page < 0 || page >= pageImages.count {
      // If it's outside the range of what you have to display, then do nothing
      return
    }
    
    if let pageView = pageViews[page] {
      // Do nothing. The view is already loaded.
    } else {
      
      var frame = pagedImagesScrollView.bounds
      frame.origin.x = frame.size.width * CGFloat(page)
      frame.origin.y = 0.0
      
      let newPageView = UIImageView(image: pageImages[page])
      newPageView.contentMode = .ScaleAspectFill
      newPageView.frame = frame
      pagedImagesScrollView.addSubview(newPageView)
      
      pageViews[page] = newPageView
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  // MARK: load hamberger view.
  
  func loadHamburgerView() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hamburgerViewTapped")
    hamburgerView = HamburgerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    hamburgerView!.addGestureRecognizer(tapGestureRecognizer)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hamburgerView!)
  }
  
  func hamburgerViewTapped() {
    let navigationController = parentViewController as! UINavigationController
    let containerViewController = navigationController.parentViewController as! ContainerViewController
    containerViewController.hideOrShowMenu(!containerViewController.showingMenu, animated: true)
  }

  // MARK: UIScrollViewDelegate
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {

    if self.pagedImagesScrollView != nil {
      if scrollView == self.pagedImagesScrollView {
        loadPages()
      }
    }
    
    if scrollView == self.tableView {
    
      let y = tableView.contentOffset.y
      
      if (y < -screenSize.width) {
        
        self.pagedImagesScrollView.frame.origin.y = y
        self.pagedImagesScrollView.frame.size.height = -y
        let currentPage = pageControl.currentPage
        pageViews[currentPage]!.frame.size.height = -y
        
      }
    }
  }

}
