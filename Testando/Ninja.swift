//
//  Ninja.swift
//  Testando
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 27/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import UIKit
import SpriteKit

enum Nail: Int {
    case Down, Left, Right
}


class Ninja: SKNode {
    
    var container :SKSpriteNode
    var body: SKSpriteNode
    var mask : SKSpriteNode
    var back_eyes : SKSpriteNode
    var eyes : SKSpriteNode
    var spinning: SKSpriteNode
    
    var body_text: SKTexture
    var body_left_text: SKTexture
    var body_right_text: SKTexture
    var mask_red: SKTexture
    var mask_blue: SKTexture


    
    
    let dScale = CGFloat(0.1)
    
    var currentPosition = CGPointZero
    var antPosition = CGPointZero
    
    var isJumping = false
    var nail = Nail.Down
    var isMoving =  false
    var isDead =  false
    var movimentDirctionX: Int8 = 0
    var movimentDirectionY: Int8 = 0
    
    
    
    init(atPosition: CGPoint, body : String, mask : String, back_eyes : String, eyes : String, spinning : String = "spinning") {
        
        self.container = SKSpriteNode()
        self.body = SKSpriteNode(texture: SKTexture(imageNamed: body))
        self.mask = SKSpriteNode(texture: SKTexture(imageNamed: mask))
        self.back_eyes = SKSpriteNode(texture: SKTexture(imageNamed: back_eyes))
        self.eyes = SKSpriteNode(texture: SKTexture(imageNamed: eyes))
        self.spinning = SKSpriteNode(texture: SKTexture(imageNamed: spinning))
        
        self.body_text = self.body.texture!
        self.mask_red = self.mask.texture!
        self.mask_blue = SKTexture(imageNamed: "mask_blue")

        self.body_left_text = SKTexture(imageNamed: "nail_left")
        self.body_right_text = SKTexture(imageNamed: "nail_right")

        
        super.init()
        
        getRandomMask()
        
        self.position = atPosition
        self.body.anchorPoint = CGPointMake(0.5, 0.0)
        //self.physicsBody = CGPointMake(0.5, 0.0)
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
        
        //Phy
        let colisyonCategories = CollisionCategory()
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.body.size.width * 0.35, self.body.size.height * 0.35))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 1.0
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.angularDamping = 1.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.categoryBitMask = colisyonCategories.batimanCategoryBitMask
        self.physicsBody?.contactTestBitMask = colisyonCategories.platformCategoryBitMask | colisyonCategories.spikeCategoryBitMask
        self.physicsBody?.collisionBitMask = colisyonCategories.platformCategoryBitMask | colisyonCategories.spikeCategoryBitMask
        
        self.setScale(dScale)
        
        self.container.addChild(self.body)
        self.container.addChild(self.mask)
        self.container.addChild(self.back_eyes)
        self.container.addChild(self.eyes)
        self.container.addChild(self.spinning)
        self.addChild(self.container)
        
        
        
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
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func nail_right(){
        
        self.body.texture = self.body_right_text
        self.nail = Nail.Right
        //self.container.anchorPoint = CGPointMake(1.0, 0.5)
        //self.body.anchorPoint = CGPointMake(1.0, 0.5)
        //self.body.position = CGPointMake(self.body.size.width/2, 0)


    }
    
    func nail_left(){
        
        self.body.texture = self.body_left_text
        self.nail = Nail.Left
        //self.container.anchorPoint = CGPointMake(0.0, 0.5)
        //self.body.anchorPoint = CGPointMake(0.0, 0.5)



    }
    
    func nail_down(){
        
        self.body.texture = self.body_text
        self.nail = Nail.Down
        //self.container.anchorPoint = CGPointMake(.0, 0.0)
        //self.body.anchorPoint = CGPointMake(0.5, 0.0)

    }
    
    
    
    
    
    
    func moveChar(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        spin()
        
        self.physicsBody?.applyImpulse(CGVectorMake(amountToMoveX , amountToMoveY))
        let testesound = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: true)
        
        self.runAction(testesound)
    }
    
    func spin() {
        

        self.spinning.removeAllActions()
        
        //stretchXRepeat(self.container, scale: 1.12, defaultScale: 1.0, time: 0.1)
        
        self.IdleAnimation(speed: 0.1)
        
        self.body.hidden = true
        self.mask.hidden = true
        self.back_eyes.hidden = true
        self.eyes.hidden = true
        self.spinning.hidden = false
        
        let spinAction = SKAction.rotateByAngle(degreesToRadians(-360), duration: 0.2)
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
        
        if(self.nail != Nail.Down) {
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
        //node.removeAllActions()
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
        let y = sin(degreesToRadians(angle)) * raio
        let x = cos(degreesToRadians(angle)) * raio - 700.0 * dScale
        
        let moveEyes = SKAction.moveTo( CGPointMake(x, y), duration: NSTimeInterval(time) )
        
        node.runAction(moveEyes)
    }
    
    
    func degreesToRadians(degrees : CGFloat) -> CGFloat {
        return CGFloat(degrees * CGFloat(M_PI) / 180)
    }
    
    func radiansToDegree(radian : CGFloat) -> CGFloat {
        return CGFloat(radian / CGFloat(M_PI) * 180)
    }
    
}
