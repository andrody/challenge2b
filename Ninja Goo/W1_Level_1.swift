//
//  GameScene.swift
//  Ninja Goo
//
//  Created by Andrew on 4/2/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    func aspectFillToSize(fillSize: CGSize) {
        
        if texture != nil {
            self.size = texture!.size()
            
            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width
            
            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
            
            self.setScale(scaleRatio)
        }
    }
    
}


class W1_Level_1: SKScene, SKPhysicsContactDelegate {

    // MARK: Properties
    
    var levelName : String!
    
    //HUD
    
    var pauseButton: SKSpriteNode!

    var setaButton: SKSpriteNode!

    
    let hudLayer = SKNode()

    var iphoneEqualizer : CGFloat = 0
    
    var worldScale : CGFloat!
    
    var endLevel = false

    var didShowTutorial = false
    
    var spikeTexture : SKTexture!

    //Tutorial
    
    var tutorial : SKSpriteNode!
    var vidro : SKSpriteNode!


    //Scores
    var score:Int = 0
    var jumps : Int = 0
    var diedForAd : Int = 0
    
    var teste : SKNode!
    
    var mWallTempo2 : SKPhysicsBody!

    
    var ninjaPosTemp : CGPoint!
    var mWallTempo : SKPhysicsBody!
    
    var fallerWalls : [SKNode]! = []
    
    //Positions
    var lastBackgroundPositionX: CGFloat = 0.0
    var lastPlatformPositionX: CGFloat = 500.0

    //Ninja
    var ninja : Ninja! = Ninja()
    let ninjaLayer = SKNode()
    
    var portal : SKSpriteNode!
    
    //Mountais
    let frontMoutainLayer = SKNode()
    let backMountainLayer = SKNode()
    
    //Clouds
    let frontCloudLayer = SKNode()
    let middleCloudLayer = SKNode()
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
        static var defaultPortalPoint = CGPoint(x: 0, y: 0)
        static let defaultScale :CGFloat = 1.0
        static let defaultLanscapeIphone :CGFloat = 1.5
        static let defaultPortraitIphone :CGFloat = 1.3


        static var defaultGroundPoint : CGPoint!
        
        static var minCamPos : CGFloat!
        static var cameraXOffset : CGFloat! = -250
        static let gravity = CGVectorMake(0, -50)
        static let minForce : CGFloat = 30.0
        static let maxForce : CGFloat = 80.0
        static let maxForceGeral : CGFloat = maxForce
        static var maxDistanceSlide : CGFloat = 400.0

        
        static let zPosBackgroundBackLayer : CGFloat = 1
        static let zPosBackgroundFrontLayer : CGFloat = 2
        static let zPosUpperCloud : CGFloat = 3
        static let zPosCloudBack : CGFloat = 4
        static let zPosWall : CGFloat = 5
        static let zPosCloudFront : CGFloat = 6




