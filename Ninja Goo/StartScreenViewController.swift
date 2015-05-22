//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by Olga Dalton on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit
import QuartzCore


class StartScreenViewController: ItemViewCtrl {
    
    // MARK: - Variables
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    var isAnimating = false
    
    //var initialConstraintValue : CGFloat!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet var contentImageView: UIImageView?
    @IBOutlet weak var tapToPlay: UIImageView!
    @IBOutlet weak var constraintDeCima: NSLayoutConstraint!
    @IBOutlet weak var contrintDeBaixo: NSLayoutConstraint!
    
    @IBOutlet weak var gameCenterButton: UIImageView!
    
    
    @IBOutlet weak var soundButton: UIImageView!
    
    //@IBOutlet weak var larguraIgual: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        self.tapToPlay.bringSubviewToFront(logo)
        //logo.removeConstraint(larguraIgual)

        contentImageView!.image = UIImage(named: imageName)
        //contentImageView?.alpha = 0.4
        
        //let aSelector : Selector = “start”
        let tapGesture = UITapGestureRecognizer(target: self, action: "moveToLevels")
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        SceneManager.sharedInstance.fases[0].locked = false
        SceneManager.sharedInstance.fases[1].unlockable = true
        
        SceneManager.sharedInstance.gameCenter.authenticateLocalPlayer(self)

        var gameCenterGesture = UITapGestureRecognizer(target: self, action: Selector("showGameCenter"))
        gameCenterButton.addGestureRecognizer(gameCenterGesture)
        
        var soundGesture = UITapGestureRecognizer(target: self, action: Selector("muteSound"))
        soundButton.addGestureRecognizer(soundGesture)

        if SceneManager.sharedInstance.soundMuted {
            soundButton.alpha = 0.5
            soundButton.image = UIImage(named: "sound-muted")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        //adjustConstraint()
        
        
        //self.initialConstraintValue = self.constraintDeCima.constant
        
        animateLogo()

    }
    
    func adjustConstraint(){
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            if(UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.PortraitUpsideDown){
                self.constraintDeCima.constant = 159
            }
            else {
                self.constraintDeCima.constant = 65
            }
        }
        else {
            self.constraintDeCima.constant = 65 + 125
        }
        
    }
    
    
    func showGameCenter() {
        SceneManager.sharedInstance.playClickSound()

        
        SceneManager.sharedInstance.gameCenter.showLeader(self)

        
    }
    
    func muteSound() {
        
        SceneManager.sharedInstance.playClickSound()

        
        if(SceneManager.sharedInstance.soundMuted){
            soundButton.image = UIImage(named: "sound")
            soundButton.alpha = 1.0
            SceneManager.sharedInstance.soundMuted = false
        }
        else {
            soundButton.image = UIImage(named: "sound-muted")
            soundButton.alpha = 0.5
            SceneManager.sharedInstance.soundMuted = true
        }
        
        
    }
    
    
    
    func animateLogo() {
        
        
        if(!isAnimating) {
            
            isAnimating = true
        self.view.layoutIfNeeded()
            animateTaptoPlay()

        
        
       
//        else{
//            self.constrintDeCima.constant = 180
//            self.contrintDeBaixo.constant = 200
//            
//        }
        
        //self.constrintDeCima.constant = self.constrintDeCima.constant + 100
        
        
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | .Repeat | .Autoreverse, animations: {
            
            

            self.constraintDeCima.constant = self.constraintDeCima.constant + 10
            //self.contrintDeBaixo.constant = self.contrintDeBaixo.constant + 100
            //self.constrintDeCima.constant = self.constrintDeCima.constant + 100
            //self.contrintDeBaixo.constant = self.contrintDeBaixo.constant - 100
            
            self.view.layoutIfNeeded()
            //self.logo.layer.anchorPoint = CGPointMake(0.5, 0.5)
           // self.logo.center = CGPointMake(self.logo.center.x, self.logo.center.y + 200)
            //self.view.layoutSubviews()
            //self.view.layer.anchorPoint = CGPointMake(0.5, 0.5)
            
            
            }, completion: nil)
        
        }
        
    }
    
    func animateTaptoPlay() {
        
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | .Repeat | .Autoreverse, animations: {
            
            
            self.tapToPlay.alpha = 0
            
            
            }, completion: nil)
        
        
        
    }

    
    func moveToLevels(){
        SceneManager.sharedInstance.playClickSound()
        self.menuViewController!.goToPage()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustConstraint()
        animateLogo()

    }
    
//    override func shouldAutorotate() -> Bool {
//        return false
//    }
//    
//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
//    }
//   
//    
    
}
