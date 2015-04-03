//
//  ConvertUtilities.swift
//  Ninja Goo
//
//  Created by Andrew on 4/2/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import UIKit

class ConvertUtilities {
    
    class func degreesToRadians(degrees : CGFloat) -> CGFloat {
        return CGFloat(degrees * CGFloat(M_PI) / 180)
    }
    
    class func radiansToDegree(radian : CGFloat) -> CGFloat {
        return CGFloat(radian / CGFloat(M_PI) * 180)
    }
    
    class func minMaxSpeed(sX : CGFloat, sY : CGFloat) -> (CGFloat,CGFloat) {
        var minD :CGFloat = 20.0
        var maxD : CGFloat = 100.0
        var fSX : CGFloat = sX
        var fSY : CGFloat = sY
        
        //For X
        if(sX > 0){
            
            if(sX < minD){
                fSX = minD
            }
            else if(sX > maxD) {
                fSX = maxD
            }
            
        }
            
        else if(sX < 0){
            
            if(sX > -minD){
                fSX = -minD
            }
            else if(sX < -maxD) {
                fSX = -maxD
            }
            
        }
        
        //For Y
        if(sY > 0){
            
            if(sY < minD){
                fSY = minD
            }
            else if(sY > maxD) {
                fSY = maxD
            }
            
        }
            
        else if(sY < 0){
            
            if(sY > -minD){
                fSY = -minD
            }
            else if(sY < -maxD) {
                fSY = -maxD
            }
            
        }
        
        return (fSX, fSY)
        
        
    }
    
}