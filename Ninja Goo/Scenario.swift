//
//  Scenario.swift
//  Ninja Goo
//
//  Created by Andrew on 5/14/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//


import UIKit
import SpriteKit

enum Saves: String {
    case maxDistance = "maxDistancia"
    case ended = "ended"
    case locked = "locked"
    case unlockable = "unlockable"
    case attempts = "attempts"


}


class Scenario {
    
    var nome : String!
    var levelNumber : Int!
    var corMontanha : [CGFloat]
    var corMontanhaClara : [CGFloat]
    var corNuvemBack : [CGFloat]
    var corNuvemMeio : [CGFloat]
    var corNuvemFront : [CGFloat]
    var corPlataforma : [CGFloat]
    var corFundo : [CGFloat]
    var corWallEspecial : [CGFloat]
    var backgroundFrontName : String!
    var backgroundBackName : String!


    var distanceRecord : Int {
        get {
            var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey(self.nome + Saves.maxDistance.rawValue) as? Int
            if returnValue == nil //Check for first run of app
            {
                returnValue = 0 //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save(self.nome + Saves.maxDistance.rawValue, value: newValue)
        }
    }
    
    var attempts : Int {
        get {
            var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey(self.nome + Saves.attempts.rawValue) as? Int
            if returnValue == nil //Check for first run of app
            {
                returnValue = 0 //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save(self.nome + Saves.attempts.rawValue, value: newValue)
        }
    }


    var ended : Bool {
        get {
            var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey(self.nome + Saves.ended.rawValue) as? Bool
            if returnValue == nil //Check for first run of app
            {
                returnValue = false //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save(self.nome + Saves.ended.rawValue, value: newValue)
        }
    }
    
    var locked : Bool {
        get {
            var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey(self.nome + Saves.locked.rawValue) as? Bool
            if returnValue == nil //Check for first run of app
            {
                returnValue = true //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save(self.nome + Saves.locked.rawValue, value: newValue)
        }
    }
    
    var unlockable : Bool {
        get {
            var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey(self.nome + Saves.unlockable.rawValue) as? Bool
            if returnValue == nil //Check for first run of app
            {
                returnValue = false //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save(self.nome + Saves.unlockable.rawValue, value: newValue)
        }
    }
    
    



    
    init(nome : String, levelNumber : Int, corMontanha : [CGFloat], corMontanhaClara : [CGFloat], corNuvemBack : [CGFloat], corNuvemMeio : [CGFloat], corNuvemFront : [CGFloat], corPlataforma : [CGFloat], corFundo : [CGFloat], corWallEspecial : [CGFloat], backgroundFrontName : String,  backgroundBackName : String) {
        
        self.nome = nome
        self.levelNumber = levelNumber
        self.corMontanha = corMontanha
        self.corMontanhaClara = corMontanhaClara
        self.corNuvemBack = corNuvemBack
        self.corNuvemMeio = corNuvemMeio
        self.corNuvemFront = corNuvemFront
        self.corPlataforma = corPlataforma
        self.corFundo = corFundo
        self.corWallEspecial = corWallEspecial
        self.backgroundBackName = backgroundBackName
        self.backgroundFrontName = backgroundFrontName
        
    }

}