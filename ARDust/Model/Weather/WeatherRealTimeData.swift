//
//  WeatherRealTimeData.swift
//  ARDust
//
//  Created by youngjun goo on 08/06/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

struct WeatherRealtimeData {
    var t1h: String?     // 현재온도
    var sky: String?     // 하늘상태 맑음(1), 구름많음(3), 흐림(4)
    var pty: String?     // 강수형태 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4) ps) 비/눈 - > 진눈개비
    var rn1: String?     // 강수량
    var reh: String?     // 습도
}
