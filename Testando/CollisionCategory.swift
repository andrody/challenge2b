//
//  CollisionCategory.swift
//  MeuJogoTesteUm
//
//  Created by Jose Mauricio Barroso Monteiro Junior on 15/03/15.
//  Copyright (c) 2015 Jose Mauricio Barroso Monteiro Junior. All rights reserved.
//

import UIKit

 class CollisionCategory: NSObject {

    let poringCategoryBitMask = UInt32(1)
    let platformBlckCategoryBitMask = UInt32(2)
    let spikeCategoryBitMask = UInt32(4)
    let backgroundCategoryBitMask = UInt32(8)
    let sharkCategoryBitMask = UInt32(32)
    let worldWallCategoryBitMask = UInt32(64)

}
