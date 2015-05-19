//
//  levelView.swift
//  Ninja Goo
//
//  Created by Andrew on 5/18/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import UIKit

class levelView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var levelNumber: UILabel!

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
        self.view = (NSBundle.mainBundle().loadNibNamed("levelView", owner:self, options:nil).first) as! UIView
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

        

    }

}
