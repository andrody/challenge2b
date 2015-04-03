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
    var playButtonInScreenPosition: CGPoint?
    var playButtonOffScreenPosition: CGPoint?
    var logoButtonInScreenPosition: CGPoint?
    var logoButtonOffScreenPosition: CGPoint?
    var stageButtonInScreenPosition: CGPoint?
    var stageButtonOffScreenPosition: CGPoint?
    var pointsBoardButtonInScreenPosition: CGPoint?
    var pointsBoardButtonOffScreenPosition: CGPoint?
    var pauseButtonInScreenPosition: CGPoint?
    var pauseButtonOffScreenPosition: CGPoint?
    
    init(sceneSize: CGSize) {
        
        super.init()
        self.setScale(0.33)
        
        self.sceneSize = sceneSize
        
        self.playButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
        self.playButton?.name = "playButton"
        self.playButton?.anchorPoint = CGPointMake(0.5, 0.5)
        self.playButton?.zPosition = 90
        self.playButton?.alpha = 0

        
        self.logo = SKSpriteNode(texture: SKTexture(imageNamed: "ninja_goo"))
        self.logo?.name = "logo"
        self.logo?.anchorPoint = CGPointMake(0.5, 0.5)
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
        self.stageButton?.hidden = true
        
        self.pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "pause"))
        self.pauseButton?.name = "pauseButton"
        self.pauseButton?.anchorPoint = CGPointMake(0 , 0)
        self.pauseButton?.zPosition = 90
        self.pauseButton?.setScale(0.6)
        self.pauseButton?.alpha = 0.5

        
//        self.optionsButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
//        self.optionsButton?.name = "optionsButton"

        
//        self.gamecenterButton = SKSpriteNode(texture: SKTexture(imageNamed: "CG"))
//        self.gamecenterButton?.name = "gamecenterButton"
//        self.gamecenterButton?.anchorPoint = CGPointMake(0.5, 0.5)

        //Init positions
        playButtonInScreenPosition = self.convertPointToIpadUp(CGPointMake(0, -140))
        playButtonOffScreenPosition = self.convertPointToIpadUp(CGPointMake(0 , 0))
        
        logoButtonInScreenPosition = self.convertPointToIpadUp(CGPointMake(0, sceneSize.height/2 - self.logo!.size.height/4) )
        logoButtonOffScreenPosition = self.convertPointToIpadUp(CGPointMake(0, self.sceneSize!.height * 2))
        
        stageButtonInScreenPosition = self.convertPointToIpadDown(CGPointMake(sceneSize.width - self.stageButton!.size.width, -sceneSize.height + self.stageButton!.size.height))
        stageButtonOffScreenPosition = self.convertPointToIpadDown(CGPointMake(self.sceneSize!.width*2, -sceneSize.height/2 + self.stageButton!.size.height + 10))
        
        pointsBoardButtonInScreenPosition = self.convertPointToIpadUp(CGPointMake( sceneSize.width/2 - 300 , sceneSize.height/2 - 260))
        pointsBoardButtonOffScreenPosition = self.convertPointToIpadUp(CGPointMake(self.sceneSize!.width/2 + 300, sceneSize.height/2 - 260))
        
        pauseButtonInScreenPosition = self.convertPointToIpadUp(CGPointMake(-sceneSize.width * 2 + 320, 300))
        pauseButtonOffScreenPosition = self.convertPointToIpadUp(CGPointMake(-sceneSize.width * 3, 300))
        
        
        //Set positio
        self.playButton?.position = (playButtonInScreenPosition!)
        self.logo?.position = (logoButtonOffScreenPosition!)
        self.pointsBoard?.position = (pointsBoardButtonInScreenPosition!)
        self.stageButton?.position = (stageButtonOffScreenPosition!)
        self.pauseButton?.position = (pauseButtonOffScreenPosition!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveButtonsOffScreen(){
        
        let movePlayeButton = SKAction.fadeAlphaTo(0, duration: 0.5)//SKAction.moveTo(self.playButtonOffScreenPosition!, duration: 0.5)
        
        let movePauseButton = SKAction.moveTo(self.pauseButtonInScreenPosition!, duration: 0.5)

        let moveLogo = SKAction.moveTo(self.logoButtonOffScreenPosition!, duration: 0.5)
        let moveStageButton = SKAction.moveTo(self.stageButtonOffScreenPosition!, duration: 0.5)
        
        self.playButton?.runAction(movePlayeButton)
        self.logo?.runAction(moveLogo)
        self.stageButton?.runAction(moveStageButton)
        self.pauseButton?.runAction(movePauseButton)

        
    }
    
    func moveButtonsInScreen(){
        
        let movePlayeButton = SKAction.fadeAlphaTo(1, duration: 1)
        let moveLogo = SKAction.moveTo(self.logoButtonInScreenPosition!, duration: 0.5)
        let moveStageButton = SKAction.moveTo(self.stageButtonInScreenPosition!, duration: 0.5)
        let movePauseButton = SKAction.moveTo(self.pauseButtonOffScreenPosition!, duration: 0.5)

        let movePoints = SKAction.moveTo(self.pointsBoardButtonInScreenPosition!, duration: 0.5)
        
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
