//
//  SceneManager.swift
//  Ninja Goo
//
//  Created by Andrew on 5/14/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import AVFoundation


private let _SceneManagerSharedInstance = SceneManager()

class SceneManager {
    static let sharedInstance = SceneManager()
    var audioPlayer = AVAudioPlayer()
    var scene : W1_Level_1!
    var gameViewCtrl : GameViewController!

    
    var fases = [Scenario]()
    var faseEscolhida : Scenario!
    
    init(){
        loadFases()
    }
    
    
    func loadFases() {
    
        var faseOne = Scenario(nome: "minifase1",
            levelNumber: 1,
            corMontanha: [25,47,65],
            corMontanhaClara: [43, 80, 109],
            corNuvemBack: [25,165,166],
            corNuvemMeio: [41,191,192],
            corNuvemFront: [70,209,208],
            corPlataforma: [16,31,39],
            corFundo: [49,95,130],
            corWallEspecial: [43,147,202],
            backgroundFrontName: "montanha_branco",
            backgroundBackName : "montanha_branco"
        )
                
        var faseTwo = Scenario(nome: "minifase2",
            levelNumber: 2,
            corMontanha: [0,160,3],
            corMontanhaClara: [119, 215, 0],
            corNuvemBack: [0,90,86],
            corNuvemMeio: [0,116,111],
            corNuvemFront: [0,157,150],
            corPlataforma: [16,31,39],
            corFundo: [191,231,231],
            corWallEspecial: [0,116,111],
            backgroundFrontName: "arvore_branco",
            backgroundBackName : "arvore_b_branco")
        
        
        
        var faseThree = Scenario(nome: "minifase3",
            levelNumber: 3,
            corMontanha: [178,0,103],
            corMontanhaClara: [214, 119, 174],
            corNuvemBack: [64,0,80],
            corNuvemMeio: [98,0,123],
            corNuvemFront: [124,0,155],
            corPlataforma: [16,31,39],
            corFundo: [227,201,234],
            corWallEspecial: [98,0,123],
            backgroundFrontName: "trapezio_branco",
            backgroundBackName : "trapezio_B_branco"
        )
        
        var faseFour = Scenario(nome: "minifase4",
            levelNumber: 4,
            corMontanha: [220,159,0],
            corMontanhaClara: [255, 185, 0],
            corNuvemBack: [164,82,0],
            corNuvemMeio: [222,111,0],
            corNuvemFront: [255,128,0],
            corPlataforma: [16,31,39],
            corFundo: [255,232,168],
            corWallEspecial: [222,111,0],
            backgroundFrontName: "morro_branco",
            backgroundBackName : "morro_B_branco"
        )
        
        var faseFive = Scenario(nome: "minifase5",
            levelNumber: 5,
            corMontanha: [0,139,134],
            corMontanhaClara: [144, 199, 196],
            corNuvemBack: [119,0,9],
            corNuvemMeio: [148,1,11],
            corNuvemFront: [242,1,18],
            corPlataforma: [16,31,39],
            corFundo: [228,233,130],
            corWallEspecial: [148,1,11],
            backgroundFrontName: "montanha_neve_branco",
            backgroundBackName : "montanha_neve_branco"
        )
        
        var faseSix = Scenario(nome: "minifase6",
            levelNumber: 6,
            corMontanha: [0,64,99],
            corMontanhaClara: [0, 66, 102],
            corNuvemBack: [0,33,64],
            corNuvemMeio: [0,49,96],
            corNuvemFront: [0,86,167],
            corPlataforma: [16,31,39],
            corFundo: [0,120,185],
            corWallEspecial: [0,49,96],
            backgroundFrontName: "montanha_branco",
            backgroundBackName : "montanha_branco"
        )
        
        fases.append(faseOne)
        fases.append(faseTwo)
        fases.append(faseThree)
        fases.append(faseFour)
        fases.append(faseFive)
        fases.append(faseSix)

    
    }
    
    func playClickSound(){
        // Load
        let soundURL = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: soundURL, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func save(key : String, value : AnyObject?) {
        
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func load(key : String) -> AnyObject? {
        
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    
    
}