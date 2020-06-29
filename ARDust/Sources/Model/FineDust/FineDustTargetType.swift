//
//  FineDustTargetType.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/29.
//  Copyright © 2020 youngjun goo. All rights reserved.
//


// 대기오염 측정 타입: 실시간 측정 정보, 근접 측정소 정보
enum AirPollutionMeasureType {
    case realtimeMeasurement
    case nearbyMeasuringSt
}
// 실시간 측정정보 카테고리 타입
enum FineDustRealtimeCategoryType {
    case dataTime, mangName, so2Value, coValue, o3Value, no2Value, pm10Value, pm10Value24, pm25Value, pm25Value24, khaiValue, khaiGrade, so2Grade, coGrade, o3Grade, no2Grade, pm10Grade, pm25Grade, pm10Grade1h, pm25Grade1h
}
