//
//  SceneTesteUm.swift
//  Testando
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 25/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class SceneTesteUm: SKScene, SKPhysicsContactDelegate , UIGestureRecognizerDelegate, GKGameCenterControllerDelegate {
    
    var score:Int = 0

    
    //Positions
    var lastBackgoundPostionX: CGFloat = 0.0
    var lastPlatformePositionX: CGFloat = 500.0
    
    //Batiman
    //let batiman = Batiman(atPosition: CGPoint(x: -850, y: 400), texture: SKTexture(imageNamed: "BONECO"))
    
    let batiman = Ninja(atPosition: CGPoint(x: -850, y: 900) , body: "body", mask: "mask", back_eyes: "back_eyes", eyes: "eyes", spinning: "spinning")
    let batimanLayer = SKNode()
    
    //Mountais
    let frontMoutainLayer = SKNode()
    let backMountainLayer = SKNode()
    
    //Clouds
    let frontCloudLayer = SKNode()
    let backCloudLayer = SKNode()
    
    //Platform
    let platformLayer = SKNode()

   //Taps postions
    var initialTapPosition = CGPoint()
    var finalTapPosition = CGPoint()
    
    //Used to calculate time after witch update
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    //Player is draging batiman
    var isDraging = false
    
    //Win lose categorys
    var gameOver = false
    var winStage = false
    
    let contactCatagories = CollisionCategory()
    
    
    var moveBatiman = false


    let worldLayer = SKNode()
    let camera = SKNode()
    
    var batimanAntPositionScene = CGPointZero
    var batimanCurrentPositionScene = CGPointZero

    var actualTouchLocation = CGPoint()
    
    var gameStarted = false
    
    var HUD: Hud?
    
    

    
    
    var tempPlatform: SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        
        
        authenticateLocalPlayer()
        //Scene propetis
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -40)
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        //self.tempPlatform = self.childNodeWithName("tempPlatform") as? SKSpriteNode
        //self.tempPlatform?.position.x = 0.0
        
        //Adding chidren
        self.worldLayer.addChild(self.frontMoutainLayer)
        self.worldLayer.addChild(self.backMountainLayer)
        self.worldLayer.addChild(self.frontCloudLayer)
        self.worldLayer.addChild(self.backCloudLayer)
        self.worldLayer.addChild(self.platformLayer)
        self.worldLayer.addChild(self.batiman)
        self.worldLayer.addChild(self.camera)
        self.addChild(self.worldLayer)
        
        
        
        //MUSIC
        //var music = SKAction.playSoundFileNamed("music2.mp3", waitForCompletion: true)
        //self.runAction(SKAction.repeatActionForever(music))
        
        //Adding HUD
        self.HUD = Hud(sceneSize: self.size)
        self.HUD?.zPosition = 90
        self.addChild(HUD!.playButton!)
        self.addChild(HUD!.logo!)
        //self.addChild(HUD!.pointsBoard!)
        self.addChild(HUD!.stageButton!)
        self.addChild(HUD!.pauseButton!)
        
        self.HUD?.moveButtonsInScreem()
        
        //Animate batiman when him is still
        self.batiman.IdleAnimation()
        
        //Load sks objects
        WorldLayer.loadObjectsWithName("frontMountain", inScene: self , intoLayer: self.frontMoutainLayer)
        WorldLayer.loadObjectsWithName("backMountain", inScene: self , intoLayer: self.backMountainLayer)
        WorldLayer.loadObjectsWithName("frontCloud", inScene: self , intoLayer: self.frontCloudLayer)
        WorldLayer.loadObjectsWithName("backCloud", inScene: self , intoLayer: self.backCloudLayer)
        WorldLayer.loadObjectsWithName("platform_*", inScene: self, intoLayer: self.platformLayer)
        
        //Moving the front clounds
        let animateCloudUp = SKAction.moveByX(0, y: 20, duration: 1)
        let animateCloudDown = SKAction.moveByX(0, y: -20, duration: 1)
        let seqOne = SKAction.sequence([animateCloudUp , animateCloudDown])
        let seqTwo = SKAction.sequence([animateCloudDown , animateCloudUp])
        let repteOne = SKAction.repeatActionForever(seqOne)
        let repteTwo = SKAction.repeatActionForever(seqTwo)

        self.frontCloudLayer.runAction(repteOne, withKey: "move")
        self.backCloudLayer.runAction(repteTwo, withKey: "move")
        
       // let xCon = SKConstraint.positionX(SKRange(upperLimit: self.size.width/2), y: SKRange(upperLimit: self.size.height - self.batiman.body.size.height))
    
        let ae = SKConstraint.positionX(SKRange(upperLimit: self.size.width/2))
        self.batiman.currentPosition = self.batiman.position
        self.batiman.antPosition = self.batiman.currentPosition
        
        self.batimanCurrentPositionScene = self.worldLayer.convertPoint(self.batiman.position, fromNode: self)
        self.batimanAntPositionScene = self.batimanCurrentPositionScene
        
        self.batiman.moveChar(amountToMoveX: 0, amountToMoveY: -100)
        
       // var viewCtrl =
        

    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.view!.window!.rootViewController!.presentViewController(viewController, animated: true, completion: nil)
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
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
//    - (CGPoint)convertPoint:(CGPoint)point
//    {
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//    return CGPointMake(32 + point.x*2, 64 + point.y*2);
//    } else {
//    return point;
//    }
//    }
    

    
    func startGame(){
        
        //retirar hud do meio
        //mover mundo pro meio
        
        self.HUD!.moveButtonsOffScreem()
        self.gameStarted = true

        
    }
    
    func pauseGame(){
        
        

        
    }
    
    func restart(){

        self.saveHighscore(self.score)
        self.score = 0
        self.batiman.getRandomMask()
        self.batiman.isMoving = true
        self.batiman.physicsBody?.collisionBitMask = 0
        self.batiman.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let moveBatiman = SKAction.moveTo(CGPoint(x: -850, y: 600), duration: 0.5)
        let block = SKAction.runBlock({ self.changeBatimanCollisionCategory() })
        
        self.batiman.runAction( SKAction.sequence([moveBatiman , block]))
        let testesound = SKAction.playSoundFileNamed("mola.wav", waitForCompletion: true)
        
        self.runAction(testesound)
        
        
        //self.batimanLayer.runAction( SKAction.sequence([moveBatiman , block]))
    }
    
    func changeBatimanCollisionCategory(){
        
        self.batiman.physicsBody?.collisionBitMask = 2 | 4
        self.batiman.isMoving = false
        self.batiman.isDead = false
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches{
            
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
           
            if(self.HUD!.pauseButton!.containsPoint(location) && self.gameStarted == true){
                
                self.gameStarted = false
                self.HUD?.moveButtonsInScreem()
            }
            
            if(self.HUD!.stageButton!.containsPoint(location) && self.gameStarted == false){
                
                self.showLeader()
            }
            
            if(self.gameStarted && !self.batiman.isDead){
                
                self.initialTapPosition = location
                self.isDraging = true
            }
            else{
                
                if(self.HUD!.playButton!.containsPoint(location) && self.gameStarted == false){
                    
                    self.startGame()
                }
                else{
                    
                    if(self.gameStarted == true){
                        
                        
                    }
                }
                
                
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        if(self.isDraging == true && self.gameStarted == true && !self.batiman.isDead){
            
            let touch: AnyObject = touches.anyObject()!
            self.actualTouchLocation = touch.locationInNode(self)
            self.finalTapPosition = touch.locationInNode(self)
            
            var speedX = self.initialTapPosition.x - self.actualTouchLocation.x
            var speedY = self.initialTapPosition.y - self.actualTouchLocation.y
            
            var distance = sqrt( pow(speedX, 2) + pow(speedY, 2))
            var realDistance = distance
            
            if(distance > 300){
                
                distance = 300
            }
            else{
                if(distance == 0){
                    
                    distance = 1
                }
            }
            
            self.batiman.stretch(scale: abs(distance) * 0.23 / 300, time: 0)
            
            var direction = self.batiman.radiansToDegree(-1 * atan(speedX / speedY))
            
            if(speedY < 0){
                
                direction = direction - 180
            }
            
            self.batiman.lookTo(self.batiman.eyes, angle: 90 + direction, time: 0.1)
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if(self.isDraging == true && self.gameStarted == true && self.batiman.isMoving == false && !self.batiman.isDead){
            
            self.isDraging = false
            self.batiman.isMoving = true
            
            let touch: AnyObject = touches.anyObject()!
            
            self.finalTapPosition = touch.locationInNode(self)
            
            var speedX = self.initialTapPosition.x - self.finalTapPosition.x
            var speedY = self.initialTapPosition.y - self.finalTapPosition.y
            
            
            
            let speed = minMaxSpeed(speedX, sY: speedY)
            
            
            self.batiman.physicsBody?.dynamic = true
            self.batiman.moveChar(amountToMoveX: speed.0, amountToMoveY: speed.1)
            
            self.score += 1

        }
    }
    
    func minMaxSpeed(sX : CGFloat, sY : CGFloat) -> (CGFloat,CGFloat) {
        var minD :CGFloat = 100.0
        var maxD : CGFloat = 350.0
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
    
    override func update(currentTime: CFTimeInterval) {
        
        //Check for gameover
        if(self.batiman.position.y < -self.size.height/2 ){
            
            self.batiman.isDead = true
            self.restart()
            //Trasintion to lose scene
            
        }
        
        //Updating batiman ant e actual positions
        self.batiman.antPosition = self.batiman.currentPosition
        self.batiman.currentPosition = self.batiman.position
        
        self.batimanAntPositionScene = self.batimanCurrentPositionScene
        self.batimanCurrentPositionScene = self.convertPoint(self.batiman.position, fromNode: self.worldLayer)
        
        
        //Find if batiman is moving left or rigth
        if(self.batiman.antPosition.x < self.batiman.currentPosition.x){
            
            self.batiman.movimentDirctionX = -1
        }
        else{
            if(self.batiman.antPosition.x > self.batiman.currentPosition.x){
                
                self.batiman.movimentDirctionX = 1
            }
            else{
                
                self.batiman.movimentDirctionX = 0
            }
        }
        
        //Find if batiman is moving up or down
        if(self.batiman.antPosition.y < self.batiman.currentPosition.y){
            
            self.batiman.movimentDirectionY = -1
        }
        else{
            if(self.batiman.antPosition.x > self.batiman.currentPosition.x){
                
                self.batiman.movimentDirectionY = 1
            }
            else{
                
                self.batiman.movimentDirctionX = 0
            }
        }
        
        //Moving the world if batiman
        if(self.batiman.position.x >= 0 ){
            
            let batimanMovedX = self.batimanCurrentPositionScene.x - self.batimanAntPositionScene.x
            let directionModificatorX = CGFloat(self.batiman.movimentDirctionX)
            var amountToMove = batimanMovedX
            
            if(amountToMove < 0)
            {
                amountToMove = amountToMove * -1
            }
            
            //WorldLayer.moveLayer(self.batimanLayer, amountTomove: (amountToMove) * directionModificatorX)
            
            //WorldLayer.moveLayer(self.worldLayer, amountTomove: amountToMove * directionModificatorX )
//            WorldLayer.moveLayer(self.frontMoutainLayer, amountTomove: (4) * directionModificatorX)
//            WorldLayer.moveLayer(self.backMountainLayer, amountTomove: (2.5) * directionModificatorX)
//            
//            WorldLayer.moveLayer(self.frontCloudLayer, amountTomove: (amountToMove + 4) * directionModificatorX)
//            WorldLayer.moveLayer(self.backCloudLayer, amountTomove: (amountToMove + 2.5) * directionModificatorX)
//            
//            WorldLayer.moveLayer(self.platformLayer, amountTomove: (amountToMove) * directionModificatorX)
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        self.batiman.lookTo(self.batiman.eyes)
        
        let bodyOne = contact.bodyA.node 
        let bodyTwo = contact.bodyB.node
        

        let u = contact.contactPoint
        
        if( (bodyOne?.physicsBody?.categoryBitMask == self.contactCatagories.batimanCategoryBitMask && bodyTwo?.physicsBody?.categoryBitMask == self.contactCatagories.platformCategoryBitMask) || (bodyOne?.physicsBody?.categoryBitMask == self.contactCatagories.platformCategoryBitMask && bodyTwo?.physicsBody?.categoryBitMask == self.contactCatagories.batimanCategoryBitMask)  ){
        
            //if(bodyOne?.physicsBody!.categoryBitMask == self.contactCatagories.batimanCategoryBitMask){
                
            
                
                //self.batiman.physicsBody?.applyImpulse(CGVectorMake(0, 9.8 * self.batiman.physicsBody!.mass))
                
           // }
            //else{
                if(self.batiman.isDead == false){
                    let dirColision = contact.contactNormal

                    println("dx : \(dirColision.dx)")
                    println("dy : \(dirColision.dy)")

                    if(dirColision.dx > 0.0){
                        self.batiman.nail_left()
                    }
                    else if(dirColision.dx < 0.0){
                        self.batiman.nail_right()
                        self.batiman.lookTo(self.batiman.eyes, angle: -120)
                    }
                    else {
                        self.batiman.nail_down()
                    }
                    
                    self.batiman.isMoving = false
                    self.batiman.IdleAnimation()
                    
                    self.batiman.physicsBody?.dynamic = false
                    
                    }

//                let a = SKPhysicsJointFixed.jointWithBodyA(bodyTwo.physicsBody, bodyB: bodyOne.physicsBody, anchor: u)
//                
//                self.physicsWorld.addJoint(a)
                
           // }
        }
        else{
            
            if( (bodyOne?.physicsBody!.categoryBitMask == self.contactCatagories.batimanCategoryBitMask && bodyTwo?.physicsBody!.categoryBitMask == self.contactCatagories.spikeCategoryBitMask) || (bodyOne?.physicsBody!.categoryBitMask == self.contactCatagories.spikeCategoryBitMask && bodyTwo?.physicsBody!.categoryBitMask == self.contactCatagories.batimanCategoryBitMask)  ){
                
                self.batiman.isDead = true
                self.restart()
            }
            
            
            
        }
        
        
        
    }
    
    override func didSimulatePhysics() {
        
        self.camera.position = CGPointMake(self.batiman.position.x, self.batiman.position.y)
        
        
            
        self.centerOnNode(camera)

        

    }
    
    func centerOnNode(node: SKNode){
        
        let cameraPositionInScene = node.scene?.convertPoint(node.position, fromNode: node.parent!)
        
        node.parent?.position = CGPointMake(node.parent!.position.x - cameraPositionInScene!.x , node.parent!.position.y )
        
    }
    
    override func didFinishUpdate() {
        

        
    }
    
    
    
    
}

