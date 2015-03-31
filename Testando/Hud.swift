//
//  Hud.swift
//  Testando
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 27/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import UIKit
import SpriteKit

class Hud: SKNode {
   
    let pointsBoard: SKLabelNode?
    let playButton: SKSpriteNode?
    let stageButton: SKSpriteNode?
    //let optionsButton: SKSpriteNode?
    let gamecenterButton: SKSpriteNode?
    let logo: SKSpriteNode?
    let pauseButton: SKSpriteNode?
    
    let sceneSize: CGSize?
    

    //POSITION
    var playButtonInScreemPosition: CGPoint?
    var playButtonOffScreemPosition: CGPoint?
    var logoButtonInScreemPosition: CGPoint?
    var logoButtonOffScreemPosition: CGPoint?
    var stageButtonInScreemPosition: CGPoint?
    var stageButtonOffScreemPosition: CGPoint?
    var pointsBoardButtonInScreemPosition: CGPoint?
    var pointsBoardButtonOffScreemPosition: CGPoint?
    var pauseButtonInScreemPosition: CGPoint?
    var pauseButtonOffScreemPosition: CGPoint?
    
    init(sceneSize: CGSize) {
        
        super.init()
        
        self.sceneSize = sceneSize
        
        self.playButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
        self.playButton?.name = "playButton"
        self.playButton?.anchorPoint = CGPointMake(0.5, 0.5)
        self.playButton?.zPosition = 90
        
        self.logo = SKSpriteNode(texture: SKTexture(imageNamed: "ninja_goo"))
        self.logo?.name = "logo"
        self.logo?.anchorPoint = CGPointMake(0.5, 0)
        self.logo?.zPosition = 90
        self.logo?.setScale(0.4)
        
        let a = UIFont(name: "Chalkduster", size: 14)
        
        self.pointsBoard = SKLabelNode(fontNamed: "Chalkduster")
        self.pointsBoard?.name = "points"
        self.pointsBoard?.zPosition = 90
        self.pointsBoard?.text = "Points: 9000"
        self.pointsBoard?.fontColor = UIColor.redColor()
        self.pointsBoard?.fontSize = 70
        self.pointsBoard?.verticalAlignmentMode = .Center
        
        self.stageButton = SKSpriteNode(texture: SKTexture(imageNamed: "fases"))
        self.stageButton?.name = "stageButton"
        self.stageButton?.anchorPoint = CGPointMake(0 , 0)
        self.stageButton?.zPosition = 90
        
        self.pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "pause"))
        self.pauseButton?.name = "pauseButton"
        self.pauseButton?.anchorPoint = CGPointMake(0 , 0)
        self.pauseButton?.zPosition = 90
        self.pauseButton?.setScale(0.6)
        self.pauseButton?.alpha = 0.7

        
//        self.optionsButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
//        self.optionsButton?.name = "optionsButton"

        
//        self.gamecenterButton = SKSpriteNode(texture: SKTexture(imageNamed: "CG"))
//        self.gamecenterButton?.name = "gamecenterButton"
//        self.gamecenterButton?.anchorPoint = CGPointMake(0.5, 0.5)

        //Init positions
        playButtonInScreemPosition = self.convertPointToIpadUp(CGPointMake(0, -80))
        playButtonOffScreemPosition = self.convertPointToIpadUp(CGPointMake(self.sceneSize!.width/2 + 300, 0))
        
        logoButtonInScreemPosition = self.convertPointToIpadUp(CGPointMake(0, sceneSize.height/2 - self.logo!.size.height*1.8))
        logoButtonOffScreemPosition = self.convertPointToIpadUp(CGPointMake(0, self.sceneSize!.height))
        
        stageButtonInScreemPosition = self.convertPointToIpadDown(CGPointMake(sceneSize.width/2 - self.stageButton!.size.width - 200, -sceneSize.height/2 + self.stageButton!.size.height + 10))
        stageButtonOffScreemPosition = self.convertPointToIpadDown(CGPointMake(self.sceneSize!.width, -sceneSize.height/2 + self.stageButton!.size.height + 10))
        
        pointsBoardButtonInScreemPosition = self.convertPointToIpadUp(CGPointMake( sceneSize.width/2 - 300 , sceneSize.height/2 - 260))
        pointsBoardButtonOffScreemPosition = self.convertPointToIpadUp(CGPointMake(self.sceneSize!.width/2 + 300, sceneSize.height/2 - 260))
        
        pauseButtonInScreemPosition = self.convertPointToIpadUp(CGPointMake(-sceneSize.width/2 + self.pauseButton!.size.width - 100, 350))
        pauseButtonOffScreemPosition = self.convertPointToIpadUp(CGPointMake(-sceneSize.width/2 + self.pauseButton!.size.width - 100 , self.sceneSize!.height/2 + 300))
        
        
        //Set positio
        self.playButton?.position = (playButtonOffScreemPosition!)
        self.logo?.position = (logoButtonOffScreemPosition!)
        self.pointsBoard?.position = (pointsBoardButtonInScreemPosition!)
        self.stageButton?.position = (stageButtonOffScreemPosition!)
        self.pauseButton?.position = (pauseButtonOffScreemPosition!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveButtonsOffScreem(){
        
        let movePlayeButton = SKAction.moveTo(self.playButtonOffScreemPosition!, duration: 0.5)
        let moveLogo = SKAction.moveTo(self.logoButtonOffScreemPosition!, duration: 0.5)
        let moveStageButton = SKAction.moveTo(self.stageButtonOffScreemPosition!, duration: 0.5)
        
        self.playButton?.runAction(movePlayeButton)
        self.logo?.runAction(moveLogo)
        self.stageButton?.runAction(moveStageButton)
        
    }
    
    func moveButtonsInScreem(){
        
        let movePlayeButton = SKAction.moveTo(self.playButtonInScreemPosition!, duration: 0.5)
        let moveLogo = SKAction.moveTo(self.logoButtonInScreemPosition!, duration: 0.5)
        let moveStageButton = SKAction.moveTo(self.stageButtonInScreemPosition!, duration: 0.5)
        
        let movePauseButton = SKAction.moveTo(self.pauseButtonInScreemPosition!, duration: 0.5)
        let movePoints = SKAction.moveTo(self.pointsBoardButtonInScreemPosition!, duration: 0.5)
        
        self.playButton?.runAction(movePlayeButton)
        self.logo?.runAction(moveLogo)
        self.stageButton?.runAction(moveStageButton)
        self.pauseButton?.runAction(movePauseButton)
        
    }
    
    func convertPointToIpadUp(point: CGPoint) -> CGPoint{
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            
//            return CGPointMake(32 + point.x*2, 64 + point.y*2);
            return CGPointMake(point.x, 192 + point.y);
        }
        else{
            
            return point
        }
    }
    
    func convertPointToIpadDown(point: CGPoint) -> CGPoint{
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            
            //            return CGPointMake(32 + point.x*2, 64 + point.y*2);
            return CGPointMake(point.x, -192 + point.y);
        }
        else{
            
            return point
        }
    }
}
