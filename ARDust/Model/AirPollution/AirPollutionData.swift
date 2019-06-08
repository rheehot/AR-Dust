//
//  AirPollutionData.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation
import UIKit

struct AirPollutionData {
    // 미세먼지 저보 JSON 데이터 (18p)
    var stationName: String?    // 측정소
    var dataTime: String?       // 측정일
    var mangName: String?       // 측정망 정보
    var so2Value: String?       // 아황산가스 농도
    var coValue: String?        // 일산화탄소 농도
    var o3Value: String?        // 오존 농도
    var no2Value: String?       // 이산화질소 농도
    var pm10Value: String?      // 미세먼지(PM10) 농도
    var pm10Value24: String?    // 미세먼지(PM10) 24시간 예측 이동 농도
    var pm25Value: String?      // 미세먼지(PM2.5) 농도 == 초미세먼지
    var pm25Value24: String?    // 미세먼지(PM2.5) 24시간 평균 농도
    var khaiValue: String?      // 통합대기환경수치
    var khaiGrade: String?      // 통합대기환경지수
    var so2Grade: String?       // 아황산가스 지수
    var coGrade: String?        // 일산화탄소 지수
    var o3Grade: String?        // 오존 지수
    var no2Grade: String?       // 이산화질소 지수
    var pm10Grade: String?      // 미세먼지(PM10) 24시간 등급
    var pm25Grade: String?      // 미세먼지(PM2.5) 24시간 등급
    var pm10Grade1h: String?    // 미세먼지(PM10) 1시간 등급
    var pm25Grade1h: String?    // 미세먼지(PM2.5) 1시간 등급
    
    var pollutionState: String {
        let pmValue = Int(self.pm10Value!)!
        if pmValue <= 15 {
            return "최고"
        } else if pmValue <= 30 {
            return "좋음"
        } else if pmValue <= 40 {
            return "양호"
        } else if pmValue <= 50 {
            return "보통"
        } else if pmValue <= 75 {
            return "나쁨"
        } else if pmValue <= 100 {
            return "상당히 나쁨"
        } else if pmValue <= 150 {
            return "매우 나쁨"
        } else {
            return "최악"
        }
    }
    
    var pollutionStateColor: UIColor {
        let pmValue = Int(self.pm10Value!)!
        if pmValue <= 15 {
            return UIColor.aqua()
        } else if pmValue <= 30 {
            return  UIColor.aqua()
        } else if pmValue <= 40 {
            return UIColor(red:102/255, green:255/255, blue:204/255, alpha:1.0)
        } else if pmValue <= 50 {
            return UIColor(red:102/255, green:255/255, blue:102/255, alpha:1.0)
        } else if pmValue <= 75 {
            return UIColor(red:255/255, green:204/255, blue:102/255, alpha:1.0)
        } else if pmValue <= 100 {
            return UIColor(red:255/255, green:128/255, blue:0/255, alpha:1.0)
        } else if pmValue <= 150 {
            return UIColor(red:128/255, green:0/255, blue:0/255, alpha:1.0)
        } else {
            return UIColor(red:60/255, green:0/255, blue:0/255, alpha:1.0)
        }
    }
    
    
}
