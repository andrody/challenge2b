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
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //let className = NSStringFromClass(levelView.self)
        self.view = (NSBundle.mainBundle().loadNibNamed("LevelView", owner:self, options:nil).first) as! UIView
        
        self.addSubview(self.view)
        
        
        

        view.setTranslatesAutoresizingMaskIntoConstraints(false)

        var constX = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.addConstraint(constX)
        
        var constX2 = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.addConstraint(constX2)
        
        var constTop = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.addConstraint(constTop)
        
        var constBottom = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self as UIView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(constBottom)


        var tapGesture1 = UITapGestureRecognizer(target: self, action: Selector("key:"))
        keyView.addGestureRecognizer(tapGesture1)
        
        let color = UIColor(red: 252/255, green: 249/255, blue: 172/255, alpha: 1.0)
        unlockLabel.textColor = color
        buyButton.image = buyButton.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        buyButton.tintColor = color


    }
    
    func key(gestureRecognizer: UITapGestureRecognizer){
        
//        levelTwoView.unlockLabel.center = CGPointMake(0, levelTwoView.scrollView.frame.height - 100);

        scrollView.setContentOffset(CGPointMake(0, 100), animated: true)
//        mask.frame = CGRectMake( scrollView.frame.width/2, scrollView.frame.height, 100, 100 );

    }

}
