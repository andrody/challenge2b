//
//  GameCenter.swift
//  Ninja Goo
//
//  Created by Andrew on 3/31/15.
//  Copyright (c) 2015 Koruja Studios. All rights reserved.
//

import GameKit

class GameCenter : NSObject, GKGameCenterControllerDelegate {
    
    var scene : SceneTesteUm?
    
    init(scene1 : SceneTesteUm){
        
        super.init()
        self.scene = scene1

        authenticateLocalPlayer()
        
    }
    
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.scene?.view?.window?.rootViewController!.presentViewController(viewController, animated: true, completion: nil)
            }
                
            else {
                println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    
    //send high score to leaderboard
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "ningooleaderboard") //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            
        }
        
    }
    
    
    //shows leaderboard screen
    func showLeader() {
        var vc = self.scene?.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }


    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
}