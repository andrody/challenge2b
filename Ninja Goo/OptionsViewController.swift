//
//  OptionsViewController.swift
//  Ninja Goo
//
//  Created by Bruno Rolim on 27/05/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import StoreKit


class OptionsViewController: UIViewController {

    
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var soundButton: UIImageView!
    
    @IBOutlet weak var restoreButton: UIImageView!
    
    @IBOutlet weak var info: UIImageView!
    @IBOutlet weak var removeAdView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "adRemoved", name: "removeadd", object: nil)

        var removeAd = UITapGestureRecognizer(target: self, action: Selector("removeAd"))
        removeAdView.addGestureRecognizer(removeAd)
        
        var backGesture = UITapGestureRecognizer(target: self, action: Selector("backbutton"))
        backButton.addGestureRecognizer(backGesture)
        
        var sound = UITapGestureRecognizer(target: self, action: Selector("muteSound"))
        soundButton.addGestureRecognizer(sound)
        
        var restore = UITapGestureRecognizer(target: self, action: Selector("checkRestore"))
        restoreButton.addGestureRecognizer(restore)
        
                if SceneManager.sharedInstance.soundMuted {
                    soundButton.alpha = 0.5
//                    soundButton.image = UIImage(named: "sound-muted")
                }
        
        if(!SceneManager.sharedInstance.shouldShowAd) {
            adRemoved()
        }
        
    }
    
    func removeAd(){
        SceneManager.sharedInstance.playClickSound()
        SceneManager.sharedInstance.buyRemoveAds()
    }
    
    func adRemoved() {
        self.removeAdView.userInteractionEnabled = false
        self.removeAdView.alpha = 0.5
    }
   
    
    func backbutton(){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        println("BACK TO MEnu")
    }
    
    func muteSound() {
    
        SceneManager.sharedInstance.playClickSound()
    
    
    
        if(SceneManager.sharedInstance.soundMuted){
            //soundButton.image = UIImage(named: "sound")
            soundButton.alpha = 1.0
            SceneManager.sharedInstance.soundMuted = false
        }
        else {
            //soundButton.image = UIImage(named: "sound-muted")
            soundButton.alpha = 0.5
            SceneManager.sharedInstance.soundMuted = true
        }
    
        SceneManager.sharedInstance.playMusic(SceneManager.sharedInstance.backGroundMusic)
    
            
            
    }
    
    
    func checkRestore(){
    
        if(restorePurchases() == true) {
            
            println("transação efetuada")

        }
    }
    
    func restorePurchases() -> Bool{
    
        
       // SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    
    return true
    }
}

