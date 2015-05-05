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
    
    var levelName : String!

    //Scores
    var score:Int = 0
    
    var teste : SKNode!
    
    var ninjaPosTemp : CGPoint!
    var mWallTempo : SKPhysicsBody!
    
    
    
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
    let upperCloudLayer = SKNode()

    //Levels
    let levelsLayer = SKNode()
    
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
    
    
    //Used to calculate time after witch update
    var lastUpdate: NSTimeInterval = 0
    var delta: NSTimeInterval = 0
    
    // MARK: Constants
    
     struct Constants {
        
        static let midAnchor = CGPointMake(0.5, 0.5)
        static var defaultSpawnPoint = CGPoint(x: 0, y: 0)
        static let defaultScale :CGFloat = 1.0
        static var defaultGroundPoint : CGPoint!
        
        static var minCamPos : CGFloat!
        static let gravity = CGVectorMake(0, -50)
        static let minForce : CGFloat = 30.0
        static let maxForce : CGFloat = 100.0
        static let maxForceGeral : CGFloat = maxForce + 70
        static let minDistanceSlide : CGFloat = 600.0

        
        static let zPosBackgroundBackLayer : CGFloat = 1
        static let zPosBackgroundFrontLayer : CGFloat = 2
        static let zPosUpperCloud : CGFloat = 3
        static let zPosCloudBack : CGFloat = 4
        static let zPosWall : CGFloat = 5
        static let zPosCloudFront : CGFloat = 6




        static let backgroundQueue = dispatch_queue_create("com.koruja.ningoo.backgroundQueue", DISPATCH_QUEUE_SERIAL)
        
    }
    
    // MARK: Asset Pre-loading
    
    class func loadSceneAssetsWithCompletionHandler(levelName : String, completionHandler: W1_Level_1 -> Void) {
        dispatch_async(Constants.backgroundQueue) {
            
            let loadedScene = W1_Level_1(size: CGSizeMake(2048, 1536))
            loadedScene.levelName = levelName
            loadedScene.loadAll()

            //W1_Level_1.unarchiveFromFile("W1_Level_1") as? W1_Level_1
            
    
            dispatch_async(dispatch_get_main_queue()) { completionHandler(loadedScene) }
            
        }
    }
    
    func loadWorld() {
        
        //self.worldLayer.setScale(0.1)

        self.worldLayer.setScale(Constants.defaultScale)
        
        layers = [self.backMountainLayer, self.frontMoutainLayer, self.backCloudLayer, self.frontCloudLayer, self.platformLayer, self.upperCloudLayer, self.levelsLayer]


        


//       populateLayersFromWorld(templateWorld)
        
        self.map = JSTileMap(named: "\(levelName).tmx")

        let map_layer = map.layerNamed("Walls")
        map_layer.zPosition = Constants.zPosWall
        
        //let preenchimento = map.layerNamed("preenchimento")
        //preenchimento.zPosition = Constants.zPosWall


        createNodesFromLayer(map_layer)
        
        let spikes = map.layerNamed("Spikes")
        spikes.zPosition = Constants.zPosWall
        //createNodesFromLayer(spikes)
        //createPhysicalBodiesWalls(self.map)
//        createPhysicalBodiesSpikes(self.map)

        createPhysicalBodies(self.map, groupNamed: "Corpos", friction: 1, bitMask: ColliderType.Wall.rawValue)
        createPhysicalBodies(self.map, groupNamed: "Espinho", friction: 0.3, bitMask: ColliderType.Spike.rawValue)

        
        for l in layers {
            self.worldLayer.addChild(l)
        }
        
        map_layer.removeFromParent()
        self.worldLayer.addChild(map_layer)
        
        spikes.removeFromParent()
        self.worldLayer.addChild(spikes)

        //self.worldLayer.addChild(spikes)


        self.worldLayer.name = "worldLayer"

        self.worldLayer.addChild(self.ninja)
        self.worldLayer.addChild(self.camera)
        self.addChild(self.worldLayer)
        
        Constants.defaultSpawnPoint = getStartPosition(map, groupName: "Ninja", name: "ninja")
        Constants.defaultGroundPoint = getStartPosition(map, groupName: "Ground", name: "ground")
        Constants.minCamPos = Constants.defaultGroundPoint.y + self.scene!.size.height/2
        

//        self.worldLayer.position = CGPointMake(self.worldLayer.position.x - Constants.defaultGroundPoint.x, self.worldLayer.position.y - v)
        
//        self.worldLayer.
        
        centerWorldOnPoint(CGPointMake(Constants.defaultSpawnPoint.x, Constants.minCamPos))

    }
    
    func createPhysicalBodies(tileMap: JSTileMap, groupNamed : String, friction : CGFloat, bitMask : UInt32 ){
        
        let group = tileMap.groupNamed(groupNamed)
        let allObjects = group.objects
        
        for bodysObject in allObjects{
            
            let x : NSNumber = bodysObject.objectForKey("x") as! NSNumber
            let y : NSNumber = bodysObject.objectForKey("y") as! NSNumber
            
            let w : NSNumber = (bodysObject.objectForKey("width") as! String).toInt()!
            let h : NSNumber = (bodysObject.objectForKey("height") as! String).toInt()!
            
            let body = SKSpriteNode()
            body.size = CGSizeMake( CGFloat(w) , CGFloat(h) )
            body.anchorPoint = CGPointMake(0, 0)
            body.position = CGPointMake( CGFloat(x) + CGFloat(w)/2 , CGFloat(y) + CGFloat(h)/2 )
            body.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( CGFloat(w) , CGFloat(h) ), center: CGPointMake(1, 1))
            body.physicsBody?.restitution = 0.0
            body.physicsBody!.categoryBitMask = bitMask
            body.physicsBody!.dynamic = false
            body.physicsBody!.friction = friction
            
            self.platformLayer.addChild(body)
        }
    }
    
