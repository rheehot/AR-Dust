//
//  WeatherRealTimeData.swift
//  ARDust
//
//  Created by youngjun goo on 08/06/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

struct WeatherRealtimeData: Codable {
    var t1h: String?     // 현재온도
    var sky: String?     // 하늘상태 맑음(1), 구름많음(3), 흐림(4)
    var pty: String?     // 강수형태 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4) ps) 비/눈 - > 진눈개비
    var rn1: String?     // 강수량
    var reh: String?     // 습도
    
    // 요청한 날씨데이터를 String 형으로 formatting 해주는 함수
    mutating func convertToRealtimeString(_ type: WeatherRealtimeCategoryType, value: Double) {
        
        switch type {
        case .t1h:  // 현재온도
            self.t1h = "\(Int(round(value)))°"
        case .sky:  // 하늘상태
            if value == 1 {
                self.sky = "맑음"
            } else if value == 2 {
                self.sky = "구름조금"
            } else if value == 3 {
                self.sky = "구름많음"
            } else if value == 4 {
                self.sky = "흐림"
            }
        case .pty:  // 강수형태
            if value == 0 {
                self.pty = "없음"
            } else if value == 1 {
                self.pty = "비"
            } else if value == 2 {
                self.pty = "비/눈"
            } else if value == 3 {
                self.pty = "눈"
            }
        case .rn1:  // 강수량
            self.rn1 = "\(value)mm"
        case .reh:  // 습도
            self.reh = "\(Int(value))%"
        }
    }
}
