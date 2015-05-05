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
    var imageOneName: String = "" {
        
        didSet {
            
            if let imageView = imageOne {
                imageView.image = UIImage(named: imageOneName)
            }
            
        }
    }
    
    // MARK: - Variables
    var imageTwoName: String = "" {
        
        didSet {
            
            if let imageView = imageTwo {
                imageView.image = UIImage(named: imageTwoName)
            }
            
        }
    }
    
    // MARK: - Variables
    var imageThreeName: String = "" {
        
        didSet {
            
            if let imageView = imageThree {
                imageView.image = UIImage(named: imageThreeName)
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
        imageOne.image = UIImage(named: imageOneName)
        imageTwo.image = UIImage(named: imageTwoName)
        imageThree.image = UIImage(named: imageThreeName)

        
        
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
        loadLevel(imageOneName)
        
    }
    
    func levelTap2(gestureRecognizer: UITapGestureRecognizer)
    {
        
        loadingIndicator.hidden = false
        loadLevel(imageTwoName)
        
    }
    
    func levelTap3(gestureRecognizer: UITapGestureRecognizer)
    {
        
        loadingIndicator.hidden = false
        loadLevel(imageThreeName)
        
    }
    
    func loadLevel(levelName : String){
        
        var gVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        
        W1_Level_1.loadSceneAssetsWithCompletionHandler(levelName) { loadedScene in
            
            self.loadingIndicator.hidden = true
            gVC.scene = loadedScene
            
            self.presentViewController(gVC, animated: true, completion: nil)
        }
    }
    
}
