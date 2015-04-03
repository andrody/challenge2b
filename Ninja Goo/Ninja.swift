//
//  Ninja.swift
//  Ninja Goo
//
//  Created by Andrew Feitosa on 02/04/15.
//  
//  Define:
//  This class represents de main character of the game

import UIKit
import SpriteKit

enum NailState: Int {
    case Down, Left, Right
}

enum ColliderType: UInt32 {
    case Ninja = 1
    case Platform = 2
    case Spike = 4
}


class Ninja: SKNode {
    
    var container :SKSpriteNode!
    var body: SKSpriteNode!
    var mask : SKSpriteNode!
    var back_eyes : SKSpriteNode!
    var eyes : SKSpriteNode!
    var spinning: SKSpriteNode!
    
    var body_text: SKTexture!
    var body_left_text: SKTexture!
    var body_right_text: SKTexture!
    var mask_red: SKTexture!
    var mask_blue: SKTexture!
    
    let dScale = CGFloat(0.1)
    
    var currentPosition = CGPointZero
    var antPosition = CGPointZero
    
    var isJumping = false
    var nailState = NailState.Down
    var isMoving =  false
    var isDead =  false
    var movimentDirctionX: Int8 = 0
    var movimentDirectionY: Int8 = 0
    
    
    
    init(atPosition: CGPoint) {
        super.init()
        
        loadAsset()
        loadPositions(atPosition)
        loadPhysics()

    }

    
    
    func loadAsset(){
        
        self.container = SKSpriteNode()
        self.body = SKSpriteNode(texture: SKTexture(imageNamed: "body"))
        self.mask = SKSpriteNode(texture: SKTexture(imageNamed: "mask"))
        self.back_eyes = SKSpriteNode(texture: SKTexture(imageNamed: "back_eyes"))
        self.eyes = SKSpriteNode(texture: SKTexture(imageNamed: "eyes"))
        self.spinning = SKSpriteNode(texture: SKTexture(imageNamed: "spinning"))
        
        self.body_text = self.body.texture!
        self.mask_red = self.mask.texture!
        self.mask_blue = SKTexture(imageNamed: "mask_blue")
        
        self.body_left_text = SKTexture(imageNamed: "nail_left")
        self.body_right_text = SKTexture(imageNamed: "nail_right")
        
        self.container.addChild(self.body)
        self.container.addChild(self.mask)
        self.container.addChild(self.back_eyes)
        self.container.addChild(self.eyes)
        self.container.addChild(self.spinning)
        self.addChild(self.container)
        
    }
    
    func loadPositions(atPosition: CGPoint){
        
        getRandomMask()
        
        self.position = atPosition
        self.body.anchorPoint = CGPointMake(0.5, 0.0)
        self.container.anchorPoint = CGPointMake(0.5, 0.0)
        self.container.position = CGPointZero
        
        self.body.position =  CGPointMake(0, -self.body.size.height/2)
        self.mask.position =  CGPointZero
        self.back_eyes.position = CGPointZero
        self.eyes.position = CGPointZero
        self.spinning.position = CGPointZero
        self.spinning.hidden = true
        
        self.body.zPosition = 0
        self.mask.zPosition = 1
        self.back_eyes.zPosition = 2
        self.eyes.zPosition = 3
        self.zPosition = 10
        
        self.setScale(dScale)

    }
    
