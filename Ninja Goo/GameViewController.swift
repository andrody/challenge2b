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
    
    var startAppAd: STAStartAppAd?

    
    @IBOutlet weak var skView: SKView!
    
    var scene: W1_Level_1!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAppAd = STAStartAppAd()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAd", name: "showAd", object: nil)


        //self.view.backgroundColor = SKColor(red: 255, green: 255, blue: 255, alpha: 1)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
//        W1_Level_1.loadSceneAssetsWithCompletionHandler() { loadedScene in
            //self.scene = loadedScene
            self.scene.scaleMode = .AspectFill
            
//                self.skView.showsDrawCount = true
//                self.skView.showsNodeCount = true
//                self.skView.showsPhysics = true;
//
//
//                self.skView.showsFPS = true
        
            
//            self.scene.backgroundColor = SKColor(red: 182.0/255.0, green: 217.0/255.0, blue: 241.0/255.0, alpha: 1)


            
            
            self.skView.presentScene(self.scene!)
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        startAppAd!.loadAd()

    }

    func backToMenu(){
        SceneManager.sharedInstance.faseEscolhida.backGroundMusic.stop()
        SceneManager.sharedInstance.playMusic(SceneManager.sharedInstance.backGroundMusic)
        //var vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        self.dismissViewControllerAnimated(true, completion: nil)
        println("BACK TO MEnu")

    }
    
    func showAd(){
        startAppAd!.showAd()
    }
 

//    override func shouldAutorotate() -> Bool {
//        return true
//    }
//
//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.All.rawValue)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    
    
    
  }
