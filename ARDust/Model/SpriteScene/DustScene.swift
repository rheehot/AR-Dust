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
        addBackground(pollutionState: "default")
        addGem()
        addEmitter(pollutionState: "default")
    }
    
    func addBackground(pollutionState: String) {
        let backDrop = getBackgroundAsset(pollutionState: pollutionState)
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
    
    func setUpEmitter(pollutionState: String) -> CGFloat {
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
    
    func getCurrentTime() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
    
    // 시간과 미세먼지 농도에 따라 뒤에 그려질 배경설정
    func getBackgroundAsset(pollutionState: String) -> SKSpriteNode {
        let currentTime = Int(getCurrentTime())!
        
        if currentTime < 12 {
            if pollutionState == "좋음" && pollutionState == "양호" && pollutionState == "보통" {
                return SKSpriteNode(imageNamed: "goodMorning")
            } else {
                return SKSpriteNode(imageNamed: "notgoodMorning")
            }
        } else if currentTime < 18 {
            if pollutionState == "좋음" && pollutionState == "양호" && pollutionState == "보통" {
                return SKSpriteNode(imageNamed: "goodAfternoon")
            } else {
                return SKSpriteNode(imageNamed: "notgoodAfternoon")
            }
        } else {
             return SKSpriteNode(imageNamed: "goodNight")
        }
    }
    
    func addEmitter(pollutionState: String) {
        let birthRate = setUpEmitter(pollutionState: pollutionState)
        let speed = setUpEmitter(pollutionState: pollutionState)
        let emitter = SKEmitterNode(fileNamed: Emitter.dust)!
        emitter.particleBirthRate = birthRate
        emitter.speed = speed
        emitter.zPosition = Layers.emitter
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(emitter)

    }
}
