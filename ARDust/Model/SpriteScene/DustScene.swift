//
//  DustScene.swift
//  ARDust
//
//  Created by youngjun goo on 07/06/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import SpriteKit

class DustScene: SKScene {
    var pollutionState: String = "default"
    
    override func didMove(to view: SKView) {
        addBackground()
        //addGem()
        addEmitter()
    }
    
    func addBackground() {
        let backDrop = getBackgroundAsset()
        addChild(backDrop)
        backDrop.size.width = size.width
        backDrop.size.height = size.height
        backDrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backDrop.zPosition = Layers.background
    }
    
    func setUpEmitter() -> CGFloat {
        switch self.pollutionState {
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
    func getBackgroundAsset() -> SKSpriteNode {
        let currentTime = Int(getCurrentTime())!
        
        if  6 < currentTime && currentTime < 12 {
            if pollutionState == "최고" || pollutionState == "양호" || pollutionState == "보통" {
                return SKSpriteNode(imageNamed: "goodMorning")
            } else {
                return SKSpriteNode(imageNamed: "notgoodMorning")
            }
            
        } else if currentTime < 18 {
            if pollutionState == "최고" || pollutionState == "양호" || pollutionState == "보통" {
                return SKSpriteNode(imageNamed: "goodAfternoon")
            } else {
                return SKSpriteNode(imageNamed: "notgoodAfternoon")
            }
        } else {
             return SKSpriteNode(imageNamed: "goodNight")
        }
    }
    
    func addEmitter() {
        let birthRate = setUpEmitter()
        let speed = setUpEmitter()
        let emitter = setEmitterNode()
        emitter.particleBirthRate = birthRate
        emitter.speed = speed
        emitter.zPosition = Layers.emitter
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(emitter)

    }
    
    func setEmitterNode() -> SKEmitterNode {
        if self.pollutionState == "최고" || self.pollutionState == "양호" {
            if let emitter = SKEmitterNode(fileNamed: Emitter.fileFlies) {
                return emitter
            } else {
                return SKEmitterNode(fileNamed: Emitter.dust)!
            }
        } else {
            return SKEmitterNode(fileNamed: Emitter.dust)!
        }
    }
}
