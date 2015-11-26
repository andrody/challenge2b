//
//  GameViewController.swift
//  Ninja Goo
//
//  Created by Andrew on 4/2/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import UIKit
import SpriteKit
import Darwin

class MenuViewController: UIViewController, UIPageViewControllerDataSource {
    
    var startScreenCtrl : StartScreenViewController!
    var levelControllers : [LevelsController]! = []
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // Initialize it right away here
    private var contentImages = [["fundoMenu"],
        [SceneManager.sharedInstance.fases[0], SceneManager.sharedInstance.fases[1], SceneManager.sharedInstance.fases[2]],
        [SceneManager.sharedInstance.fases[3], SceneManager.sharedInstance.fases[4], SceneManager.sharedInstance.fases[5]]
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        SceneManager.sharedInstance.playMusic(SceneManager.sharedInstance.backGroundMusic)
    }
    
   
    private func createPageViewController() {
        
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            preLoadLevelControllers()
            startScreenCtrl = getStartSItemController()
            let startingViewControllers: NSArray = [startScreenCtrl]
            //startingViewControllers.arrayByAddingObjectsFromArray(levelControllers)
            pageController.setViewControllers(startingViewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    func preLoadLevelControllers() {
        for (itemIndex, item) in contentImages.enumerate() {
            if(itemIndex == 0) {
                continue
            }
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("LevelsController") as! LevelsController
            pageItemController.itemIndex = itemIndex - 1
            pageItemController.levelOne = (contentImages[itemIndex][0] as! Scenario)
            pageItemController.levelTwo = (contentImages[itemIndex][1] as! Scenario)
            pageItemController.levelThree = (contentImages[itemIndex][2] as! Scenario)
            let v = pageItemController.view
            
            self.levelControllers.append(pageItemController)
            
        }
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        
        let itemController = viewController as? ItemViewCtrl

        if itemController!.itemIndex > -1 {
            if(itemController!.itemIndex-1 == -1){
                return startScreenCtrl
            }
            return levelControllers[itemController!.itemIndex-1]
        }
        return nil

    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
//        var itemController = viewController as! ItemViewCtrl
//        
//        if itemController.itemIndex+1 < contentImages.count {
//            return getItemController(itemController.itemIndex+1)
//        }
//        
        let itemController = viewController as? ItemViewCtrl
        
        if itemController!.itemIndex < contentImages.count - 2 {
            return levelControllers[itemController!.itemIndex+1]
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> LevelsController? {
        
//      if itemIndex < contentImages.count {
//            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("LevelsController") as! LevelsController
//            pageItemController.itemIndex = itemIndex
//            pageItemController.levelOne = (contentImages[itemIndex][0] as! Scenario)
//            pageItemController.levelTwo = (contentImages[itemIndex][1] as! Scenario)
//            pageItemController.levelThree = (contentImages[itemIndex][2] as! Scenario)
//            return pageItemController
//        }
        if itemIndex < contentImages.count {
            return nil
        }

        
        return nil
    }
    
    private func getStartSItemController() -> StartScreenViewController? {
        
        if self.startScreenCtrl == nil {
            startScreenCtrl = self.storyboard!.instantiateViewControllerWithIdentifier("StartScreenViewCtrl") as! StartScreenViewController
            startScreenCtrl.itemIndex = -1
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                startScreenCtrl.imageName = "fundoMenuIphone"
            }
            else {
                startScreenCtrl.imageName = contentImages[0][0] as! String
            }
            startScreenCtrl.menuViewController = self
        }
        return startScreenCtrl
    }
    
    func goToPage() {
        
        var indexLevels = 1
        
        for (index, fase) in SceneManager.sharedInstance.fases.enumerate() {
            if(fase.locked) {
                let div : CGFloat = CGFloat(index-1)/3
                indexLevels = Int(floor(div))
                break
            }
        }
        
        let startingViewControllers: NSArray = [levelControllers[indexLevels]]
        self.pageViewController!.setViewControllers(startingViewControllers as! [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
    }

    
   
    
    // MARK: - Page Indicator
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return contentImages.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//    
//    override func shouldAutorotate() -> Bool {
//        return true
//    }
//    
//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
//    }
//    
    
    
    
    
}
