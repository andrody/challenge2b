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
        
        var faseThree = Scenario(nome: "minifase3",
            corMontanha: [25,33,65],
            corMontanhaClara: [43, 57, 109],
            corNuvemBack: [25,117,166],
            corNuvemMeio: [43,147,202],
            corNuvemFront: [70,161,209],
            corPlataforma: [16,31,39],
            corFundo: [49,67,131])
        
        var faseFour = Scenario(nome: "minifase4",
            corMontanha: [25,33,65],
            corMontanhaClara: [43, 57, 109],
            corNuvemBack: [25,117,166],
            corNuvemMeio: [43,147,202],
            corNuvemFront: [70,161,209],
            corPlataforma: [16,31,39],
            corFundo: [49,67,131])
        
        var faseFive = Scenario(nome: "minifase5",
            corMontanha: [25,33,65],
            corMontanhaClara: [43, 57, 109],
            corNuvemBack: [25,117,166],
            corNuvemMeio: [43,147,202],
            corNuvemFront: [70,161,209],
            corPlataforma: [16,31,39],
            corFundo: [49,67,131])
        
        var faseSix = Scenario(nome: "minifase6",
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
    
}