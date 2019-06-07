//
//  DustScene.swift
//  ARDust
//
//  Created by youngjun goo on 07/06/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import SpriteKit

class DustScene: SKScene {
    let gem = SKSpriteNode(imageNamed: "spark")
    
    override func didMove(to view: SKView) {
        addBackground()
        addGem()
        addEmitter(pollutionState: "default")
    }
    
    func addBackground() {
        let backDrop = SKSpriteNode(imageNamed: "state1")
        addChild(backDrop)
        backDrop.size.width = size.width
        backDrop.size.height = size.height
        backDrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backDrop.zPosition = Layers.background
    }
    
    func addGem() {
        addChild(gem)
        gem.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        gem.zPosition = Layers.gem
        gem.setScale(2.5)

    }
    
    func setUpEmitterBirthRate(pollutionState: String) -> CGFloat {
        switch pollutionState {
        case "최고","좋음":
            return 0
        case "양호":
            return 100
        case "보통":
            return 200
        case "나쁨":
            return 400
        case "상당히 나쁨":
            return 600
        case "매우 나쁨":
            return 750
        case "최악":
            return 900
        default:
            return 0
        }
    }
    
    func addEmitter(pollutionState: String) {
        let birthRate = setUpEmitterBirthRate(pollutionState: pollutionState)
        let emitter = SKEmitterNode(fileNamed: Emitter.dust)!
        emitter.particleBirthRate = birthRate
        emitter.zPosition = Layers.emitter
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(emitter)

    }
}
