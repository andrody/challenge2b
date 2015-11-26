//
//  levelView.swift
//  Ninja Goo
//
//  Created by Andrew on 5/18/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import UIKit


class LevelView: UIView {


    @IBOutlet weak var view: UIView!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var levelNumber: UILabel!

    @IBOutlet weak var molduraView: UIImageView!
    
    @IBOutlet weak var percentageCompleted: UILabel!
    
    @IBOutlet weak var ok: UIImageView!
    
    @IBOutlet weak var lockedView: UIView!
    
    
    @IBOutlet weak var keyView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mask: UIImageView!
    
    @IBOutlet var unlockLabel: UILabel!
    
    @IBOutlet weak var buyButton: UIImageView!
    

    @IBOutlet weak var loadBuy: UIActivityIndicatorView!
    
    
    @IBOutlet weak var loadLevelSpin: UIActivityIndicatorView!
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //let className = NSStringFromClass(levelView.self)
        self.view = (NSBundle.mainBundle().loadNibNamed("LevelView", owner:self, options:nil).first) as! UIView
        
        self.addSubview(self.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideLoad", name: "unlockedLevel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideLoad", name: "hideLoad", object: nil)


        

        view.translatesAutoresizingMaskIntoConstraints = false

        let constX = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.addConstraint(constX)
        
        let constX2 = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.addConstraint(constX2)
        
        let constTop = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.addConstraint(constTop)
        
        let constBottom = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(constBottom)


        let tapGesture1 = UITapGestureRecognizer(target: self, action: Selector("key:"))
        keyView.addGestureRecognizer(tapGesture1)
        
        let buyObserver = UITapGestureRecognizer(target: self, action: Selector("buyKey"))
        buyButton.addGestureRecognizer(buyObserver)//Botao para comprar

        
        let color = UIColor(red: 252/255, green: 249/255, blue: 172/255, alpha: 1.0)
        unlockLabel.textColor = color
        buyButton.image = buyButton.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        buyButton.tintColor = color

        loadBuy.hidden = true
        loadLevelSpin.hidden = true


    }
    
    func key(gestureRecognizer: UITapGestureRecognizer){
        SceneManager.sharedInstance.playClickSound()

//        levelTwoView.unlockLabel.center = CGPointMake(0, levelTwoView.scrollView.frame.height - 100);

        var sobe: CGFloat = 150
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            sobe = 100
        }
        scrollView.setContentOffset(CGPointMake(0, sobe), animated: true)
//        mask.frame = CGRectMake( scrollView.frame.width/2, scrollView.frame.height, 100, 100 );

    }
    
    func buyKey(){
        SceneManager.sharedInstance.playClickSound()

        SceneManager.sharedInstance.buyKey()
        loadBuy.hidden = false
    }
    
    func hideLoad() {
        loadBuy.hidden = true
    }
    
    

}