        static let backgroundQueue = dispatch_queue_create("com.koruja.ningoo.backgroundQueue", DISPATCH_QUEUE_SERIAL)
        
    }
    
    // MARK: Asset Pre-loading
    
    class func loadSceneAssetsWithCompletionHandler(level : Scenario, completionHandler: W1_Level_1 -> Void) {
        dispatch_async(Constants.backgroundQueue) {
            
            let loadedScene = W1_Level_1(size: CGSizeMake(2048, 1536))
            loadedScene.levelName = level.nome
            SceneManager.sharedInstance.faseEscolhida = level
            
            loadedScene.loadAll()

            //W1_Level_1.unarchiveFromFile("W1_Level_1") as? W1_Level_1
            
    
            dispatch_async(dispatch_get_main_queue()) { completionHandler(loadedScene) }
            
        }
    }
    
    
    func loadWorld() {
        
        changeSliceDistance()
        //self.worldLayer.setScale(0.1)

        self.worldLayer.setScale(Constants.defaultScale)
        self.worldScale = Constants.defaultScale
        
        let corFundo = SceneManager.sharedInstance.faseEscolhida.corFundo
        self.backgroundColor = SKColor(red: corFundo[0]/255.0, green: corFundo[1]/255.0, blue: corFundo[2]/255.0, alpha: 1)
        
        layers = [self.backMountainLayer, self.frontMoutainLayer, self.backCloudLayer, self.frontCloudLayer, self.middleCloudLayer, self.platformLayer, self.upperCloudLayer, self.levelsLayer]


        self.platformLayer.zPosition = Constants.zPosWall

        self.addChild(hudLayer)

//       populateLayersFromWorld(templateWorld)
        
        self.map = JSTileMap(named: "\(levelName).tmx")

        let map_layer = map.layerNamed("Walls")
        
        let wallColor = SceneManager.sharedInstance.faseEscolhida.corPlataforma
        
        
//        map_layer.color = SKColor(red: wallColor[0]/255, green: wallColor[1]/255, blue: wallColor[2]/255, alpha: 1.0)
//        map_layer.colorBlendFactor=1
        
        map_layer.zPosition = Constants.zPosWall
        
        //let preenchimento = map.layerNamed("preenchimento")
        //preenchimento.zPosition = Constants.zPosWall


        createNodesFromLayer(map_layer)
        
        let spikes = map.layerNamed("Spikes")
        spikes.zPosition = Constants.zPosWall
        changeSpikesTexture(spikes)
        //createNodesFromLayer(spikes)
        //createPhysicalBodiesWalls(self.map)
//        createPhysicalBodiesSpikes(self.map)

        createPhysicalBodies(self.map, groupNamed: "Corpos", friction: 1, bitMask: ColliderType.Wall.rawValue)
        createPhysicalBodies(self.map, groupNamed: "Espinho", friction: 0.3, bitMask: ColliderType.Spike.rawValue)

        
        for l in layers {
            self.worldLayer.addChild(l)
        }
        
        map_layer.removeFromParent()
        self.platformLayer.addChild(map_layer)
        
        spikes.removeFromParent()
        self.platformLayer.addChild(spikes)

        //self.worldLayer.addChild(spikes)


        self.worldLayer.name = "worldLayer"

        self.worldLayer.addChild(self.ninja)
        self.worldLayer.addChild(self.camera)
        self.addChild(self.worldLayer)
        
        Constants.defaultSpawnPoint = getStartPosition(map, groupName: "Ninja", name: "ninja")
        Constants.defaultPortalPoint = getStartPosition(map, groupName: "Portal", name: "portal")
        Constants.defaultGroundPoint = getStartPosition(map, groupName: "Ground", name: "ground")
        Constants.minCamPos = Constants.defaultGroundPoint.y + self.scene!.size.height/2
        
        
        //Portal
        self.portal = SKSpriteNode(texture: SKTexture(imageNamed: "portal"))
        self.portal.name = "portal"
        self.portal.anchorPoint = CGPointMake(0.5 , 0.5)
        self.portal.zPosition = 90
        self.portal.setScale(0.2)
        self.portal.position = Constants.defaultPortalPoint
        
        let movePortal = SKAction.moveByX(0, y: 10, duration: 0.6)
        let movePortalBack = SKAction.moveByX(0, y: -10, duration: 0.6)
        self.portal.physicsBody = SKPhysicsBody(rectangleOfSize: self.portal.size)
        self.portal.physicsBody!.categoryBitMask = ColliderType.Portal.rawValue
        self.portal.physicsBody!.dynamic = false
        
//        let radians = ConvertUtilities.degreesToRadians(CGFloat(360))
        
//        let rotateAction = SKAction.rotateByAngle(radians, duration: NSTimeInterval(3.0))
//        let rotateActionBack = SKAction.rotateByAngle(radians, duration: NSTimeInterval(5.0))
//        let scale = SKAction.scaleTo(0.185, duration: NSTimeInterval(1.0))
//        let scale2 = SKAction.scaleTo(0.2, duration: NSTimeInterval(0.8))
//
        let moveForever = SKAction.repeatActionForever(SKAction.sequence([movePortal, movePortalBack]))
//        let moveForever2 = SKAction.repeatActionForever(SKAction.sequence([scale,scale2]))

        portal.runAction(moveForever)
        //portal.runAction(moveForever2)


        
        self.worldLayer.addChild(self.portal)
        

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
            
            var diminuidor : Int = 0
            if(bitMask == ColliderType.Spike.rawValue) {
                diminuidor = 40
            }

            body.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( CGFloat(w.integerValue - diminuidor) , CGFloat(h.integerValue - diminuidor) ), center: CGPointMake(1, 1))
            body.physicsBody?.restitution = 0.0
            body.physicsBody!.categoryBitMask = bitMask
            body.physicsBody!.dynamic = false
            body.physicsBody!.friction = friction
            
//            if(bitMask == ColliderType.Spike.rawValue) {
//                if (self.spikeTexture == nil) {
//                    self.spikeTexture = SKTexture(imageNamed: "espinho_tile_128")
//                }
//                body.texture = self.spikeTexture
//            }
            
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

    func changeSpikesTexture(layer: TMXLayer) {
        
        let map = layer.map
        
        
        let espinho_tile = SKTexture(imageNamed: "espinho_tile")
        let espinho_tile_direito = SKTexture(imageNamed: "espinho_tile_direito")
        let espinho_tile_invertido = SKTexture(imageNamed: "espinho_tile_invertido")
        let espinho_tile_esquerdo = SKTexture(imageNamed: "espinho_tile_esquerdo")


        let spikesArray = [espinho_tile, espinho_tile_direito, espinho_tile_invertido, espinho_tile_esquerdo]

        
        for w in 0..<Int(layer.layerInfo.layerGridSize.width) {
            
            for h in 0..<Int(layer.layerInfo.layerGridSize.height) {
                
                
                let coord = CGPoint(x: w, y: h)
                let tileGid = layer.layerInfo.tileGidAtCoord(coord)
                
                if tileGid == 0 || tileGid == 103 || tileGid == 175{
                    continue
                }
                
                if let properties = map.propertiesForGid(tileGid) {
                    
                    let tile = layer.tileAtCoord(coord)
                    
                    if properties["spike"] != nil {
                        
                        let spikeProp = (properties["spike"] as! String!).toInt()
                        
//                        if (self.spikeTexture == nil) {
//                            self.spikeTexture = SKTexture(imageNamed: "espinho_tile_128"
//                        }
                        tile.texture = spikesArray[spikeProp!]
                        
                        
                    }
                    
                }
            }
        }

        
    }
    
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
                    
                    if properties["isRotate"] != nil {
                        let rotation = (properties["isRotate"] as! String!).toInt()
                        //if(rotation != nil) {
                        let radians = ConvertUtilities.degreesToRadians(CGFloat(rotation!))
                        
                        let rotateAction = SKAction.rotateByAngle(radians, duration: NSTimeInterval(5.0))
                        
                        let action = SKAction.repeatActionForever(rotateAction)
                        tile.runAction(action)
                        
                        tile.physicsBody = SKPhysicsBody(rectangleOfSize:tile.size)
                        tile.physicsBody!.dynamic = false
                        //tile.physicsBody?.affectedByGravity = false
                        tile.physicsBody!.friction = 0.9
                        tile.physicsBody!.categoryBitMask = ColliderType.RotateWall.rawValue
                        
                        let cMiddleColor = SceneManager.sharedInstance.faseEscolhida.corWallEspecial
                        
                        tile.colorBlendFactor = 1
                        tile.color = SKColor(red: cMiddleColor[0]/255, green: cMiddleColor[1]/255, blue: cMiddleColor[2]/255, alpha: 1.0)
                        
                        tile.name = "mWall"
                        
                        
                        //}
                        
                        
                    }
                    
                    if properties["isFaller"] != nil {
                        let duration = (properties["isFaller"] as! String!).toInt()
                        
                        tile.physicsBody = SKPhysicsBody(rectangleOfSize:tile.size)
                        tile.physicsBody!.dynamic = false
                        //tile.physicsBody!.linearDamping = CGFloat(duration!)
                        tile.physicsBody!.friction = 0.9
                        tile.physicsBody?.restitution = 0
                        tile.userData = NSMutableDictionary()
                        tile.userData?.setObject(duration!, forKey: "duration")
                        tile.userData?.setObject(false, forKey: "jaColidiu")

                        println("CATEGORY = \(tile.physicsBody!.categoryBitMask)")

                        
                        if(properties["isRotate"] != nil) {
                            tile.physicsBody!.categoryBitMask = ColliderType.FallerWall.rawValue | ColliderType.RotateWall.rawValue
                        }
                        
                        else {
                            tile.physicsBody!.categoryBitMask = ColliderType.FallerWall.rawValue
                        }
                        let cMiddleColor = SceneManager.sharedInstance.faseEscolhida.corWallEspecial
                        
                        tile.colorBlendFactor = 1
                        tile.color = SKColor(red: cMiddleColor[0]/255, green: cMiddleColor[1]/255, blue: cMiddleColor[2]/255, alpha: 1.0)
                        
                        tile.name = "mWall"
                        tile.userData?.setObject(tile.copy(), forKey: "initialCopy")
                        self.fallerWalls.append(tile)
                        
                        
                    }

