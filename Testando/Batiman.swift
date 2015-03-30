

import UIKit
import SpriteKit

class Batiman: SKSpriteNode {
    
    var currentPosition = CGPointZero
    var antPosition = CGPointZero
    
    var isJumping = false
    var isMoving =  false
    var movimentDirctionX: Int8 = 0
    var movimentDirectionY: Int8 = 0

    
    
    init(atPosition: CGPoint , texture: SKTexture){
        
        super.init(texture: texture, color: UIColor.redColor(), size: texture.size())
        
        self.name = "batiman"
        
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
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.angularDamping = 1.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.categoryBitMask = colisyonCategories.batimanCategoryBitMask
        self.physicsBody?.contactTestBitMask = colisyonCategories.platformCategoryBitMask | colisyonCategories.spikeCategoryBitMask
        self.physicsBody?.collisionBitMask = colisyonCategories.platformCategoryBitMask | colisyonCategories.spikeCategoryBitMask
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movePoring(#amountToMoveX: CGFloat , amountToMoveY: CGFloat){
        
        self.physicsBody?.applyImpulse(CGVectorMake(amountToMoveX , amountToMoveY))
        self.isMoving = true
    }
    
    func update(currentTime: CFTimeInterval) {
        
        
        
        
        
    }
    
    
    
}
