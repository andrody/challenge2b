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
    var levelOne: Scenario! {
        
        didSet {
            
            if let imageView = imageOne {
                imageView.image = UIImage(named: levelOne.nome)
            }
            
        }
    }
    
    // MARK: - Variables
    var levelTwo: Scenario! {
        
        didSet {
            
            if let imageView = imageTwo {
                imageView.image = UIImage(named: levelTwo.nome)
            }
            
        }
    }
    
    // MARK: - Variables
    var levelThree: Scenario! {
        
        didSet {
            
            if let imageView = imageThree {
                imageView.image = UIImage(named: levelThree.nome)
            }
            
        }
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var loadedScene : W1_Level_1!

    @IBOutlet var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageOne.image = UIImage(named: levelOne.nome)
        imageTwo.image = UIImage(named: levelTwo.nome)
        imageThree.image = UIImage(named: levelThree.nome)

        
        
        var tapGesture1 = UITapGestureRecognizer(target: self, action: Selector("levelTap1:"))
        imageOne.addGestureRecognizer(tapGesture1)
        
        var tapGesture2 = UITapGestureRecognizer(target: self, action: Selector("levelTap2:"))
        imageTwo.addGestureRecognizer(tapGesture2)
        
        var tapGesture3 = UITapGestureRecognizer(target: self, action: Selector("levelTap3:"))
        imageThree.addGestureRecognizer(tapGesture3)
        
        
        //imageTwo.addGestureRecognizer(tapGesture)
        //imageThree.addGestureRecognizer(tapGesture)

        
        
//        W1_Level_1.loadSceneAssetsWithCompletionHandler() { loadedScene in
//         self.loadedScene = loadedScene
//        
//        }
        
    }
    
    
    func levelTap1(gestureRecognizer: UITapGestureRecognizer)
    {
        
        loadingIndicator.hidden = false
        loadLevel(levelOne)
        
    }
    
    func levelTap2(gestureRecognizer: UITapGestureRecognizer)
    {
        
        loadingIndicator.hidden = false
        loadLevel(levelTwo)
        
    }
    
    func levelTap3(gestureRecognizer: UITapGestureRecognizer)
    {
        
        loadingIndicator.hidden = false
        loadLevel(levelThree)
        
    }
    
    func loadLevel(level : Scenario){
        
        var gVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        
        W1_Level_1.loadSceneAssetsWithCompletionHandler(level) { loadedScene in
            
            self.loadingIndicator.hidden = true
            gVC.scene = loadedScene
            
            self.presentViewController(gVC, animated: true, completion: nil)
        }
    }
    
}