//
//                    if properties["spike"] != nil {
//                        
//                        let spikeProp = (properties["spike"] as! String!).toInt()
//                        
//                        if (self.spikeTexture == nil) {
//                            self.spikeTexture = SKTexture(imageNamed: "espinho_tile_128")
//                        }
//                        tile.texture = self.spikeTexture
//
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
    
    override func didChangeSize(oldSize: CGSize) {
        resizePositions()
    }
    
    
    
    func resizePositions(){
    
        changeSliceDistance()

        if (isLandscape()) {
            
            if(isIphone()){
                self.worldLayer.setScale(Constants.defaultLanscapeIphone)
                self.worldScale = Constants.defaultLanscapeIphone
            }
            
            if(self.pauseButton != nil) {
                self.pauseButton!.position = Hud.convertPointToIpadUp(CGPointMake(-self.size.width/2 + self.pauseButton.size.width + 20, self.size.height/2 - self.pauseButton.size.height - 200))
            }
        }
        else {
            if(isIphone()){
                self.worldLayer.setScale(Constants.defaultPortraitIphone)
                self.worldScale = Constants.defaultPortraitIphone

            }
            
            if(self.pauseButton != nil) {


                
                if(isIphone()){

                    self.pauseButton!.position = Hud.convertPointToIpadUp(CGPointMake(-self.size.height/2 + self.pauseButton.size.width*5, self.size.width/2 - self.pauseButton.size.height*4))
                }
                
                else {
                    self.pauseButton!.position = Hud.convertPointToIpadUp(CGPointMake(-self.size.height/2 + self.pauseButton.size.width*4 - 50, self.size.width/2 - self.pauseButton.size.height*4 - 200))
                }
            }
        }

    }
    
    func loadHud(){
        
        
        
        self.pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "pause"))
        self.pauseButton?.name = "pauseButton"
        self.pauseButton?.anchorPoint = CGPointMake(0.5 , 0.5)
        self.pauseButton?.zPosition = 90
        self.pauseButton?.setScale(0.7)
        //self.pauseButton?.alpha = 0.6
        
        
//        self.pauseButton!.position = CGPointMake(-self.scene!.frame.width/2 + 120, self.scene!.frame.height/2 - 120)
        println("SCRENN SIZZEEEEE = \(UIApplication.sharedApplication().statusBarOrientation)")
        println("SCRENN HEIGHTTTTT = \(self.size.height)")
        
        
        self.addChild(self.pauseButton)

        resizePositions()


        //Adding HUD
