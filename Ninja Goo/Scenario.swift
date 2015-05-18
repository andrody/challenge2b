//
//  Scenario.swift
//  Ninja Goo
//
//  Created by Andrew on 5/14/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//


import UIKit
import SpriteKit

class Scenario {
    
    var nome : String!
    var corMontanha : [CGFloat]
    var corMontanhaClara : [CGFloat]
    var corNuvemBack : [CGFloat]
    var corNuvemMeio : [CGFloat]
    var corNuvemFront : [CGFloat]
    var corPlataforma : [CGFloat]
    var corFundo : [CGFloat]
    var corWallEspecial : [CGFloat]
    var backgroundFrontName : String!
    var backgroundBackName : String!




    
    init(nome : String, corMontanha : [CGFloat], corMontanhaClara : [CGFloat], corNuvemBack : [CGFloat], corNuvemMeio : [CGFloat], corNuvemFront : [CGFloat], corPlataforma : [CGFloat], corFundo : [CGFloat], corWallEspecial : [CGFloat], backgroundFrontName : String,  backgroundBackName : String) {
        
        self.nome = nome
        self.corMontanha = corMontanha
        self.corMontanhaClara = corMontanhaClara
        self.corNuvemBack = corNuvemBack
        self.corNuvemMeio = corNuvemMeio
        self.corNuvemFront = corNuvemFront
        self.corPlataforma = corPlataforma
        self.corFundo = corFundo
        self.corWallEspecial = corWallEspecial
        self.backgroundBackName = backgroundBackName
        self.backgroundFrontName = backgroundFrontName
        
    }

}