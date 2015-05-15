//
//  SceneManager.swift
//  Ninja Goo
//
//  Created by Andrew on 5/14/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import Foundation

private let _SceneManagerSharedInstance = SceneManager()

class SceneManager {
    static let sharedInstance = SceneManager()
    
    var fases = [Scenario]()
    var faseEscolhida : Scenario!
    
    init(){
        loadFases()
    }
    
    
    func loadFases() {
    
        var faseOne = Scenario(nome: "minifase1",
            corMontanha: [25,33,65],
            corMontanhaClara: [43, 57, 109],
            corNuvemBack: [25,117,166],
            corNuvemMeio: [43,147,202],
            corNuvemFront: [70,161,209],
            corPlataforma: [16,31,39],
            corFundo: [49,67,131])
        
        var faseTwo = Scenario(nome: "minifase2",
            corMontanha: [25,33,65],
            corMontanhaClara: [43, 57, 109],
            corNuvemBack: [25,117,166],
            corNuvemMeio: [43,147,202],
            corNuvemFront: [70,161,209],
            corPlataforma: [16,31,39],
            corFundo: [49,67,131])
        
        var faseThree = Scenario(nome: "minifase6",
            corMontanha: [25,33,65],
            corMontanhaClara: [43, 57, 109],
            corNuvemBack: [25,117,166],
            corNuvemMeio: [43,147,202],
            corNuvemFront: [70,161,209],
            corPlataforma: [16,31,39],
            corFundo: [49,67,131])
        
        fases.append(faseOne)
        fases.append(faseTwo)
        fases.append(faseThree)

    
    }
    
}