//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by Olga Dalton on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class LevelsController: ItemViewCtrl {
    
    // MARK: - Variables
    var levelOne: Scenario! //{
        
//        didSet {
//            
//            if let imageView = imageOne {
//                imageView.image = UIImage(named: levelOne.nome)
//            }
//            
//        }
//    }
    
    // MARK: - Variables
    var levelTwo: Scenario! //{
        
//        didSet {
//            
//            if let imageView = imageTwo {
//                imageView.image = UIImage(named: levelTwo.nome)
//            }
//            
//        }
//    }
    
    // MARK: - Variables
    var levelThree: Scenario! //{
        
//        didSet {
//            
//            if let imageView = imageThree {
//                imageView.image = UIImage(named: levelThree.nome)
//            }
//            
//        }
//    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var loadedScene : W1_Level_1!

    @IBOutlet weak var levelOneView: LevelView!
    @IBOutlet weak var levelTwoView: LevelView!
    @IBOutlet weak var levelThreeView: LevelView!
    
//    @IBOutlet var imageOne: UIImageView!
//    @IBOutlet weak var imageTwo: UIImageView!
//    @IBOutlet weak var imageThree: UIImageView!
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        levelOneView.background.image = UIImage(named: levelOne.nome)
        levelOneView.levelNumber.text = String( levelOne.levelNumber )
        
        levelTwoView.background.image = UIImage(named: levelTwo.nome)
        levelTwoView.levelNumber.text = String( levelTwo.levelNumber )

        levelThreeView.background.image = UIImage(named: levelThree.nome)
        levelThreeView.levelNumber.text = String( levelThree.levelNumber )

        
        var tapGesture1 = UITapGestureRecognizer(target: self, action: Selector("levelTap1:"))
        levelOneView.addGestureRecognizer(tapGesture1)
        
        var tapGesture2 = UITapGestureRecognizer(target: self, action: Selector("levelTap2:"))
        levelTwoView.addGestureRecognizer(tapGesture2)
        
        var tapGesture3 = UITapGestureRecognizer(target: self, action: Selector("levelTap3:"))
        levelThreeView.addGestureRecognizer(tapGesture3)
        
        
        
        
        //imageTwo.addGestureRecognizer(tapGesture)
        //imageThree.addGestureRecognizer(tapGesture)

        
        
//        W1_Level_1.loadSceneAssetsWithCompletionHandler() { loadedScene in
//         self.loadedScene = loadedScene
//        
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        levelOneView.scrollView.frame = CGRectMake(0, 0, levelTwoView.frame.width*2, levelTwoView.frame.height)
        levelTwoView.scrollView.frame = CGRectMake(0, 0, levelTwoView.frame.width*2, levelTwoView.frame.height)
        levelThreeView.scrollView.frame = CGRectMake(0, 0, levelTwoView.frame.width*2, levelTwoView.frame.height)
        


    }
    
    override func viewWillAppear(animated: Bool) {
        checkAll()

    }
    
    
    
    func checkAll(){
        checkEnded(levelOne, levelView: levelOneView)
        checkEnded(levelTwo, levelView: levelTwoView)
        checkEnded(levelThree, levelView: levelThreeView)
    }
    
    func checkEnded(levelScene : Scenario, levelView : LevelView) {
        

        
        if(levelScene.ended) {
            levelView.percentageCompleted.hidden = true
            levelView.ok.hidden = false
            levelView.lockedView.hidden = true
            levelView.molduraView.hidden = false
            levelView.levelNumber.hidden = false


        }
        else {
            
            if levelScene.locked {
                
                levelView.percentageCompleted.hidden = true
                levelView.ok.hidden = true
                levelView.lockedView.hidden = false
                levelView.molduraView.hidden = true
                levelView.levelNumber.hidden = true

            }
            
            else {
                levelView.percentageCompleted.hidden = false
                levelView.percentageCompleted.text = String(levelScene.distanceRecord) + "%"
                levelView.ok.hidden = true
                levelView.lockedView.hidden = true
                levelView.molduraView.hidden = false
                levelView.levelNumber.hidden = false



            }
        }

        
    }
    
    func levelTap1(gestureRecognizer: UITapGestureRecognizer)
    {
        if(!levelOne.locked) {
            loadingIndicator.hidden = false
            loadLevel(levelOne)
        }
        
    }
    
    func levelTap2(gestureRecognizer: UITapGestureRecognizer)
    {
        if(!levelTwo.locked) {
            loadingIndicator.hidden = false
            loadLevel(levelTwo)
        }
        
    }
    
    func levelTap3(gestureRecognizer: UITapGestureRecognizer)
    {
        if(!levelThree.locked) {
            loadingIndicator.hidden = false
            loadLevel(levelThree)
        }
    }
    
    func loadLevel(level : Scenario){
        SceneManager.sharedInstance.playClickSound()

        var gVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        SceneManager.sharedInstance.gameViewCtrl = gVC
        
        W1_Level_1.loadSceneAssetsWithCompletionHandler(level) { loadedScene in
            
            self.loadingIndicator.hidden = true
            gVC.scene = loadedScene
            SceneManager.sharedInstance.scene = loadedScene
            
            self.presentViewController(gVC, animated: true, completion: nil)
        }
    }
    
    
    
}
