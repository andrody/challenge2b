//
//  RandomGenerator.swift
//  Challenge2
//
//  Created by Andrew on 3/18/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import Foundation
import SpriteKit

let MAX_BLOCKS_WALL :UInt32 = 10
let MIN_BLOCKS_DIS : CGFloat = CGFloat(3) * CGFloat(233) * CGFloat(0.3)



struct Wall {
    var height: Int = 0
    var direction: Int = 0
    var distance: CGFloat = 0
    var safe_areas: [(Int, Int)]
}

class RandomGenerator {
    
    class func genRandomWalls() -> [Wall] {
        
        let height = Int(arc4random_uniform(MAX_BLOCKS_WALL))
        let direction = Int(arc4random_uniform(2))
        let distance = CGFloat(arc4random_uniform(MAX_BLOCKS_WALL/2)) * CGFloat(233.0) * CGFloat(0.3) + MIN_BLOCKS_DIS
        let safe_areas = [
            (  Int(arc4random_uniform(height + 1)), Int(arc4random_uniform(3))  )
        ]
        
        let w = Wall(height: height, direction: direction, distance: distance, safe_areas: safe_areas)
        
        return [w]
    }
    
    class func getWalls(quantity : UInt32 = 10) -> Array<Wall> {
        
        var walls = Array<Wall>()
        
        for q in 1...quantity {
            
            for w in  genRandomWalls() {
                
                walls.append(w)
                
            }
            
        }
        
        return walls
        
        
    }
    
    
}
