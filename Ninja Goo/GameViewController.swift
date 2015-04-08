//
//  GameViewController.swift
//  Ninja Goo
//
//  Created by Andrew on 4/2/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    
    var scene: W1_Level_1!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = SKColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        W1_Level_1.loadSceneAssetsWithCompletionHandler(self.skView) { loadedScene in
            
            self.scene = loadedScene
            self.scene.scaleMode = .AspectFill
            
            //#if DEBUG
                self.skView.showsDrawCount = true
                self.skView.showsNodeCount = true

                self.skView.showsFPS = true
                self.skView.showsPhysics = true
            //#endif
            
            //self.skView.backgroundColor = SKColor(red: 229, green: 233, blue: 248, alpha: 1)
            loadedScene.backgroundColor = SKColor(red: 229.0/255.0, green: 233.0/255.0, blue: 248.0/255.0, alpha: 1)


            
            
            self.skView.presentScene(self.scene!)
            //skView.presentScene(scene, transition: SKTransition.fadeWithColor(SKColor(red: 25.0/255.0, green: 55.0/255.0, blue: 12.0/255.0, alpha: 1), duration: 1.0))
        }
    }


 

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
