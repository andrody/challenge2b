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
        let minD :CGFloat = W1_Level_1.Constants.minForce
        let maxForce :CGFloat = W1_Level_1.Constants.maxForce * SceneManager.sharedInstance.scene.worldScale
        let maxD : CGFloat = W1_Level_1.Constants.maxDistanceSlide
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
        
        fSX = (fSX * maxForce / maxD)
        
//        if(fSX > 0){
//            if(fSX < minD){
//                fSX = minD
//            }
//        }
//
//        if(fSX < 0){
//            if(fSX > -minD){
//                fSX = -minD
//            }
//        }
        
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
        
        fSY = (fSY * maxForce / maxD)

        if(fSY > 0){
            if(fSY < minD){
                fSY = minD
            }
        }
        
        if(fSY < 0){
            if(fSY > -minD){
                fSY = -minD
            }
        }
        
//        var totalPower : CGFloat
//                
//        do {
//            
//            totalPower = sqrt(pow(fSX, 2) + pow(fSY, 2))
//
//            if fSX < 0 { fSX += 2 }
//            else { fSX -= 2 }
//
//            if fSY < 0 { fSY += 2 }
//            else { fSY -= 2 }
//            
//        }while(totalPower > W1_Level_1.Constants.maxForceGeral)
        
        return (fSX, fSY)
        
        
    }
    
}