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


    }

}
