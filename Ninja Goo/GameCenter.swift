//
//  GameCenter.swift
//  Ninja Goo
//
//  Created by Andrew on 3/31/15.
//  Copyright (c) 2015 Koruja Studios. All rights reserved.
//

import GameKit

enum Ranks: String {
    case levelone = "levelone"
    case leveltwo = "leveltwo"
    case levelthree = "levelthree"
    case levelfour = "levelfour"
    case levelfive = "levelfive"
    case levelsix = "levelsix"

    
}


class GameCenter : NSObject, GKGameCenterControllerDelegate {
    
    
    override init(){
        
        super.init()
        
    }
    
    
    //initiate gamecenter
    func authenticateLocalPlayer(viewCtrl : UIViewController){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                viewCtrl.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    
    //send high score to leaderboard
    func saveHighscore(score:Int, leaderboard : Ranks) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: leaderboard.rawValue) //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
            
        }
        
    }
    
    
    //shows leaderboard screen
    func showLeader(viewCtrl : UIViewController) {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        viewCtrl.presentViewController(gc, animated: true, completion: nil)
    }


    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
}