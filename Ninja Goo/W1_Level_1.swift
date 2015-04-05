//
//  GameScene.swift
//  Ninja Goo
//
//  Created by Andrew on 4/2/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import SpriteKit

class W1_Level_1: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Properties

    //Scores
    var score:Int = 0
    
    
    //Positions
    var lastBackgroundPositionX: CGFloat = 0.0
    var lastPlatformPositionX: CGFloat = 500.0

    //Ninja
    var ninja : Ninja! = Ninja(atPosition: CGPoint(x: 0, y: 1000))
    let ninjaLayer = SKNode()
    
    //Mountais
    let frontMoutainLayer = SKNode()
    let backMountainLayer = SKNode()
    
    //Clouds
    let frontCloudLayer = SKNode()
    let backCloudLayer = SKNode()
    
    //Platform
    let platformLayer = SKNode()
    
    //Array Layers
    var layers : [SKNode]!
    
    //World 
    let worldLayer = SKNode()
    let camera = SKNode()
    
    //Tap positions
    var initialTapPosition = CGPoint()
    var finalTapPosition = CGPoint()
    
    //Ninja positions
    var ninjaAntPositionScene = CGPointZero
    var ninjaCurrentPositionScene = CGPointZero
    
    //Used to calculate time after witch update
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    //Player is draging
    var isDraging = false
    
    //Win lose categories
    var gameOver = false
    var winStage = false
    
    
    var moveNinja = false
    var gameStarted = false

    var actualTouchLocation = CGPoint()
    
    // Properties to keep track of details important to scene updates.
    var worldMovedForUpdate = false
    
    var HUD: Hud?
    
    // A closure to be called when `didMoveToView(_:)` completes.
    var finishedMovingToView: Void -> Void = {}
    
    var tempPlatform: SKSpriteNode?
    
    // MARK: Constants
    
    struct Constants {
        
        static let midAnchor = CGPointMake(0.5, 0.5)
        static let defaultSpawnPoint = CGPoint(x: 0, y: 0)
        static let defaultScale :CGFloat = 0.31
        
        static let gravity = CGVectorMake(0, -20)
        static let minForce : CGFloat = 30.0
        static let maxForce : CGFloat = 120.0
        static let maxForceGeral : CGFloat = maxForce + 70

        static let backgroundQueue = dispatch_queue_create("com.koruja.ningoo.backgroundQueue", DISPATCH_QUEUE_SERIAL)
        
    }
    
    // MARK: Asset Pre-loading
    
    class func loadSceneAssetsWithCompletionHandler(skView : SKView, completionHandler: W1_Level_1 -> Void) {
        dispatch_async(Constants.backgroundQueue) {
            
            let loadedScene = W1_Level_1(size: skView.bounds.size)//W1_Level_1.unarchiveFromFile("W1_Level_1") as? W1_Level_1
            
            
            
            dispatch_async(dispatch_get_main_queue()) { completionHandler(loadedScene) }
            
        }
    }
    
    func loadWorld() {
        
        self.worldLayer.setScale(Constants.defaultScale)
        
         layers = [self.backMountainLayer, self.frontMoutainLayer, self.backCloudLayer, self.frontCloudLayer, self.platformLayer]

        let scene = SKScene(fileNamed: "W1_Level_2")
        let templateWorld = scene.children.first!.copy() as SKNode

        populateLayersFromWorld(templateWorld)
        
        for l in layers {
            self.worldLayer.addChild(l)
        }
        
        self.worldLayer.name = "worldLayer"

        self.worldLayer.addChild(self.ninja)
        self.worldLayer.addChild(self.camera)
        self.addChild(self.worldLayer)
        
        
        
    }
    
    func populateLayersFromWorld(fromWorld: SKNode) {
        
        //Load sks objects
        WorldLayer.loadObjectsWithName("frontMoutainLayer", inNode: fromWorld , intoLayer: self.frontMoutainLayer)
        WorldLayer.loadObjectsWithName("backMountainLayer", inNode: fromWorld , intoLayer: self.backMountainLayer)
        WorldLayer.loadObjectsWithName("frontCloudLayer", inNode: fromWorld , intoLayer: self.frontCloudLayer)
        WorldLayer.loadObjectsWithName("backCloudLayer", inNode: fromWorld , intoLayer: self.backCloudLayer)
        WorldLayer.loadObjectsWithName("platformLayer", inNode: fromWorld, intoLayer: self.platformLayer)
        
        
        //zPositions
        frontCloudLayer.zPosition = 10
        
    }
    
   
    func loadHud(){

        //Adding HUD
        self.HUD = Hud(sceneSize: CGSizeMake(self.size.width, self.size.height))
        self.HUD?.zPosition = 90
        self.HUD?.addChild(HUD!.playButton!)
        self.HUD?.addChild(HUD!.logo!)
        //self.addChild(HUD!.pointsBoard!)
        self.HUD?.addChild(HUD!.stageButton!)
        self.HUD?.addChild(HUD!.pauseButton!)
        
        self.HUD?.moveButtonsInScreen()
        
        self.addChild(HUD!)
        //self.HUD?.setScale(0.1)
        
    }

    
    func loadPhysics(){
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = Constants.gravity
        self.anchorPoint = Constants.midAnchor
        
    }
    
    func animateClouds(){
        
        //Moving the front clounds
        let animateCloudUp = SKAction.moveByX(0, y: 20, duration: 1)
        let animateCloudDown = SKAction.moveByX(0, y: -20, duration: 1)
        let seqOne = SKAction.sequence([animateCloudUp , animateCloudDown])
        let seqTwo = SKAction.sequence([animateCloudDown , animateCloudUp])
        let repteOne = SKAction.repeatActionForever(seqOne)
        let repteTwo = SKAction.repeatActionForever(seqTwo)
        
        self.frontCloudLayer.runAction(repteOne, withKey: "move")
        self.backCloudLayer.runAction(repteTwo, withKey: "move")
        
    }
    
    func loadNinja(){
        
        self.ninja.IdleAnimation()
        self.ninja.currentPosition = self.ninja.position
        self.ninja.antPosition = self.ninja.currentPosition
        
        self.ninjaCurrentPositionScene = self.worldLayer.convertPoint(self.ninja.position, fromNode: self)
        self.ninjaAntPositionScene = self.ninjaCurrentPositionScene
        
        //self.ninja.jump(amountToMoveX: 0, amountToMoveY: -100)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        
        dispatch_async(Constants.backgroundQueue) {
            
            self.loadWorld()
            self.loadHud()
            self.loadPhysics()
            self.loadNinja()
            self.animateClouds()
            

            
            //self.centerWorldOnPosition(Constants.defaultSpawnPoint)
            
            dispatch_async(dispatch_get_main_queue(), self.finishedMovingToView)
            
        }
      
    }
   
    
    func startGame(){
        
        //retirar hud do meio

        self.HUD!.moveButtonsOffScreen()
        self.gameStarted = true
        
        
    }
    
    func restart(){
        
        println("restart")
        
        //self.saveHighscore(self.score)
        self.score = 0
        self.ninja.getRandomMask()
        self.ninja.isMoving = true
        //self.ninja.physicsBody?.collisionBitMask = 0
        self.ninja.physicsBody?.contactTestBitMask = 0

        self.ninja.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let moveninja = SKAction.moveTo(CGPoint(x: 0, y: 1000), duration: 0.5)
        
        let block = SKAction.runBlock({ self.changeNinjaCollisionCategory() })
    
        self.ninja.runAction( SKAction.sequence([moveninja, block]))
        
        
        
    }
    
    func changeNinjaCollisionCategory(){
        
        self.ninja.physicsBody?.contactTestBitMask = ColliderType.Platform.rawValue | ColliderType.Spike.rawValue
        self.ninja.isMoving = false
        self.ninja.isDead = false
        //self.ninja.physicsBody?.applyImpulse(CGVectorMake(0 , -9.8 * self.ninja.physicsBody!.mass))
        
        //let moveNinja = SKAction.moveTo(CGPoint(x: -850, y: -200), duration: 0.3)
        //self.ninja.runAction(moveNinja)
        
    }
    

    // MARK: Camera Convenience
    
    func centerWorldOnNinja() {

        let cameraPositionInScene = self.ninja.scene?.convertPoint(ninja.position, fromNode: ninja.parent!)
        
        var y :CGFloat = cameraPositionInScene!.y
        //        if !self.ninja.isMoving && cameraPositionInScene!.y > self.frame.height*0.8 {
        //            y = cameraPositionInScene!.y
        //        }
        
        ninja.parent!.position = CGPointMake(ninja.parent!.position.x - cameraPositionInScene!.x , ninja.parent!.position.y)
    }
    
    func centerWorldOnNinjaOnlyWhenNotMoving()  {
        
        let min : CGFloat = 5.0
        
        let cameraPositionInScene = self.ninja.scene?.convertPoint(ninja.position, fromNode: ninja.parent!)
        var pPos = ninja.parent!.position

        let yDif = pPos.y - cameraPositionInScene!.y
        let xDif = pPos.x - cameraPositionInScene!.x
        let n = !self.ninja.isMoving
        
        if(n && pPos.x > xDif){
            
             pPos = CGPointMake(pPos.x - min, pPos.y)
            
        }
        
        if(n && pPos.x < xDif){
            
            pPos = CGPointMake(pPos.x + min, pPos.y)
            
        }

        
        if(n && pPos.y > yDif){
            
            pPos = CGPointMake(pPos.x, pPos.y - min)
            
        }
        
        if(n && pPos.y < yDif){
            
            pPos = CGPointMake(pPos.x, pPos.y + min)
            
        }

        ninja.parent!.position = pPos

        

        
    }
  
    
    override func didSimulatePhysics() {

        if(gameStarted) {
            centerWorldOnNinjaOnlyWhenNotMoving()
            //centerWorldOnNinja()

        }
        
    }
    
    // MARK: Update
    
    override func update(currentTime: CFTimeInterval) {
        
        //Check for gameover
        if(self.ninja.position.y < -self.size.height ){
            
            self.runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: true))

            self.ninja.isDead = true
            self.restart()
            
        }
        
    }
    
    
    // MARK: Collision

    func didBeginContact(contact: SKPhysicsContact) {
        
        ninja.position.x = 0
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask){
            
            case ColliderType.Platform.rawValue | ColliderType.Ninja.rawValue:
                
                if(self.ninja.isDead == false) {
                    println("colidiu com plataforma")
                    self.ninja.isMoving = false
                    let dirColision = contact.contactNormal
                    
                    if(dirColision.dx > 0.0){
                        self.ninja.nail_left()
                    }
                    else if(dirColision.dx < 0.0){
                        self.ninja.nail_right()
                        self.ninja.lookTo(self.ninja.eyes, angle: -120)
                    }
                    else {
                        self.ninja.nail_down()
                    }
                    
                    let wallSE = SKAction.playSoundFileNamed("wall.wav", waitForCompletion: true)
                    self.runAction(wallSE)
                    
                    self.ninja.IdleAnimation()
                    self.ninja.physicsBody?.dynamic = false
                }
            
            case ColliderType.Spike.rawValue | ColliderType.Ninja.rawValue:
                println("colidiu com spike")

                self.runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: true))
                
                if(!self.ninja.isDead){
                    
                    self.ninja.isDead = true
                    self.restart()
                    
                }
                
            default:
                println("colidiu com default")
            }
        
    }

    
    // MARK: Touch

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches{
            
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if(self.HUD!.pauseButton!.containsPoint(self.HUD!.convertPoint(location, fromNode: self))){
                
                self.gameStarted = false
                self.HUD?.moveButtonsInScreen()
            }
            
            if(self.HUD!.stageButton!.containsPoint(location) && self.gameStarted == false){
                
                //self.showLeader()
            }
            
            if(self.gameStarted && !self.ninja.isDead && !self.ninja.isMoving){
                
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
        
        
        if(self.isDraging == true && self.gameStarted == true && !self.ninja.isDead){
            
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
            
            
            self.ninja.stretch(scale: abs(distance) * 0.23 / 300, time: 0)
            
            var direction = ConvertUtilities.radiansToDegree(-1 * atan(speedX / speedY))
            
            if(speedY < 0){
                
                direction = direction - 180
            }
            
            self.ninja.lookTo(self.ninja.eyes, angle: 90 + direction, time: 0.1)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if(self.isDraging == true && self.gameStarted == true && self.ninja.isMoving == false && !self.ninja.isDead){
            
            self.isDraging = false
            self.ninja.isMoving = true
            
            let touch: AnyObject = touches.anyObject()!
            
            self.finalTapPosition = touch.locationInNode(self)
            
            var speedX = self.initialTapPosition.x - self.finalTapPosition.x
            var speedY = self.initialTapPosition.y - self.finalTapPosition.y
            
            
            
            let speed = ConvertUtilities.minMaxSpeed(speedX, sY: speedY)
            
            
            self.ninja.physicsBody?.dynamic = true
            self.ninja.jump(amountToMoveX: speed.0, amountToMoveY: speed.1)
            
            self.score += 1
            
        }
    }
    
    
    

}
