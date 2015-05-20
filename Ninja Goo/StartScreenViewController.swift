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
    
    //var initialConstraintValue : CGFloat!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet var contentImageView: UIImageView?
    @IBOutlet weak var tapToPlay: UIImageView!
    @IBOutlet weak var constraintDeCima: NSLayoutConstraint!
    @IBOutlet weak var contrintDeBaixo: NSLayoutConstraint!
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

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        adjustConstraint()
        
        
        //self.initialConstraintValue = self.constraintDeCima.constant
        
        animateTaptoPlay()
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
    
    func animateLogo() {
        
        
        
        self.view.layoutIfNeeded()
        
        
       
//        else{
//            self.constrintDeCima.constant = 180
//            self.contrintDeBaixo.constant = 200
//            
//        }
        
        //self.constrintDeCima.constant = self.constrintDeCima.constant + 100
        
        
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | .Repeat | .Autoreverse, animations: {
            
            

            self.constraintDeCima.constant = self.constraintDeCima.constant + 20
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
    
    func animateTaptoPlay() {
        
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | .Repeat | .Autoreverse, animations: {
            
            
            self.tapToPlay.alpha = 0
            
            
            }, completion: nil)
        
        
        
    }

    
    func moveToLevels(){
        SceneManager.sharedInstance.playClickSound()
        self.menuViewController!.goToPage(1)
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
