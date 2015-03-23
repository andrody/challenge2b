//
//  Poring.swift
//  Testando
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 21/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import UIKit
import SpriteKit

class Poring: SKSpriteNode {
    
    var poringStill: [SKTexture] = []
    var poringJumping: [SKTexture] = []
    
    var currentPosition = CGPointZero
    var antPosition = CGPointZero

    
    
    init(atPosition: CGPoint , texture: SKTexture){
        
        super.init(texture: texture, color: UIColor.redColor(), size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = atPosition
        self.zPosition = 10
        self.setScale(0.07)
        
        let colisyonCategories = CollisionCategory()
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 1.0
        //self.physicsBody?.angularDamping = 1.0
        //self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.categoryBitMask = colisyonCategories.poringCategoryBitMask
        self.physicsBody?.contactTestBitMask = colisyonCategories.platformBlckCategoryBitMask
        self.physicsBody?.collisionBitMask = colisyonCategories.platformBlckCategoryBitMask
        
        //Init texture animations
            //Poring Still
        self.poringStill.append(texture)
            //Poring junping
        self.poringJumping.append(texture)

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movePoring(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){

 
        self.physicsBody?.applyImpulse(CGVectorMake(amountToMoveX , amountToMoveY))
    }
    
    func update(currentTime: CFTimeInterval) {
        
        
        
        
        
    }
  
    
    
}
