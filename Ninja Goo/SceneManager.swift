//
//  SceneManager.swift
//  Ninja Goo
//
//  Created by Andrew on 5/14/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import AVFoundation
import StoreKit

enum Sounds: String {
    
    //Music
    case menuMusic = "main-theme"
    
    
    //Sound Effects
    case click = "click1"
    case back = "menu_down.wav"
    case jump = "character_jump1.wav"
    case land = "character_land.wav"
    case spike = "impact2.wav"
    case fall = "impact.wav"
    case moveableWall = "shaking.wav"
    case endsLevel = "victory.wav"
    case portal = "teleport.wav"
    case tutorialAppears = "text_appear.wav"
    case tutorialLeave = "miss_text.wav"
    case buyLevelUnlock = "unlock"
    case passesLevelUnlock = "lockpick_success"

}

enum Keys: String {
    
    case levelOne = "keylevelone"
    case levelTwo = "keyleveltwo"
    case levelThree = "keylevelthree"
    case levelFour = "keylevelfour"
    case levelFive = "keylevelfive"
    case levelSix = "keylevelsix"
    
}


private let _SceneManagerSharedInstance = SceneManager()

class SceneManager : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let sharedInstance = SceneManager()
    var audioPlayer = AVAudioPlayer()
    var scene : W1_Level_1!
    var gameViewCtrl : GameViewController!
    var gameCenter : GameCenter!
    var clickAudio : AVAudioPlayer!
    var backGroundMusic : AVAudioPlayer!
    var endLevel : Bool = false

    

    var soundMuted : Bool {
        get {
            var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("soundMuted") as? Bool
            if returnValue == nil //Check for first run of app
            {
                returnValue = false //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save("soundMuted", value: newValue)
        }
    }
    
    var shouldShowAd : Bool {
        get {
            var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("shouldShowAd") as? Bool
            if returnValue == nil //Check for first run of app
            {
                returnValue = true //Default value
            }
            return returnValue!
        }
        set (newValue) {
            SceneManager.sharedInstance.save("shouldShowAd", value: newValue)
        }
    }



    var keyId : String = "levelkeyunlock"

    var fases = [Scenario]()
    var faseEscolhida : Scenario!
    
    override init(){
        super.init()
        loadFases()
        gameCenter = GameCenter()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)

    }
    
    
    func loadFases() {
    
        let faseOne = Scenario(nome: "minifase1",
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
            backgroundBackName : "montanha_branco",
            rank: Ranks.levelone,
            backgroundMusicName: "music1",
            key: Keys.levelOne,
            backGroundVolume: 0.2
        )
                
        let faseTwo = Scenario(nome: "minifase2",
            levelNumber: 2,
            corMontanha: [116,108,10],
            corMontanhaClara: [136, 141, 25],
            corNuvemBack: [59,139,14],
            corNuvemMeio: [74,162,24],
            corNuvemFront: [82,174,31],
            corPlataforma: [16,31,39],
            corFundo: [169,194,50],
            corWallEspecial: [0,116,111],
            backgroundFrontName: "arvore_branco",
            backgroundBackName : "arvore_b_branco",
            rank: Ranks.leveltwo,
            backgroundMusicName: "Winding-Down - fas2",
            key: Keys.levelTwo,
            backGroundVolume: 0.4

        )
        
        
        
        let faseThree = Scenario(nome: "minifase3",
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
            backgroundBackName : "trapezio_B_branco",
            rank: Ranks.levelthree,
            backgroundMusicName: "Exotic-Island - fase 3",
            key : Keys.levelThree,
            backGroundVolume: 0.4


        )
        
        let faseFour = Scenario(nome: "minifase4",
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
            backgroundBackName : "morro_B_branco",
            rank: Ranks.levelfour,
            backgroundMusicName: "music4",
            key: Keys.levelFour,
            backGroundVolume: 0.4


        )
        
        let faseFive = Scenario(nome: "minifase5",
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
            backgroundBackName : "montanha_neve_branco",
            rank: Ranks.levelfive,
            backgroundMusicName: "Misty-Forest - fase5",
            key : Keys.levelFive,
            backGroundVolume: 0.4


        )
        
        let faseSix = Scenario(nome: "minifase6",
            levelNumber: 6,
            corMontanha: [69,94,101],
            corMontanhaClara: [83, 106, 112],
            corNuvemBack: [192,232,234],
            corNuvemMeio: [233,247,248],
            corNuvemFront: [255,255,255],
            corPlataforma: [16,31,39],
            corFundo: [88,113,117],
            corWallEspecial: [237,199,54],
            backgroundFrontName: "trapezio_branco",
            backgroundBackName : "trapezio_B_branco",
            rank: Ranks.levelsix,
            backgroundMusicName: "Insane-Gameplay- fase6",
            key : Keys.levelSix,
            backGroundVolume: 0.6


        )
        
        fases.append(faseOne)
        fases.append(faseTwo)
        fases.append(faseThree)
        fases.append(faseFour)
        fases.append(faseFive)
        fases.append(faseSix)

        
        loadAudio()
    }
    
    func playClickSound(name : String = "click"){
        
        if name == "click" {
            self.clickAudio.play()
        }
        else {
            // Load
            let soundURL = NSBundle.mainBundle().URLForResource(name, withExtension: "wav")
            
            var error:NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: soundURL!)
            } catch var error1 as NSError {
                error = error1
//                audioPlayer = nil
            }
            audioPlayer.play()
        }
    }
    
    func loadAudio(){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch _ {
        }
        
        // Load
        let soundURL = NSBundle.mainBundle().URLForResource(Sounds.click.rawValue, withExtension: "wav")
        // Load Music
        let mainThemeUrl = NSBundle.mainBundle().URLForResource("main-theme", withExtension: "wav")
        
        do {
            // Removed deprecated use of AVAudioSessionDelegate protocol
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        var error:NSError?
        do {
            self.clickAudio = try AVAudioPlayer(contentsOfURL: soundURL!)
        } catch let error1 as NSError {
            error = error1
            self.clickAudio = nil
        }
        
        do {
            self.backGroundMusic = try AVAudioPlayer(contentsOfURL: mainThemeUrl!)
        } catch let error1 as NSError {
            error = error1
            self.backGroundMusic = nil
        }
        self.backGroundMusic.volume = 0.3
        self.backGroundMusic.numberOfLoops = -1

    }
    
    func loadAudio(name : String) -> AVAudioPlayer {
        
        let music = NSBundle.mainBundle().URLForResource(name, withExtension: "wav")
        var error:NSError?
        
        let audio: AVAudioPlayer!
        do {
            audio = try AVAudioPlayer(contentsOfURL: music!)
        } catch let error1 as NSError {
            error = error1
            audio = nil
        }
        
        audio.volume = 0.2

//        if(self.faseEscolhida.levelNumber == 6) {
//            audio.volume = 0.4
//        }
//        
//        if(self.faseEscolhida.levelNumber == 2) {
//            audio.volume = 0.03
//        }

        audio.numberOfLoops = -1
        return audio   
        
    }
    
    func playCaf(name : String){
        
        // Load
        let soundURL = NSBundle.mainBundle().URLForResource(name, withExtension: "caf")
     
        
        var error:NSError?
        let jump: AVAudioPlayer!
        do {
            jump = try AVAudioPlayer(contentsOfURL: soundURL!)
        } catch let error1 as NSError {
            error = error1
            jump = nil
        }
        
        jump.play()
    }

    
    func playMusic(music : AVAudioPlayer) {
        
        if(!SceneManager.sharedInstance.soundMuted) {
        
            music.play()
        }
        else {
            music.stop()
        }
    }
    
    
    
    func save(key : String, value : AnyObject?) {
        
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func load(key : String) -> AnyObject? {
        
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    func unlockNextLevel() {
        var flag = false
        playClickSound("unlock")

        
        for fase in fases {
            if(flag) {
                print("desbloqueaVEL fase \(fase.nome)")

                fase.unlockable = true
                flag = false
                break
            }

            if fase.unlockable && fase.locked {
                print("desbloqueado fase \(fase.nome)")
                fase.locked = false
                fase.unlockable = false
                flag = true
            }
        }
        
    }
    
    func getKeyUnlockable() -> String {
        for level in self.fases {
            if level.unlockable {
                self.keyId = level.key.rawValue
                return self.keyId
            }
        }
        return ""
    }
    
    func buyKey(){
        print("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: getKeyUnlockable());
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fething Products");
        }else{
            print("can't make purchases");
        }
    }
    
    func buyRemoveAds(){
        print("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: "removeadd");
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fething Products");
        }else{
            print("can't make purchases");
        }
    }
    
    
    // Helper Methods
    
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    
    
    // Delegate Methods for IAP
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("got the request from Apple")
        let count : Int = response.products.count
        if (count>0) {
            var validProducts = response.products
            let validProduct: SKProduct = response.products[0] 
            if (validProduct.productIdentifier == self.keyId) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(validProduct);
            } else {
                if validProduct.productIdentifier == "removeadd" {
                    buyProduct(validProduct);

                }
                else {
                    print(validProduct.productIdentifier)
                }
            }
        } else {
            print("nothing")
        }
    }
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("La vaina fallo");
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased, .Restored:
                    print("Product Purchased or restored");
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("removeVidro", object: nil)
                    
                    if trans.payment.productIdentifier == "removeadd" {
                        shouldShowAd = false
                        NSNotificationCenter.defaultCenter().postNotificationName("removeadd", object: nil)
                    }
                    
                    else {
                        SceneManager.sharedInstance.unlockNextLevel()
                        NSNotificationCenter.defaultCenter().postNotificationName("unlockedLevel", object: nil)
                    }
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)

                    break;
                case .Failed:
                    NSNotificationCenter.defaultCenter().postNotificationName("removeVidro", object: nil)
                    print("Purchased Failed");
                    NSNotificationCenter.defaultCenter().postNotificationName("hideLoad", object: nil)

                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                default:
                    break;
                }

            }
        }
        
    }

    
    
    
}