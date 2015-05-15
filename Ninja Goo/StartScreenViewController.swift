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
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet var contentImageView: UIImageView?
    @IBOutlet weak var tapToPlay: UIImageView!
    @IBOutlet weak var constraintDeCima: NSLayoutConstraint!
    @IBOutlet weak var contrintDeBaixo: NSLayoutConstraint!
    //@IBOutlet weak var larguraIgual: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tapToPlay.bringSubviewToFront(logo)
        //logo.removeConstraint(larguraIgual)

        contentImageView!.image = UIImage(named: imageName)
        //contentImageView?.alpha = 0.4
        
        //let aSelector : Selector = “start”
        let tapGesture = UITapGestureRecognizer(target: self, action: "moveToLevels")
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        animateTaptoPlay()
        animateLogo()

    }
    
    func animateLogo() {
        
        self.view.layoutIfNeeded()
        
        
//        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
//            
//            self.constrintDeCima.constant = 150
//            self.contrintDeBaixo.constant = 150
//            
//    
//        }
//        else{
//            self.constrintDeCima.constant = 180
//            self.contrintDeBaixo.constant = 200
//            
//        }
        
        //self.constrintDeCima.constant = self.constrintDeCima.constant + 100
        
        
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | .Repeat | .Autoreverse, animations: {
            
            

            self.constraintDeCima.constant = self.constraintDeCima.constant + 5
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
   
    
    
}