//        self.HUD = Hud(sceneSize: CGSizeMake(self.size.width, self.size.height))
//        self.HUD?.zPosition = 90
////        self.HUD?.addChild(HUD!.playButton!)
////        self.HUD?.addChild(HUD!.logo!)
////        //self.addChild(HUD!.pointsBoard!)
////        self.HUD?.addChild(HUD!.stageButton!)
//        self.HUD?.addChild(HUD!.pauseButton!)
//        
////        self.HUD?.moveButtonsInScreen()
//        
//        self.addChild(HUD!)
        //self.HUD?.setScale(0.1)
        
    }

    
    func loadPhysics(){
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = Constants.gravity
        self.anchorPoint = Constants.midAnchor
        
    }
    
    func loadClouds(){
        
        
        let cloud = SKSpriteNode(texture: SKTexture(imageNamed: "nuvem_clara"))

        let cBackColor = SceneManager.sharedInstance.faseEscolhida.corNuvemBack
        let cMiddleColor = SceneManager.sharedInstance.faseEscolhida.corNuvemMeio
        let cFrontColor = SceneManager.sharedInstance.faseEscolhida.corNuvemFront


        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)
        
        let numberOfClouds = Int(map_width / cloud.size.width) * 2
        
        for index in 0...numberOfClouds {
            
            //Cloud Back
            let cloud_back = cloud.copy() as! SKSpriteNode
            cloud_back.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            cloud_back.color = SKColor(red: cBackColor[0]/255, green: cBackColor[1]/255, blue: cBackColor[2]/255, alpha: 1.0)
            cloud_back.colorBlendFactor=1
            self.backCloudLayer.addChild(cloud_back)
            
            //Cloud Middle
            let cloud_middle = cloud.copy() as! SKSpriteNode
            cloud_middle.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            cloud_middle.color = SKColor(red: cMiddleColor[0]/255, green: cMiddleColor[1]/255, blue: cMiddleColor[2]/255, alpha: 1.0)
            cloud_middle.colorBlendFactor=1

            self.middleCloudLayer.addChild(cloud_middle)
            
            //Cloud Front
            let cloud_front = cloud.copy() as! SKSpriteNode
            cloud_front.position = CGPointMake(CGFloat(index) * cloud.size.width, 0)
            cloud_front.color = SKColor(red: cFrontColor[0]/255, green: cFrontColor[1]/255, blue: cFrontColor[2]/255, alpha: 1.0)
            cloud_front.colorBlendFactor=1
            
            self.frontCloudLayer.addChild(cloud_front)
        
        }
        
        backCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y + self.size.height/18 + 55)
        
        middleCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y + self.size.height/18)
        
        frontCloudLayer.position = CGPointMake(Constants.defaultGroundPoint.x - CGFloat(numberOfClouds) * cloud.size.width/4, Constants.defaultGroundPoint.y + self.size.height/18 - 55)

        backCloudLayer.zPosition = Constants.zPosCloudBack
        middleCloudLayer.zPosition = Constants.zPosCloudBack
        frontCloudLayer.zPosition = 999//Constants.zPosCloudFront

        
        self.animateClouds()
        
    }
    
    func loadBackground(){
        
        
        let montain = SKSpriteNode(texture: SKTexture(imageNamed: SceneManager.sharedInstance.faseEscolhida.backgroundFrontName))
        let montain_back = SKSpriteNode(texture: SKTexture(imageNamed: SceneManager.sharedInstance.faseEscolhida.backgroundBackName))

        
        let montainColor = SceneManager.sharedInstance.faseEscolhida.corMontanha
        let montainClaraColor = SceneManager.sharedInstance.faseEscolhida.corMontanhaClara

        
        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)

        let numberOfMontains = Int(map_width / montain.size.width)

        for index in 0...numberOfMontains {
            
            //Montanha Escura
            let m = montain.copy() as! SKSpriteNode
            m.color = SKColor(red: montainColor[0]/255, green: montainColor[1]/255, blue: montainColor[2]/255, alpha: 1.0)
            m.colorBlendFactor=1

            
            let randomDis = CGFloat(arc4random_uniform(50))/100 + 0.5
            let randomScale = CGFloat(arc4random_uniform(150))/100 + 0.3

            
            m.position = CGPointMake(CGFloat(index) * montain.size.width * randomDis, 0)
            m.setScale(randomScale)
            m.anchorPoint = CGPointMake(0.5,0)
            
            self.frontMoutainLayer.addChild(m)
            
            
            
            //Montanha Clara
            let mC = montain_back.copy() as! SKSpriteNode
            mC.color = SKColor(red: montainClaraColor[0]/255, green: montainClaraColor[1]/255, blue: montainClaraColor[2]/255, alpha: 1.0)
            mC.colorBlendFactor=1

            
            let randomDis2 = CGFloat(arc4random_uniform(150))/100 + 0.3
            let randomScale2 = CGFloat(arc4random_uniform(150))/100 + 0.3
            
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

        let cloudColor = SceneManager.sharedInstance.faseEscolhida.corMontanhaClara

        cloud.color = SKColor(red: cloudColor[0]/255, green: cloudColor[1]/255, blue: cloudColor[2]/255, alpha: 1.0)
        cloud.colorBlendFactor=1

        
        let map_width : CGFloat = CGFloat(self.map.mapSize.width * self.map.tileSize.width)
        
        let numberOfClouds = 300//Int(map_width / cloud.size.width)

        for index in 0...numberOfClouds {
            
            let c = cloud.copy() as! SKSpriteNode
            
            let randomPos = CGFloat(arc4random_uniform(80))/100 + 0.1
            let randomScale = CGFloat(arc4random_uniform(80))/100 + 0.2
            let randomDis = CGFloat(arc4random_uniform(100))/100 + 0.4

            let randomAlpha = CGFloat(arc4random_uniform(7))/10 + 0.3

            
            c.setScale(randomScale)
            c.alpha = randomAlpha
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
        
        let animateCloudUp_C = SKAction.moveByX(0, y: 20, duration: 2.0)
        let animateCloudDown_C = SKAction.moveByX(0, y: -20, duration: 0.7)
        let seqC = SKAction.sequence([animateCloudUp_C , animateCloudDown_C])
        let repeteC = SKAction.repeatActionForever(seqC)


        
        self.frontCloudLayer.runAction(repeteA, withKey: "move")
        self.backCloudLayer.runAction(repeteB, withKey: "move")
        self.middleCloudLayer.runAction(repeteC, withKey: "move")

        
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

        self.loadHud()
//        self.loadLevels()
        
        self.gameStarted = true
        self.loadPhysics()
        self.loadNinja()
        self.loadClouds()
        self.loadBackground()
        self.loadUpperClouds()
        self.loadTutorial()
        self.loadMusic()
    }
    
    func loadMusic(){
        SceneManager.sharedInstance.faseEscolhida.backGroundMusic = SceneManager.sharedInstance.loadAudio(SceneManager.sharedInstance.faseEscolhida.backgroundMusicName)
        SceneManager.sharedInstance.backGroundMusic.stop()
        SceneManager.sharedInstance.playMusic(SceneManager.sharedInstance.faseEscolhida.backGroundMusic)
        
    }
    
    func loadTutorial() {
        
        if(SceneManager.sharedInstance.faseEscolhida.levelNumber == 1) {
        
            self.hudLayer.zPosition = 1000
            
            vidro = SKSpriteNode(texture: SKTexture(imageNamed: "branco"), size: self.size)
            vidro.position = CGPointZero
            
            let color = SceneManager.sharedInstance.faseEscolhida.corNuvemBack
            vidro.colorBlendFactor = 1
            vidro.color = SKColor(red: color[0]/255, green: color[1]/255, blue: color[2]/255, alpha: 0.8)


            tutorial = SKSpriteNode(texture: SKTexture(imageNamed: "tutorial"), size: self.size)
            tutorial.position = CGPointZero
            tutorial.alpha = 1.0
            tutorial.aspectFillToSize(self.size)
            tutorial.setScale(1.0)
            
            
            self.hudLayer.addChild(vidro)
            self.hudLayer.addChild(tutorial)
            self.hudLayer.position = CGPointMake(0, -self.size.height)
            self.vidro.alpha = 0.95

        }
//        let color = SceneManager.sharedInstance.faseEscolhida.corNuvemBack
//        vidro.colorBlendFactor = 1
//        vidro.color = SKColor(red: color[0]/255, green: color[1]/255, blue: color[2]/255, alpha: 0.8)
        
    }
    
    func showTutorial(){
        self.runAction(SKAction.playSoundFileNamed(Sounds.tutorialAppears.rawValue, waitForCompletion: true))

        let move = SKAction.moveToY(0, duration: NSTimeInterval(0.4))
        let alpha = SKAction.fadeAlphaTo(0.95, duration: NSTimeInterval(0.5))
        //self.vidro.runAction(alpha)
        self.hudLayer.runAction(move)
    }
    
    func hideTutorial() {
        let move = SKAction.moveToY(-self.size.height, duration: NSTimeInterval(0.2))
        let alpha = SKAction.fadeAlphaTo(0, duration: NSTimeInterval(0.4) )
        self.vidro.runAction(alpha)
        self.tutorial.runAction(move, completion:  {
            self.hudLayer.removeAllChildren()
            self.vidro.hidden = true
            self.tutorial.hidden = true
            self.vidro = nil
            self.tutorial = nil
            })

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
    
    func saveRecord(){
        
        let distanceFromSpawn = self.portal.position.x - self.ninja.position.x
        let distancePortalFromSpawn = self.portal.position.x - Constants.defaultSpawnPoint.x
        
        println("fromSpawn = \(distanceFromSpawn)")
        println("distancePortalFromSpawn = \(distancePortalFromSpawn)")

        
        var percentage = Int(100 * (1 - distanceFromSpawn / distancePortalFromSpawn))
        
        if percentage >= 100 {
            percentage = 99
        }
        
        if(percentage > SceneManager.sharedInstance.faseEscolhida.distanceRecord ) {
            SceneManager.sharedInstance.faseEscolhida.distanceRecord = percentage
        }
        
        if (!SceneManager.sharedInstance.faseEscolhida.ended) {
            SceneManager.sharedInstance.faseEscolhida.attempts += 1
        }
        
    }
    
    func restart(){
        
        
        saveRecord()
        self.diedForAd += 1
        
        println("restart")
        
        //self.saveHighscore(self.score)
        self.score = 0
        self.jumps = 0
        //self.ninja.getRandomMask()
        self.ninja.isMoving = true
        //self.ninja.physicsBody?.collisionBitMask = 0
        self.ninja.physicsBody?.contactTestBitMask = 0

        self.ninja.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let moveninja = SKAction.moveTo(Constants.defaultSpawnPoint, duration: 0.5)
        
        let block = SKAction.runBlock({
            self.changeNinjaCollisionCategory()
            var new_faller_list : [SKNode]! = []
            for f: SKNode in self.fallerWalls {
                f.removeFromParent()
                let new_faller = f.userData!.objectForKey("initialCopy") as! SKNode
                new_faller.userData?.setObject(new_faller.copy(), forKey: "initialCopy")
                new_faller_list.append(new_faller)
                self.platformLayer.addChild(new_faller)
                
            }
            
            self.fallerWalls = new_faller_list

        })
    
        self.ninja.runAction( SKAction.sequence([moveninja, block]))
        
        
        
    }
    
    func changeNinjaCollisionCategory(){
        
        self.ninja.physicsBody?.contactTestBitMask = ColliderType.Wall.rawValue | ColliderType.Spike.rawValue | ColliderType.RotateWall.rawValue | ColliderType.FallerWall.rawValue | ColliderType.Portal.rawValue
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
        
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
//        
//            if(self.ninja.isInMoveable && self.ninja.mWall != nil) {
//                
//                if(self.ninja.mWall.node!.position.y + self.ninja.position.y > Constants.minCamPos){
//                    point = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, self.ninja.mWall.node!.position.y + self.ninja.position.y - 100)
//                }
//                else {
//                    point = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, Constants.minCamPos-100)
//                    
//                }
//                
//                
//                
//                
//            }
//            else {
//                if(self.ninja.position.y > Constants.minCamPos){
//                    point = self.ninja.position
//                }
//                else {
//                    point = CGPointMake(self.ninja.position.x, Constants.minCamPos - 100)
//                    
//                }
//                
//            }
//            
//        }
        
        
//        else {
        
        
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight {
                    
                    self.iphoneEqualizer = 267
                    
                }
                
                else {
                    self.iphoneEqualizer = 200
                }
            }

        
            if(self.ninja.isInMoveable && self.ninja.mWall != nil) {
                
                if(self.ninja.mWall.node!.position.y + self.ninja.position.y > Constants.minCamPos - iphoneEqualizer){
                        point = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, self.ninja.mWall.node!.position.y + self.ninja.position.y)
                }
                else {
                        point = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, Constants.minCamPos - iphoneEqualizer)
                    
                }
            
            }
            else {
                if(self.ninja.position.y > Constants.minCamPos - iphoneEqualizer){
                    point = self.ninja.position
                }
                else {
                    point = CGPointMake(self.ninja.position.x, Constants.minCamPos - iphoneEqualizer)
                
                }

            }
