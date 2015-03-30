//
//  GameScene.swift
//  Testando
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 20/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import SpriteKit



class GameScene: SKScene, SKPhysicsContactDelegate , UIGestureRecognizerDelegate {
    
    var world: WorldLayer?

    var initialTapPosition = CGPoint()
    var finalTapPosition = CGPoint()
    
    var isDraging = false
    
    //
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {

         //self.world = WorldLayer(sceneSize: self.size)
        //world!.startNewWorld(stageName: "stageOne")
       // self.world!.setScale(0.05)

        //self.addChild(world!)
    
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */

        
        for touch: AnyObject in touches{
            
            if(self.isDraging == false){
                
                let location = touch.locationInNode(self)
                
                self.initialTapPosition = location
                
                self.isDraging = true
                
            }
            
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if(self.isDraging == true){
            
            self.isDraging = false
            
            let touch: AnyObject = touches.anyObject()!
            
            self.finalTapPosition = touch.locationInNode(self)
            
            var speedX = self.initialTapPosition.x - self.finalTapPosition.x
            var speedY = self.initialTapPosition.y - self.finalTapPosition.y
            
            println("\(speedY)")
            
            if(speedX > 300){
                speedY = 100
            }
            
            if(speedY > 400){
                speedY = 300
            }
            
            
           // self..movePoring(amountToMoveX: speedX * 2, amountToMoveY: speedY * 2)
        }
    }
    

    
    override func update(currentTime: CFTimeInterval) {
        
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime


        
        //self.world!.poring.antPosition = self.world!.poring.currentPosition
//        self.world!.poring.currentPosition = self.world!.poring.position
//        
//        if(self.world!.poring.position.x >= self.size.width / 2){
//            
//            let a = self.world!.poring.currentPosition.x - self.world!.poring.antPosition.x
//            
//            
//            let amountToMove = a * CGFloat(dt)
//            println("\(amountToMove)")
//            
//            self.world!.moveWorld(amountTomove: -amountToMove, withPoring: true)
//            
//            
//        }
        


    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
    // 1
    let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
    println("Amount to move: \(amountToMove)")
    // 2
    sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y) }

    
    
}

