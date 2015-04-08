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
    var ninja : Ninja! = Ninja()
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

    //TileMap Otimization
    var tileSizeTotal : CGSize?
    var firstTile : SKSpriteNode?
    var first : Bool = true
    var counter : (w : Int, h: Int) = (0,0)
    var initialPos : Int = 0

    //Map
    var map : JSTileMap!
    
    // MARK: Constants
    
     struct Constants {
        
        static let midAnchor = CGPointMake(0.5, 0.5)
        static var defaultSpawnPoint = CGPoint(x: 0, y: 0)
        static let defaultScale :CGFloat = 0.31
        static var defaultGroundPoint : CGPoint!
        
        static var minCamPos : CGFloat!
        static let gravity = CGVectorMake(0, -20)
        static let minForce : CGFloat = 30.0
        static let maxForce : CGFloat = 120.0
        static let maxForceGeral : CGFloat = maxForce + 70
        
        static let zPosBackgroundBackLayer : CGFloat = 1
        static let zPosBackgroundFrontLayer : CGFloat = 2
        static let zPosCloudBack : CGFloat = 3
        static let zPosWall : CGFloat = 4
        static let zPosCloudFront : CGFloat = 5




        static let backgroundQueue = dispatch_queue_create("com.koruja.ningoo.backgroundQueue", DISPATCH_QUEUE_SERIAL)
        
    }
    
    // MARK: Asset Pre-loading
    
    class func loadSceneAssetsWithCompletionHandler(skView : SKView, completionHandler: W1_Level_1 -> Void) {
        dispatch_async(Constants.backgroundQueue) {
            
            let loadedScene = W1_Level_1(size: skView.bounds.size)
            
            //W1_Level_1.unarchiveFromFile("W1_Level_1") as? W1_Level_1
            
    
            dispatch_async(dispatch_get_main_queue()) { completionHandler(loadedScene) }
            
        }
    }
    
    func loadWorld() {
        
        self.worldLayer.setScale(Constants.defaultScale)
        
         layers = [self.backMountainLayer, self.frontMoutainLayer, self.backCloudLayer, self.frontCloudLayer, self.platformLayer]

//        let scene = SKScene(fileNamed: "W1_Level_2")
//        let templateWorld = scene.children.first!.copy() as SKNode
//
//        populateLayersFromWorld(templateWorld)
        
        self.map = JSTileMap(named: "FaseTeste.tmx")

        let map_layer = map.layerNamed("Walls")
        map_layer.zPosition = Constants.zPosWall
        
        let preenchimento = map.layerNamed("preenchimento")
        preenchimento.zPosition = Constants.zPosWall


        createNodesFromLayer(map_layer)
        
        for l in layers {
            self.worldLayer.addChild(l)
        }
        
        self.worldLayer.addChild(map)

        self.worldLayer.name = "worldLayer"

        self.worldLayer.addChild(self.ninja)
        self.worldLayer.addChild(self.camera)
        self.addChild(self.worldLayer)
        
        Constants.defaultSpawnPoint = getStartPosition(map, groupName: "Ninja", name: "ninja")
        Constants.defaultGroundPoint = getStartPosition(map, groupName: "Ground", name: "ground")
        Constants.minCamPos = Constants.defaultGroundPoint.y + self.scene!.size.height

        
        centerWorldOnPoint(CGPointMake(Constants.defaultSpawnPoint.x, Constants.defaultGroundPoint.y + self.frame.height))

        
        
    }
    
    
    func createNodesFromLayer(layer: TMXLayer) {
        
        let map = layer.map
        for w in 0..<Int(layer.layerInfo.layerGridSize.width) {

            for h in 0..<Int(layer.layerInfo.layerGridSize.height) {
                

                let coord = CGPoint(x: w, y: h)
                let tileGid = layer.layerInfo.tileGidAtCoord(coord)
                
                if tileGid == 0 {
                    continue
                }
                
                if let properties = map.propertiesForGid(tileGid) {
                    
                    if properties["wall"] != nil {
                        let tile = layer.tileAtCoord(coord)
                        setPhysicBody(tile, pos: (w, h))
                        
                        /*tile.physicsBody = SKPhysicsBody(rectangleOfSize:tile.size)
                        tile.physicsBody!.categoryBitMask = ColliderType.Platform.rawValue
                        tile.physicsBody!.dynamic = false
                        tile.physicsBody!.friction = 0*/

                    }
                }
            }
        }
    }
    
    func setPhysicBody(tile : SKSpriteNode, pos : (w: Int, h: Int)){
        
        if(first){
            
            firstTile = tile
            tileSizeTotal = tile.size
            first = false
            counter = pos
        
        }
        else {
            
            if(counter.h + 1 == pos.h) {
                counter.h++
                tileSizeTotal = CGSizeMake(tileSizeTotal!.width, tileSizeTotal!.height + tile.size.height)

                
            }
            else {
                
                var finalSize = CGSizeMake(tileSizeTotal!.width, tileSizeTotal!.height)
                
                if(firstTile?.size.height < finalSize.height){
                    finalSize.height -= firstTile!.size.height/2
                }
                
                firstTile?.anchorPoint = CGPoint(x: 0.5,y: 1)
                firstTile!.physicsBody = SKPhysicsBody(rectangleOfSize: finalSize, center:CGPointMake(0,-finalSize.height/2))
                firstTile!.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
                firstTile!.physicsBody!.dynamic = false
                firstTile!.physicsBody!.friction = 0
                
                firstTile = tile
                tileSizeTotal = tile.size
                counter = pos
            }
            
        }
        
        
    }
    
    func getStartPosition(tileMap: JSTileMap, groupName : String, name : String) -> CGPoint {
        
        let group = tileMap.groupNamed(groupName)
        let object = group.objectNamed(name)
        let x = object["x"] as? NSNumber
        let y = object["y"] as? NSNumber
        
        return CGPointMake(CGFloat(x!), CGFloat(y!))
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
    
    func loadClouds(){
        
        
        let cloud = SKSpriteNode(texture: SKTexture(imageNamed: "nuvem_escura"))
        let cloud_clara = SKSpriteNode(texture: SKTexture(imageNamed: "nuvem_clara"))

        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)
        
        let numberOfClouds = Int(map_width / cloud.size.width) * 2
        
        for index in 0...numberOfClouds {
            
            let c = cloud.copy() as SKSpriteNode
            c.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            self.backCloudLayer.addChild(c)
            
            let cc = cloud_clara.copy() as SKSpriteNode
            cc.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            self.frontCloudLayer.addChild(cc)
        
        }
        
        backCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y)
        
        frontCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y - 35)

        backCloudLayer.zPosition = Constants.zPosCloudBack
        frontCloudLayer.zPosition = Constants.zPosCloudFront

        
        self.animateClouds()
        
    }
    
    func loadBackground(){
        
        
        let montain = SKSpriteNode(texture: SKTexture(imageNamed: "montanha_escura"))
        let montain_clara = SKSpriteNode(texture: SKTexture(imageNamed: "montanha_clara"))

        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)

        let numberOfMontains = Int(map_width / montain.size.width) * 2

        for index in 0...numberOfMontains {
            
            //Montanha Escura
            let m = montain.copy() as SKSpriteNode
            
            let randomDis = CGFloat(arc4random_uniform(50))/100 + 0.5
            let randomScale = CGFloat(arc4random_uniform(100))/100 + 0.3

            
            m.position = CGPointMake(CGFloat(index) * montain.size.width * randomDis, 0)
            m.setScale(randomScale)
            m.anchorPoint = CGPointMake(0.5,0)
            
            self.frontMoutainLayer.addChild(m)
            
            
            
            //Montanha Clara
            let mC = montain_clara.copy() as SKSpriteNode
            
            let randomDis2 = CGFloat(arc4random_uniform(150))/100 + 0.3
            let randomScale2 = CGFloat(arc4random_uniform(100))/100 + 0.2
            
            mC.position = CGPointMake(CGFloat(index) * montain.size.width * randomDis2, 0)
            mC.setScale(randomScale2)
            mC.anchorPoint = CGPointMake(0.5,0)

            self.backMountainLayer.addChild(mC)
            

        }
        
        self.backMountainLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfMontains) * montain.size.width/4, Constants.defaultGroundPoint.y - 30)
        
        self.frontMoutainLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfMontains) * montain.size.width/4, Constants.defaultGroundPoint.y - 30)

        
        self.backMountainLayer.zPosition = Constants.zPosBackgroundBackLayer
        self.frontMoutainLayer.zPosition = Constants.zPosBackgroundFrontLayer

    }
    
    func animateClouds(){
        
        //Moving the front clounds
        let animateCloudUp = SKAction.moveByX(0, y: 20, duration: 1)
        let animateCloudDown = SKAction.moveByX(0, y: -20, duration: 1.0)
        let seqA = SKAction.sequence([animateCloudUp , animateCloudDown])
        let repeteA = SKAction.repeatActionForever(seqA)
        
        let animateCloudUp_B = SKAction.moveByX(0, y: 20, duration: 1.5)
        let animateCloudDown_B = SKAction.moveByX(0, y: -20, duration: 1.5)
        let seqB = SKAction.sequence([animateCloudUp_B , animateCloudDown_B])
        let repeteB = SKAction.repeatActionForever(seqB)

        
        self.frontCloudLayer.runAction(repeteA, withKey: "move")
        self.backCloudLayer.runAction(repeteB, withKey: "move")
        
    }
    
    func loadNinja(){
        
        self.ninja.position = Constants.defaultSpawnPoint
        self.ninja.IdleAnimation()
        self.ninja.currentPosition = self.ninja.position
        self.ninja.antPosition = self.ninja.currentPosition
        
        self.ninjaCurrentPositionScene = self.worldLayer.convertPoint(self.ninja.position, fromNode: self)
        self.ninjaAntPositionScene = self.ninjaCurrentPositionScene
        
        //self.ninja.jump(amountToMoveX: 0, amountToMoveY: -100)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        println("didmoveToView")
        //self.backgroundColor = SKColor.whiteColor()
        
        //dispatch_async(Constants.backgroundQueue) {
            self.loadWorld()
            self.loadHud()
            self.loadPhysics()
            self.loadNinja()
            self.loadClouds()
            self.loadBackground()
        

            
            //self.centerWorldOnPosition(Constants.defaultSpawnPoint)
            
         //   dispatch_async(dispatch_get_main_queue(), self.finishedMovingToView)
            
        //}
      
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
        let moveninja = SKAction.moveTo(Constants.defaultSpawnPoint, duration: 0.5)
        
        let block = SKAction.runBlock({ self.changeNinjaCollisionCategory() })
    
        self.ninja.runAction( SKAction.sequence([moveninja, block]))
        
    }
    
    func changeNinjaCollisionCategory(){
        
        self.ninja.physicsBody?.contactTestBitMask = ColliderType.Wall.rawValue | ColliderType.Spike.rawValue
        self.ninja.isMoving = false
        self.ninja.isDead = false
        //self.ninja.physicsBody?.applyImpulse(CGVectorMake(0 , -9.8 * self.ninja.physicsBody!.mass))
        
        //let moveNinja = SKAction.moveTo(CGPoint(x: -850, y: -200), duration: 0.3)
        //self.ninja.runAction(moveNinja)
        
    }
    

    // MARK: Camera Convenience
    
    func centerWorldOnNinja() {

//        let cameraPositionInScene = self.ninja.scene?.convertPoint(ninja.position, fromNode: ninja.parent!)
//        
//        var y :CGFloat = cameraPositionInScene!.y
//        ninja.parent!.position = CGPointMake(ninja.parent!.position.x - cameraPositionInScene!.x , ninja.parent!.position.y - cameraPositionInScene!.y)
        
        println("ninja y: \(self.ninja.position.y)")
        println("ground y: \(Constants.defaultGroundPoint.y)")

        var point : CGPoint!
        if(self.ninja.position.y > Constants.minCamPos){
            point = self.ninja.position
        }
        else {
            point = CGPointMake(self.ninja.position.x, Constants.minCamPos)

        }
        
        centerWorldOnPoint(point)

    }
    
    func centerWorldOnPoint(point : CGPoint) {
        
        var cameraPositionInScene = self.worldLayer.scene?.convertPoint(point, fromNode: worldLayer)
        
        var y :CGFloat = cameraPositionInScene!.y
        
        var posX = self.worldLayer.position.x - cameraPositionInScene!.x
        var posY = self.worldLayer.position.y - cameraPositionInScene!.y
        
        self.worldLayer.position = CGPointMake(posX, posY)
        
        //Parallax Montain
        posX = self.frontMoutainLayer.position.x + cameraPositionInScene!.x * 2
        posY = self.frontMoutainLayer.position.y + cameraPositionInScene!.y * 2
        self.frontMoutainLayer.position = CGPointMake(posX, posY)
        
        //Parallax Montain Back
        posX = self.backMountainLayer.position.x + cameraPositionInScene!.x * 2.5
        posY = self.backMountainLayer.position.y + cameraPositionInScene!.y * 2
        self.backMountainLayer.position = CGPointMake(posX, posY)
        
        
    }
    

    override func didSimulatePhysics() {

        if(gameStarted) {
            //centerWorldOnNinjaOnlyWhenNotMoving()
            centerWorldOnNinja()
            //cameraAlwaysMoving()
        }
        
    }
    
    // MARK: Update
    
    override func update(currentTime: CFTimeInterval) {
        
        //Check for gameover
        if(self.ninja.position.y < -Constants.defaultGroundPoint.y/8 ){
            
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
            
            case ColliderType.Wall.rawValue | ColliderType.Ninja.rawValue:
                
                if(self.ninja.isDead == false) {
                    println("colidiu com plataforma")
                    self.ninja.isMoving = false
                    let dirColision = contact.contactNormal
                    
                    if(dirColision.dx > 0.0){
                        self.ninja.nail_right()
                    }
                    else if(dirColision.dx < 0.0){
                        self.ninja.nail_left()
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
            
            println("comecou toque")

            if(self.HUD!.pauseButton!.containsPoint(self.HUD!.convertPoint(location, fromNode: self))){
                println("comecou toque2")

                self.gameStarted = false
                self.HUD?.moveButtonsInScreen()
            }
            
            if(self.HUD!.stageButton!.containsPoint(location) && self.gameStarted == false){
                println("comecou toque3")

                //self.showLeader()
            }
            
            if(self.gameStarted && !self.ninja.isDead && !self.ninja.isMoving){
                println("comecou toque4")

                self.initialTapPosition = location
                self.isDraging = true
            }
            else{
                println("comecou toque5")

                
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
        
        println("moveu toque")

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
        
        println("terminou")

        
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