//        }


        
        centerWorldOnPoint(CGPointMake(point.x - Constants.cameraXOffset, point.y))

    }
    
    func centerWorldOnPoint(point : CGPoint) {
        
        
        
        var cameraPositionInScene = self.worldLayer.scene?.convertPoint(point, fromNode: worldLayer)
        
        var y :CGFloat = cameraPositionInScene!.y
        
        var posX = self.worldLayer.position.x - cameraPositionInScene!.x
        var posY = self.worldLayer.position.y - cameraPositionInScene!.y
        
        self.worldLayer.position = CGPointMake(posX, posY)
        
        let parallaxAmount : CGFloat = 1.2 * self.worldScale
        let parallaxAmountBack : CGFloat = 1.1 * self.worldScale


        
        //Parallax Montain
        posX = self.frontMoutainLayer.position.x + cameraPositionInScene!.x / parallaxAmount
        posY = self.frontMoutainLayer.position.y + cameraPositionInScene!.y / (parallaxAmount + 0.2)
        self.frontMoutainLayer.position = CGPointMake(posX, posY)
        
        //Parallax Montain Back
        posX = self.backMountainLayer.position.x + cameraPositionInScene!.x / parallaxAmountBack
        posY = self.backMountainLayer.position.y + cameraPositionInScene!.y / (parallaxAmountBack + 0.2)
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
        if(self.ninja.position.y < -Constants.defaultGroundPoint.y + -100*10){
            
            self.runAction(SKAction.playSoundFileNamed(Sounds.fall.rawValue, waitForCompletion: true))

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
    
    func shakeAndFall(node : SKNode, duration : CGFloat){
        self.mWallTempo2 = self.ninja.mWall
        
        //self.ninja.mWall = nil
        let shake = SKAction.moveBy(CGVectorMake(0, 15), duration: NSTimeInterval(0.1))
        let shakeBack = SKAction.moveBy(CGVectorMake(0, -15), duration: NSTimeInterval(0.1))
        let action = SKAction.repeatActionForever(SKAction.sequence([shake, shakeBack]))

        let wallSE = SKAction.playSoundFileNamed(Sounds.moveableWall.rawValue, waitForCompletion: false)
        node.runAction(wallSE, withKey: "shakingSound")

        node.runAction(action)
        
        var wait = SKAction.waitForDuration(NSTimeInterval(duration/1000))
        var run = SKAction.runBlock {
            node.removeActionForKey("shakingSound")

            node.removeAllActions()
            node.physicsBody!.linearDamping = 0
            node.physicsBody!.mass = 1000
            node.physicsBody!.dynamic = true
            //self.ninja.mWall = nil
            //self.ninja.mWall = self.mWallTempo2 //olhe AQUI
        }
        
        
        
        node.runAction(SKAction.sequence([wait, run]))
       
        
    }
    
    func colideComWall(contact: SKPhysicsContact){
        
        if(!didShowTutorial && SceneManager.sharedInstance.faseEscolhida.levelNumber == 1) {
            showTutorial()
        }
        
        println("diedForAd = \(self.diedForAd)")

        
        if(self.diedForAd >= 4) {
            NSNotificationCenter.defaultCenter().postNotificationName("showAd", object: nil)
            self.diedForAd = 0
        }
        
        if(contact.bodyA.node?.name == "mWall") {
            self.ninja.mWall = contact.bodyA!
        }
        else if(contact.bodyB.node?.name == "mWall") {
            self.ninja.mWall = contact.bodyB!
        }
        
        if(self.ninja.isDead == false) {
            self.physicsWorld.speed = 0
            
            
            println("colidiu com plataforma")
            self.ninja.isMoving = false
            let dirColision = contact.contactNormal
            
            if(!self.ninja.isInMoveable) {
                
                if(self.ninja.mWall != nil && self.ninja.mWall.node != nil) {
                    
                    self.ninja.removeFromParent()
                    
                    self.ninja.mWall.categoryBitMask = 99
                    self.ninja.mWall.node?.addChild(self.ninja)
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
            
            //SceneManager.sharedInstance.playCaf("character_land")

            
            self.ninja.IdleAnimation()
            
        }

    }
    
    // MARK : HUD
    
    func endsLevel() {
        
        let leaderboard = SceneManager.sharedInstance.faseEscolhida.rank
        SceneManager.sharedInstance.gameCenter.saveHighscore(self.jumps, leaderboard: leaderboard)
        
        SceneManager.sharedInstance.faseEscolhida.ended = true
        for (index, fase) in enumerate(SceneManager.sharedInstance.fases) {
            if fase.nome == SceneManager.sharedInstance.faseEscolhida.nome {
                if(SceneManager.sharedInstance.fases.endIndex - 1 != index) {
                    SceneManager.sharedInstance.fases[index + 1].locked = false
                }
                if(SceneManager.sharedInstance.fases.endIndex - 1 > index + 1) {
                    println("index = \(index)")
                    println("endindex = \(SceneManager.sharedInstance.fases.endIndex)")

                    SceneManager.sharedInstance.fases[index + 2].unlockable = true
                }
            }
            
        }
        
        self.ninja.physicsBody?.dynamic = false
        self.runAction(SKAction.playSoundFileNamed(Sounds.portal.rawValue, waitForCompletion: false))

        self.ninja.runAction(SKAction.fadeOutWithDuration(NSTimeInterval(0.3)))
        self.portal.runAction(SKAction.fadeOutWithDuration(NSTimeInterval(0.3)))

        self.ninja.alpha = 0
        
        self.hudLayer.alpha = 0
        endLevel = true
        self.pauseButton.hidden = true
        
        var distanceConstX : CGFloat = 320.0
        var distanceConstY : CGFloat = 100.0
        
        let distanceConstYInitial : CGFloat = 300.0

        var fontSize : CGFloat = 120

        if(isLandscape()){
            fontSize = fontSize * 1.5
            distanceConstY = distanceConstY * 1.5
            distanceConstX = distanceConstX * 1.5
        }
            
        
        let congrats = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        congrats.text = "WELL DONE!"
        congrats.fontSize = fontSize
        congrats.position = CGPointMake(-distanceConstX, distanceConstYInitial)
        congrats.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        
        let tries = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        tries.text = "ATTEMPT #\(SceneManager.sharedInstance.faseEscolhida.attempts)"
        tries.fontSize = fontSize/2
        tries.position = CGPointMake(-distanceConstX, distanceConstYInitial - distanceConstY)
        tries.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        
        
        let jumps = SKLabelNode(fontNamed: "HelveticaNeue-CondensedBlack")
        jumps.text = "\(self.jumps) JUMPS"
        jumps.fontSize = fontSize/2
        jumps.position = CGPointMake(-distanceConstX, distanceConstYInitial - distanceConstY * 1.85)
        jumps.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;

        
        let vidro = SKSpriteNode(texture: SKTexture(imageNamed: "branco"), size: self.size)
        vidro.position = CGPointZero
        //vidro.alpha = 0.8
        
        let color = SceneManager.sharedInstance.faseEscolhida.corNuvemBack
        vidro.colorBlendFactor = 1
        vidro.color = SKColor(red: color[0]/255, green: color[1]/255, blue: color[2]/255, alpha: 0.8)
        
        
        self.setaButton = SKSpriteNode(texture: SKTexture(imageNamed: "seta"), size: CGSizeMake(distanceConstY*3, distanceConstY*3.3))
        setaButton.position = CGPointMake(0,  -distanceConstY * 1.8)
        
//        let moveSeta = SKAction.rotateByAngle(ConvertUtilities.degreesToRadians(-5), duration: 0.2)
//        let moveSetaBack = SKAction.rotateByAngle(ConvertUtilities.degreesToRadians(10), duration: 0.4)
//        let moveSetaDefault = SKAction.rotateByAngle(ConvertUtilities.degreesToRadians(-5), duration: 0.2)
//
//        let spinForever = SKAction.repeatActionForever(SKAction.sequence([moveSeta, moveSetaBack, moveSetaDefault]))
//        seta.runAction(spinForever)
        
        let moveSeta = SKAction.moveByX(0, y: 20, duration: 0.6)
        let moveSetaBack = SKAction.moveByX(0, y: -20, duration: 0.6)
        
        let moveForever = SKAction.repeatActionForever(SKAction.sequence([moveSeta, moveSetaBack]))
        setaButton.runAction(moveForever)

        
        self.hudLayer.removeAllChildren()

        self.hudLayer.addChild(vidro)
        
        self.hudLayer.addChild(congrats)
        self.hudLayer.addChild(tries)
        self.hudLayer.addChild(jumps)
        self.hudLayer.addChild(self.setaButton)

        self.hudLayer.position = CGPointZero
        
        self.hudLayer.zPosition = 990
        
        let fadeIn =  SKAction.fadeInWithDuration(NSTimeInterval(1.0))
        let victorySound = SKAction.playSoundFileNamed(Sounds.endsLevel.rawValue, waitForCompletion: false)
        self.hudLayer.runAction(SKAction.sequence([fadeIn, victorySound]))


    }
    
    // MARK: Helper
    
    func isIphone() -> Bool{
        
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            return true
        }
        return false
        
    }
    
    func isLandscape() -> Bool{
        
        
        if(UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight) {
            return true
        }
        return false
        
    }
    
    func changeSliceDistance(){
        if(isIphone()) {
            if(isLandscape()) {
                Constants.maxDistanceSlide = 600.0
            }
        }
        else {
            Constants.maxDistanceSlide = 320.0

        }
    }
    
    // MARK: Collision

    func didBeginContact(contact: SKPhysicsContact) {
        
        //ninja.position.x = 0
        
        
            let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
            println("contatcMAks = \(contactMask)")
            println("quero = \(ColliderType.FallerWall.rawValue | ColliderType.Ninja.rawValue)")
        
        
            switch(contactMask){
                
                case ColliderType.Portal.rawValue | ColliderType.Ninja.rawValue:
                    if(!self.endLevel) {
                        self.endsLevel()
                    }

                
                case ColliderType.Wall.rawValue | ColliderType.Ninja.rawValue:
                    colideComWall(contact)
                
                case ColliderType.Spike.rawValue | ColliderType.Ninja.rawValue:
                    println("colidiu com spike")
                    //self.runAction(SKAction.playSoundFileNamed("ui.wav", waitForCompletion: false))
                    self.runAction(SKAction.playSoundFileNamed("impact.wav", waitForCompletion: false))

                    
                    if(!self.ninja.isDead){
                        
                        self.ninja.isDead = true
                        self.restart()
                        
                    }
                
            case ColliderType.RotateWall.rawValue | ColliderType.Ninja.rawValue:

                    self.ninja.isMoving = false
                    self.ninja.nail_down()
//                    let wallSE = SKAction.playSoundFileNamed("impact2.wav", waitForCompletion: true)
//                    self.runAction(wallSE)
                    
                    self.ninja.IdleAnimation()
                
            case ColliderType.RotateWall.rawValue | ColliderType.Ninja.rawValue | ColliderType.FallerWall.rawValue:
                
                self.ninja.isMoving = false
                self.ninja.nail_down()
                self.ninja.IdleAnimation()
                
                //self.colideComWall(contact)
                if(contact.bodyA.node?.name == "mWall") {
                    self.ninja.mWall = contact.bodyA!
                }
                else if(contact.bodyB.node?.name == "mWall") {
                    self.ninja.mWall = contact.bodyB!
                }

                if(self.ninja.mWall.node?.userData?.objectForKey("jaColidiu") as! Bool == false) {
                    let duration = self.ninja.mWall.node?.userData?.objectForKey("duration") as! Int
                    self.shakeAndFall(self.ninja.mWall.node!, duration: CGFloat(duration))
                    let wallSE = SKAction.playSoundFileNamed("wall.wav", waitForCompletion: true)
                    self.runAction(wallSE)
                }


            case ColliderType.FallerWall.rawValue | ColliderType.Ninja.rawValue:
                self.ninja.isMoving = false
                self.ninja.nail_down()
                self.ninja.IdleAnimation()

                if(contact.bodyA.node?.name == "mWall") {
                    self.ninja.mWall = contact.bodyA!
                }
                else if(contact.bodyB.node?.name == "mWall") {
                    self.ninja.mWall = contact.bodyB!
                }

                
                if(self.ninja.mWall.node?.userData?.objectForKey("jaColidiu") as! Bool == false) {
                

                    
                    let duration = self.ninja.mWall.node?.userData?.objectForKey("duration") as! Int
                    
                    self.ninja.mWall.node!.userData?.setObject(true, forKey: "jaColidiu")

                    
                    self.shakeAndFall(self.ninja.mWall.node!, duration: CGFloat(duration))
                    let wallSE = SKAction.playSoundFileNamed("wall.wav", waitForCompletion: true)
                    self.runAction(wallSE)
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

        if(!self.didShowTutorial && SceneManager.sharedInstance.faseEscolhida.levelNumber == 1) {
            self.didShowTutorial = true
            self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: true))
            self.hideTutorial()
        }
        else {
        
        
            for touch: AnyObject in touches{
                
                let location = touch.locationInNode(self)
                let node = self.nodeAtPoint(location)
                
                println("comecou toque")
                
                if(endLevel) {
                    if(self.setaButton.containsPoint(location)){

                        self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: true))
                        SceneManager.sharedInstance.endLevel = true
                        SceneManager.sharedInstance.gameViewCtrl.backToMenu()
                        
                    }
                }
                
                else {

                    if(self.pauseButton.containsPoint(location)){
                        println("pausou")
                        
                        self.runAction(SKAction.playSoundFileNamed(Sounds.back.rawValue, waitForCompletion: true))
                        SceneManager.sharedInstance.gameViewCtrl.backToMenu()

                        //var vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as ViewController
                        
                    }
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
                    
                    else {
                        if(self.gameStarted && !self.ninja.isDead && !self.ninja.isMoving){
                            println("comecou toque4")
                            
                            self.initialTapPosition = location
                            self.isDraging = true
                        }
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
            
            if(distance > Constants.maxDistanceSlide){
                
                distance = Constants.maxDistanceSlide
            }
            else{
                if(distance == 0){
                    
                    distance = 1
                }
            }
            
            
            self.ninja.stretch(scale: abs(distance) * 0.16 / Constants.maxDistanceSlide, time: 0)
            
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
                
                var mWallTemp : SKPhysicsBody!
                if(self.ninja.mWall != nil) {
                    mWallTemp = self.ninja.mWall
                }
                else {
                    mWallTemp = self.mWallTempo2
                }
                
                self.ninjaPosTemp = CGPointMake(self.ninja.mWall.node!.position.x + self.ninja.position.x, mWallTemp.node!.position.y + self.ninja.position.y)
                self.mWallTempo = mWallTemp
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
            
            self.jumps = self.jumps + 1
            
            println("speedY1: \(speedY), speedY2: \(speed.1)")
            println("speedX1: \(speedX), speedX2: \(speed.0)")


            
            
            self.score += 1
            
        }
    }
    
    
    

}
