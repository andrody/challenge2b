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
    
    override func didMoveToView(view: SKView) {

         self.world = WorldLayer(sceneSize: self.size)
        world!.startNewWorld(stageName: "stageOne")
        //self.world!.setScale(0.3)

        self.addChild(world!)
    
        
        
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
                speedY = 300
            }
            
            if(speedY > 150){
                speedY = 150
            }
            
            
            self.world!.poring.movePoring(amountToMoveX: speedX * 2, amountToMoveY: speedY * 2)
        }
    }
    

    
    override func update(currentTime: CFTimeInterval) {
        

        self.world!.poring.antPosition = self.world!.poring.currentPosition
        self.world!.poring.currentPosition = self.world!.poring.position
        
        if(self.world!.poring.position.x >= self.size.width / 2){
            
            let a = self.world!.poring.currentPosition.x - self.world!.poring.antPosition.x
            
            self.world!.moveWorld(amountTomove: -a, withPoring: true)
            
            
        }
        


    }
    

    
    
}