//    func createPhysicalBodiesSpikes(tileMap: JSTileMap){
//        
//        let group = tileMap.groupNamed("Espinho")
//        let allObjects = group.objects
//        
//        for bodysObject in allObjects{
//            
//            let x = bodysObject["x"] as? NSNumber
//            let y = bodysObject["y"] as? NSNumber
//            
//            let w = (bodysObject["width"] as! String).toInt()
//            let h = (bodysObject["height"] as! String).toInt()
//            
//            let body = SKSpriteNode()
//            body.size = CGSizeMake( CGFloat(w!) , CGFloat(h!) )
//            body.anchorPoint = CGPointMake(0, 0)
//            body.position = CGPointMake( CGFloat(x!) + CGFloat(w!)/2 , CGFloat(y!) + CGFloat(h!)/2 )
//            body.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( CGFloat(w!) , CGFloat(h!) ), center: CGPointMake(1, 1))
//            body.physicsBody?.restitution = 0.0
//            body.physicsBody!.categoryBitMask = ColliderType.Spike.rawValue
//            body.physicsBody!.dynamic = false
//            body.physicsBody!.friction = 0.3
//            
//            self.platformLayer.addChild(body)
//        }
//    }

    
    
    func createNodesFromLayer(layer: TMXLayer) {
        
        let map = layer.map
        

//        let espinho_tile = SKTexture(imageNamed: "espinho_tile")
//        let espinho_tile_direito = SKTexture(imageNamed: "espinho_tile_direito")
//        let espinho_tile_invertido = SKTexture(imageNamed: "espinho_tile_invertido")
//        let espinho_tile_esquerdo = SKTexture(imageNamed: "espinho_tile_esquerdo")
//
//
//        let spikesArray = [espinho_tile, espinho_tile_direito, espinho_tile_invertido, espinho_tile_esquerdo]
        

        for w in 0..<Int(layer.layerInfo.layerGridSize.width) {

            for h in 0..<Int(layer.layerInfo.layerGridSize.height) {
                

                let coord = CGPoint(x: w, y: h)
                let tileGid = layer.layerInfo.tileGidAtCoord(coord)
                
                if tileGid == 0 || tileGid == 103 || tileGid == 175{
                    continue
                }
                
                if let properties = map.propertiesForGid(tileGid) {
                    
                    let tile = layer.tileAtCoord(coord)

//                    if properties["wall"] != nil {
//                        //setPhysicBody(tile, pos: (w, h))
//                        
//                        tile.physicsBody = SKPhysicsBody(rectangleOfSize:tile.size)
//                        tile.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
//                        tile.physicsBody!.dynamic = false
//                        tile.physicsBody!.friction = 0
//
//                    }
                    
                    if properties["isRotate"] != nil {
                        let rotation = (properties["isRotate"] as! String!).toInt()
                        //if(rotation != nil) {
                            let radians = ConvertUtilities.degreesToRadians(CGFloat(rotation!))
                            
                            let rotateAction = SKAction.rotateByAngle(radians, duration: NSTimeInterval(2.0))
                            
                            let action = SKAction.repeatActionForever(rotateAction)
                            tile.runAction(action)
                        
                            tile.physicsBody = SKPhysicsBody(rectangleOfSize:tile.size)
                            tile.physicsBody!.dynamic = false
                            //tile.physicsBody?.affectedByGravity = false
                            tile.physicsBody!.friction = 0.9
                            tile.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
                        
                        tile.name = "mWall"

                        
                        //}

                        
                    }

                    
                    if properties["isMoveable"] != nil {
                        
                        let steps = (properties["isMoveable"] as! String!).toInt()
                        let direction = (properties["direction"] as! String!).toInt()
                        let speed = (properties["speed"] as! String!).toInt()

                        //let wall = (properties["wall"] as String!).toInt()

                        tile.physicsBody = SKPhysicsBody(rectangleOfSize:tile.size)
                        tile.physicsBody!.dynamic = false
                        //tile.physicsBody?.affectedByGravity = false
                        tile.physicsBody!.friction = 0.9
                        tile.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
                        //tile.physicsBody?.contactTestBitMask = ColliderType.Ninja.rawValue
                        //tile.physicsBody?.collisionBitMask = ColliderType.Ninja.rawValue
                        tile.name = "mWall"
                        
                        //if(steps != nil) {
                            tile.runAction(self.getMoveAction(steps!, direction: direction!, speed: speed!))
                        //}
                        
                        //
                    }
//
//                    if properties["spike"] != nil {
//                        
//                        let spikeProp = (properties["spike"] as String!).toInt()
//                        
//                        tile.physicsBody = SKPhysicsBody(texture: spikesArray[spikeProp!], alphaThreshold: 0.5, size: tile.size)
//                        tile.texture = spikesArray[spikeProp!]
//                        tile.physicsBody!.dynamic = false
//                        tile.physicsBody!.friction = 0
//                        tile.physicsBody!.categoryBitMask = ColliderType.Spike.rawValue
//                        
//                    }

                }
            }
        }
    }
    
    func getMoveAction(steps : Int, direction : Int, speed : Int) -> SKAction {
        
        var move : SKAction!
        var moveBack : SKAction!

        let k : CGFloat! = 50
        let defaultSpeed : CGFloat = 3.0
        
        switch(direction){
            
            
            //Direita
            case 1:
                move = SKAction.moveByX(CGFloat(steps) * k, y: 0, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                moveBack = SKAction.moveByX(-CGFloat(steps) * k, y: 0, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                break
            
            //Esquerda
            case 2:
                move = SKAction.moveByX(-CGFloat(steps) * k, y: 0, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                moveBack = SKAction.moveByX(CGFloat(steps) * k, y: 0, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
            break
            
            //Cima
            case 3:
                move = SKAction.moveByX(0, y: CGFloat(steps) * k, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                moveBack = SKAction.moveByX(0, y: -CGFloat(steps) * k, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                break
            
            //Cima
            case 4:
                move = SKAction.moveByX(0, y: -CGFloat(steps) * k, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                moveBack = SKAction.moveByX(0, y: CGFloat(steps) * k, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                break

            default:
                move = SKAction.moveByX(CGFloat(steps) * k, y: 0, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
                moveBack = SKAction.moveByX(-CGFloat(steps) * k, y: 0, duration: NSTimeInterval(defaultSpeed / CGFloat(speed)))
            break
            
        }
        
        return SKAction.repeatActionForever(SKAction.sequence([move, moveBack]))

        
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
                firstTile!.physicsBody!.friction = 1
                
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
            
            let c = cloud.copy() as! SKSpriteNode
            c.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            self.backCloudLayer.addChild(c)
            
            let cc = cloud_clara.copy() as! SKSpriteNode
            cc.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            self.frontCloudLayer.addChild(cc)
        
        }
        
        backCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y + self.size.height/18)
        
        frontCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y + self.size.height/18 - 35)

        backCloudLayer.zPosition = Constants.zPosCloudBack
        frontCloudLayer.zPosition = Constants.zPosCloudFront

        
        self.animateClouds()
        
    }
    
    func loadBackground(){
        
        
        let montain = SKSpriteNode(texture: SKTexture(imageNamed: "montanha_escura"))
        let montain_clara = SKSpriteNode(texture: SKTexture(imageNamed: "montanha_clara"))

        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)

        let numberOfMontains = Int(map_width / montain.size.width)

        for index in 0...numberOfMontains {
            
            //Montanha Escura
            let m = montain.copy() as! SKSpriteNode
            
            let randomDis = CGFloat(arc4random_uniform(50))/100 + 0.5
            let randomScale = CGFloat(arc4random_uniform(100))/100 + 0.3

            
            m.position = CGPointMake(CGFloat(index) * montain.size.width * randomDis, 0)
            m.setScale(randomScale)
            m.anchorPoint = CGPointMake(0.5,0)
            
            self.frontMoutainLayer.addChild(m)
            
            
            
            //Montanha Clara
            let mC = montain_clara.copy() as! SKSpriteNode
            
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
    
    func loadUpperClouds(){
        
        let cloud = SKSpriteNode(texture: SKTexture(imageNamed: "flat_cloud"))
        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)
        
        let numberOfClouds = 300//Int(map_width / cloud.size.width)

        for index in 0...numberOfClouds {
            
            let c = cloud.copy() as! SKSpriteNode
            
            let randomPos = CGFloat(arc4random_uniform(80))/100 + 0.1
            let randomScale = CGFloat(arc4random_uniform(80))/100 + 0.2
            let randomDis = CGFloat(arc4random_uniform(100))/100 + 0.4

            
            c.setScale(randomScale)
            c.alpha = 0.4
            c.position = CGPointMake(CGFloat(index) * cloud.size.width * randomDis, self.frame.height * randomPos * 3)
            self.upperCloudLayer.addChild(c)

            
        }
        
        self.upperCloudLayer.position = CGPointMake(0, Constants.defaultGroundPoint.y + 300)
        
        self.upperCloudLayer.zPosition = Constants.zPosUpperCloud


    }
    
    func loadLevels(){
        
        println("tamnho tela = \(self.size)")
        
        let scene = SKScene(fileNamed: "teste")
        
        let templateWorld = scene.children.first!.copy() as! SKNode
        templateWorld.zPosition = 500
        //templateWorld.
        //templateWorld.setScale(0.5)
        templateWorld.position = CGPointMake(0, 0)
        
        self.teste = templateWorld
        self.addChild(teste)
        
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
    
    func loadNinja2(){
        
        let ninja = Ninja()
        //ninja.position = Constants.defaultSpawnPoint
        ninja.spin()
        ninja.currentPosition = self.ninja.position
        self.addChild(ninja)
        //ninja.antPosition = self.ninja.currentPosition
        
        //ninjaCurrentPositionScene = self.worldLayer.convertPoint(self.ninja.position, fromNode: self)
        //ninjaAntPositionScene = self.ninjaCurrentPositionScene
        
        //self.ninja.jump(amountToMoveX: 0, amountToMoveY: -100)
        
    }
    
    
    func loadAll(){
        self.loadWorld()
//        self.loadHud()
//        self.loadLevels()
        
        self.gameStarted = true
        self.loadPhysics()
        self.loadNinja()
        self.loadClouds()
        self.loadBackground()
        self.loadUpperClouds()
    }
    
    override func didMoveToView(view: SKView) {
        
        println("didmoveToView")
        //self.backgroundColor = SKColor.whiteColor()
//        dispatch_async(Constants.backgroundQueue) {
//        
//
//
//            
//            //self.centerWorldOnPosition(Constants.defaultSpawnPoint)
//            
//            dispatch_async(dispatch_get_main_queue(), self.finishedMovingToView)
//            
//        }
      
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
        
//        println("ninja y: \(self.ninja.position.y)")
//        println("ground y: \(Constants.defaultGroundPoint.y)")
//        println("mimCam y: \(Constants.minCamPos)")
        var point : CGPoint!
        if(self.ninja.isInMoveable && self.ninja.mWall != nil) {
            
            if(self.ninja.mWall.node!.position.y + self.ninja.position.y > Constants.minCamPos){
                point = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, self.ninja.mWall.node!.position.y + self.ninja.position.y)
            }
            else {
                point = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, Constants.minCamPos)
                
            }

        }
        else {
            if(self.ninja.position.y > Constants.minCamPos){
                point = self.ninja.position
            }
            else {
                point = CGPointMake(self.ninja.position.x, Constants.minCamPos)
                
            }

        }


        
        centerWorldOnPoint(point)

    }
    
    func centerWorldOnPoint(point : CGPoint) {
        
        
        
        var cameraPositionInScene = self.worldLayer.scene?.convertPoint(point, fromNode: worldLayer)
        
        var y :CGFloat = cameraPositionInScene!.y
        
        var posX = self.worldLayer.position.x - cameraPositionInScene!.x
        var posY = self.worldLayer.position.y - cameraPositionInScene!.y
        
        self.worldLayer.position = CGPointMake(posX, posY)
        
        let parallaxAmount : CGFloat = 1.2
        let parallaxAmountBack : CGFloat = 1.1

        
        //Parallax Montain
        posX = self.frontMoutainLayer.position.x + cameraPositionInScene!.x / parallaxAmount
        posY = self.frontMoutainLayer.position.y + cameraPositionInScene!.y / parallaxAmount
        self.frontMoutainLayer.position = CGPointMake(posX, posY)
        
        //Parallax Montain Back
        posX = self.backMountainLayer.position.x + cameraPositionInScene!.x / parallaxAmountBack
        posY = self.backMountainLayer.position.y + cameraPositionInScene!.y / parallaxAmountBack
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
        
        if(self.lastUpdate > 0){
            self.delta = currentTime - self.lastUpdate
        }
        else{
            self.delta = 0
        }
        self.lastUpdate = currentTime
        
        //Move Upper Clouds
        self.upperCloudLayer.position = CGPointMake(self.upperCloudLayer.position.x - 50 * CGFloat(self.delta), self.upperCloudLayer.position.y)
        
        
        
        //Check for gameover
        if(self.ninja.position.y < -Constants.defaultGroundPoint.y/8 ){
            
            self.runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: true))

            self.ninja.isDead = true
            self.restart()
            
        }
        
        if(self.ninja.isInMoveable && self.ninja.physicsBody!.pinned == false) {
            if(self.ninja.position.x != self.ninjaPosTemp.x || self.ninja.position.y != self.ninjaPosTemp.y) {
                self.mWallTempo.categoryBitMask = ColliderType.Wall.rawValue
                self.ninja.isInMoveable = false
            }
        }
        
    }
    
    
    // MARK: Collision

    func didBeginContact(contact: SKPhysicsContact) {
        
        //ninja.position.x = 0
        
        
            let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
            switch(contactMask){
                
                case ColliderType.Wall.rawValue | ColliderType.Ninja.rawValue:
                    
                    if(self.ninja.isDead == false) {
                        self.physicsWorld.speed = 0

    //                      self.ninja.physicsBody?.dynamic = false
    //                    var ninjaNode : SKNode!
    //                    var wallNode : SKNode!
    //
    //                    if(contact.bodyA.node!.isEqual(self.ninja)){
    //                        wallNode = contact.bodyB.node!
    //                    }
    //                    
    //                    else {
    //                        
    //                        wallNode = contact.bodyA.node!
    //                    }
                        
    //                    ninjaNode.removeFromParent()
//    //                    wallNode.addChild(ninjaNode)
//                        if(contact.bodyA.node?.name != "mWall" && contact.bodyB.node?.name != "mWall") {
//                            self.ninja.isInMoveable = false
//                        }
                    
                        println("colidiu com plataforma")
                        self.ninja.isMoving = false
                        let dirColision = contact.contactNormal
                        
                        if(!self.ninja.isInMoveable) {

                            if(contact.bodyA.node?.name == "mWall") {
                                self.ninja.mWall = contact.bodyA!
                            }
                            else if(contact.bodyB.node?.name == "mWall") {
                                self.ninja.mWall = contact.bodyB!
                            }
                            if(self.ninja.mWall != nil) {
                                
                                self.ninja.removeFromParent()
                                
                                self.ninja.mWall.categoryBitMask = 99
                                self.ninja.mWall.node!.addChild(self.ninja)
                                self.ninja.physicsBody!.pinned = true
                                self.ninja.isInMoveable = true
                                //self.ninja.mWallInitialPosition = self.ninja.mWall.p
                            }
                        }

                        
                        if(dirColision.dx > 0.0){
                            self.ninja.nail_right()
                        }
                        else if(dirColision.dx < 0.0){
                            self.ninja.nail_left()
                            self.ninja.lookTo(self.ninja.eyes, angle: -120)
                        }
                        else {
                            //0.9 = moveable
                            self.ninja.nail_down()
                        }
                        
                        let wallSE = SKAction.playSoundFileNamed("wall.wav", waitForCompletion: true)
                        self.runAction(wallSE)
                        
                        self.ninja.IdleAnimation()
                    
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
    
    func didEndContact(contact: SKPhysicsContact) {
//        if(self.ninja.isInMoveable) {
//            self.ninja.isInMoveable = false
//
//        }
    }

    
    // MARK: Touch

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        
        for touch: AnyObject in touches{
            
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            println("comecou toque")

//            if(self.HUD!.pauseButton!.containsPoint(self.HUD!.convertPoint(location, fromNode: self))){
//                println("comecou toque2")
//
//                //self.gameStarted = false
//                //self.HUD?.moveButtonsInScreen()
//                self.teste.runAction(SKAction.moveBy(CGVectorMake(0, self.scene!.size.height*2), duration: NSTimeInterval(1.0)))
//                self.frontCloudLayer.runAction(SKAction.moveBy(CGVectorMake(0, self.scene!.size.height*2), duration: NSTimeInterval(1.0)))
//
//                
//            }
            
//            if(self.HUD!.stageButton!.containsPoint(location) && self.gameStarted == false){
//                println("comecou toque3")
//
//                //self.showLeader()
//            }
            
            if(self.gameStarted && !self.ninja.isDead && !self.ninja.isMoving){
                println("comecou toque4")

                self.initialTapPosition = location
                self.isDraging = true
            }
//            else{
//                println("comecou toque5")
//
//                
//                if(self.HUD!.playButton!.containsPoint(location) && self.gameStarted == false){
//                    
//                    self.startGame()
//                }
//                else{
//                    
//                    if(self.gameStarted == true){
//                        
//                        
//                    }
//                }
//                
//                
//            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        

        if(self.isDraging == true && self.gameStarted == true && !self.ninja.isDead){
            
            let touch: AnyObject = (touches.first as? UITouch)!
            self.actualTouchLocation = touch.locationInNode(self)
            self.finalTapPosition = touch.locationInNode(self)
            
            var speedX = self.initialTapPosition.x - self.actualTouchLocation.x
            var speedY = self.initialTapPosition.y - self.actualTouchLocation.y
            
            var distance = sqrt( pow(speedX, 2) + pow(speedY, 2))
            var realDistance = distance
            
            if(distance > Constants.minDistanceSlide){
                
                distance = Constants.minDistanceSlide
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
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    
        println("terminou")

        
        if(self.isDraging == true && self.gameStarted == true && self.ninja.isMoving == false && !self.ninja.isDead){
            
//            self.worldLayer.addChild(ninja)
//            self.ninja.physicsBody?.dynamic = true
//            self.ninja.removeFromParent()
            self.physicsWorld.speed = 1
            
            if(self.ninja.isInMoveable) {
                self.ninja.physicsBody!.pinned = false
                self.ninjaPosTemp = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, self.ninja.mWall.node!.position.y + self.ninja.position.y)
                self.mWallTempo = self.ninja.mWall
                self.ninja.mWall = nil

                self.ninja.removeFromParent()
                self.worldLayer.addChild(ninja)
                self.ninja.position = self.ninjaPosTemp

            }

            
            self.isDraging = false
            self.ninja.isMoving = true
            
            let touch: AnyObject = (touches.first as? UITouch)!
            
            self.finalTapPosition = touch.locationInNode(self)
            
            var speedX = self.initialTapPosition.x - self.finalTapPosition.x
            var speedY = self.initialTapPosition.y - self.finalTapPosition.y
            
            let speed = ConvertUtilities.minMaxSpeed(speedX, sY: speedY)
            

            self.ninja.jump(amountToMoveX: speed.0, amountToMoveY: speed.1)
            
            

            
            
            self.score += 1
            
        }
    }
    
    
    

}
