//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by Olga Dalton on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        contentImageView?.alpha = 0.4
        
        //let aSelector : Selector = “start”
        let tapGesture = UITapGestureRecognizer(target: self, action: "moveToLevels")
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        animateLogo()
    }
    
    func animateLogo() {
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | .Repeat | .Autoreverse, animations: {
            //self.logo.center = CGPointMake(self.logo.center.x + 200, self.logo.center.y)
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        
        
    }
    
    func moveToLevels(){
        self.menuViewController!.goToPage(1)
    }
   
    
    
}
