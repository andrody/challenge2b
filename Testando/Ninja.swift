//
//  Ninja.swift
//  Testando
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 27/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import UIKit
import SpriteKit


class Ninja: SKNode {
    
    var body: SKSpriteNode
    var mask : SKSpriteNode
    var back_eyes : SKSpriteNode
    var eyes : SKSpriteNode
    var spinning: SKSpriteNode
    
    
    
    let dScale = CGFloat(0.1)
    
    var currentPosition = CGPointZero
    var antPosition = CGPointZero
    
    var isJumping = false
    var isMoving =  false
    var isDead =  false
    var movimentDirctionX: Int8 = 0
    var movimentDirectionY: Int8 = 0
    
    
    
    init(atPosition: CGPoint, body : String, mask : String, back_eyes : String, eyes : String, spinning : String = "spinning") {
        
        self.body = SKSpriteNode(texture: SKTexture(imageNamed: body))
        self.mask = SKSpriteNode(texture: SKTexture(imageNamed: mask))
        self.back_eyes = SKSpriteNode(texture: SKTexture(imageNamed: back_eyes))
        self.eyes = SKSpriteNode(texture: SKTexture(imageNamed: eyes))
        self.spinning = SKSpriteNode(texture: SKTexture(imageNamed: spinning))
        
        super.init()
        
        self.position = atPosition
        self.body.anchorPoint = CGPointMake(0.5, 0.0)
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
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.body.size.width * 0.45, self.body.size.height * 0.45))
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
        
        self.addChild(self.body)
        self.addChild(self.mask)
        self.addChild(self.back_eyes)
        self.addChild(self.eyes)
        self.addChild(self.spinning)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func nail_right(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        self.body.texture = SKTexture(imageNamed: "nail_right")
    }
    
    func nail_left(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        self.body.texture = SKTexture(imageNamed: "nail_left")
    }
    
    func nail_down(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        self.body.texture = SKTexture(imageNamed: "nail_down")
    }
    
    
    
    
    
    
    func moveChar(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        spin()
        
        self.physicsBody?.applyImpulse(CGVectorMake(amountToMoveX , amountToMoveY))
    }
    
    func spin() {
        
        self.spinning.removeAllActions()
        
        stretchXRepeat(self, scale: 0.12, defaultScale: dScale, time: 0.1)
        
        self.body.hidden = true
        self.mask.hidden = true
        self.back_eyes.hidden = true
        self.eyes.hidden = true
        self.spinning.hidden = false
        
        let spinAction = SKAction.rotateByAngle(degreesToRadians(-360), duration: 0.2)
        let spinForever = SKAction.repeatActionForever(spinAction)
        
        self.spinning.runAction(spinForever)
        
    }
    
    func IdleAnimation(speed : CGFloat = 0.5){
        
        animationAngleDefault()
        
        self.body.removeAllActions()
        
        stretchYRepeat(self, scale: dScale + 0.01, defaultScale: dScale, time : speed)
        stretchXRepeat(self.body, scale: 0.9, defaultScale: 1.0, time : speed)
    }
    
    
    func stretch(scale : CGFloat = 1.0, time : CGFloat = 0.1) {
        
        animationAngleDefault()
        
        let stretchCharY = SKAction.scaleYTo(dScale - scale, duration: NSTimeInterval(time))
        let stretchCharX = SKAction.scaleXTo(dScale + scale, duration: NSTimeInterval(time))
        
        self.runAction(stretchCharX)
        self.runAction(stretchCharY)
        
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
        
        
        self.removeAllActions()
        
    }
    
    func lookTo(node : SKNode, angle : CGFloat = 45, time : CGFloat = 0.1) {
        let raio = self.eyes.size.width/2/8
        let y = sin(degreesToRadians(angle)) * raio
        let x = cos(degreesToRadians(angle)) * raio - 700.0 * dScale
        
        let moveEyes = SKAction.moveTo( CGPointMake(x, y), duration: NSTimeInterval(time) )
        
        node.runAction(moveEyes)
    }
    
    func movePoring(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        println("\(self.physicsBody?.mass)")
        
        self.physicsBody?.applyImpulse(CGVectorMake(amountToMoveX * 100 , amountToMoveY * 100))
        self.isMoving = true
    }
    
    func degreesToRadians(degrees : CGFloat) -> CGFloat {
        return CGFloat(degrees * CGFloat(M_PI) / 180)
    }
    
    func radiansToDegree(radian : CGFloat) -> CGFloat {
        return CGFloat(radian / CGFloat(M_PI) * 180)
    }
    
}