    func loadPhysics(){
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.body.size.width * dScale * 0.35, self.body.size.height * dScale  * 0.35))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 0.1
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.categoryBitMask = ColliderType.Ninja.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.Platform.rawValue | ColliderType.Spike.rawValue
        self.physicsBody?.collisionBitMask = ColliderType.Platform.rawValue | ColliderType.Spike.rawValue
        self.physicsBody?.mass = 1.0

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRandomMask(){
        
        let diceRoll = Int(arc4random_uniform(2))
        
        if(diceRoll == 0) {
            self.mask.texture = self.mask_blue
        }
        else {
            self.mask.texture = self.mask_red
        }
        
    }
    
    func nail_right(){
        
        self.body.texture = self.body_right_text
        self.nailState = NailState.Right
 
    }
    
    func nail_left(){
        
        self.body.texture = self.body_left_text
        self.nailState = NailState.Left
        
    }
    
    func nail_down(){
        
        self.body.texture = self.body_text
        self.nailState = NailState.Down

    }
    
    
    func jump(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        spin()
        
        self.physicsBody?.applyImpulse(CGVectorMake(amountToMoveX, amountToMoveY))
        
        self.runAction(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: true))
        
    }
    
    func spin() {
        

        self.spinning.removeAllActions()
        
        self.IdleAnimation(speed: 0.1)
        
        self.body.hidden = true
        self.mask.hidden = true
        self.back_eyes.hidden = true
        self.eyes.hidden = true
        self.spinning.hidden = false
        
        let spinAction = SKAction.rotateByAngle(ConvertUtilities.degreesToRadians(-360), duration: 0.2)
        let spinForever = SKAction.repeatActionForever(spinAction)
        
        self.spinning.runAction(spinForever)
        
    }
    
    func IdleAnimation(speed : CGFloat = 0.3){
        
        animationAngleDefault()
        
        stretchYRepeat(self.container, scale: 1.05, defaultScale: 1.0, time : speed)
        stretchXRepeat(self.container, scale: 0.95, defaultScale: 1.0, time : speed*1.6)
    }
    
    
    func stretch(scale : CGFloat = 1.0, time : CGFloat = 0.1) {
        
        animationAngleDefault()
        
        var changer :CGFloat = 1
        
        if(self.nailState != NailState.Down) {
            changer = -1
        }
        
        let stretchCharY = SKAction.scaleYTo(1.0 - scale * changer, duration: NSTimeInterval(time))
        let stretchCharX = SKAction.scaleXTo(1.0 + scale * changer, duration: NSTimeInterval(time))
        
        self.container.runAction(stretchCharX)
        self.container.runAction(stretchCharY)
        
    }
    
    func stretchYRepeat(node : SKNode, scale : CGFloat, defaultScale: CGFloat ,time : CGFloat = 0.1 ){
        
        let stretchGo = SKAction.scaleYTo(scale, duration: NSTimeInterval(time))
        
        let stretchDefault = SKAction.scaleYTo(defaultScale, duration: NSTimeInterval(time))
        
        let stretchAction = SKAction.repeatActionForever(SKAction.sequence([stretchGo, stretchDefault]))
        
        node.runAction(SKAction.sequence([stretchDefault,stretchAction]))
    }
    
    func stretchXRepeat(node : SKNode, scale : CGFloat, defaultScale: CGFloat ,time : CGFloat = 0.1 ){
        
        let stretchGo = SKAction.scaleXTo(scale, duration: NSTimeInterval(time))
        
        let stretchDefault = SKAction.scaleXTo(defaultScale, duration: NSTimeInterval(time))
        
        let stretchAction = SKAction.repeatActionForever(SKAction.sequence([stretchGo, stretchDefault]))
        
        node.runAction(SKAction.sequence([stretchDefault,stretchAction]))
    }
    
    func stretchRepeat(node : SKNode, scale : CGFloat, defaultScale: CGFloat ,time : CGFloat = 0.1 ) {

        let stretchGo = SKAction.scaleTo(scale, duration: NSTimeInterval(time))
        
        let stretchDefault = SKAction.scaleTo(defaultScale, duration: NSTimeInterval(time))
        
        let stretchAction = SKAction.repeatActionForever(SKAction.sequence([stretchGo, stretchDefault]))
        
        node.runAction(SKAction.sequence([stretchDefault,stretchAction]))
    }
    
    func animationAngleDefault () {
        
        self.body.hidden = false
        self.mask.hidden = false
        self.eyes.hidden = false
        self.back_eyes.hidden = false
        self.spinning.hidden = true
        self.spinning.removeAllActions()
        
        self.container.removeAllActions()
        self.removeAllActions()
        
    }
    
    func lookTo(node : SKNode, angle : CGFloat = 45, time : CGFloat = 0.1) {
        
        let raio = self.eyes.size.width/2/8
        let y = sin(ConvertUtilities.degreesToRadians(angle)) * raio
        let x = cos(ConvertUtilities.degreesToRadians(angle)) * raio - 700.0 * dScale
        
        let moveEyes = SKAction.moveTo( CGPointMake(x, y), duration: NSTimeInterval(time) )
        
        node.runAction(moveEyes)
        
    }
    
    
    
    
}
