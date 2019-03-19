//
//  AirPollution.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

class AirPollution {
    
    // MARK: - MesureTypeEnum
    // MARK: -
    /// 대기오염 측정 타입: 실시간 측정 정보, 근접 측정소 정보
    enum AirPollutionMeasureType {
        case realtimeMeasurement
        case nearbyMeasuringSt
    }
    
    private enum RealtimeCategoryType {
        case dataTime, mangName, so2Value, coValue, o3Value, no2Value, pm10Value, pm10Value24, pm25Value, pm25Value24, khaiValue, khaiGrade, so2Grade, coGrade, o3Grade, no2Grade, pm10Grade, pm25Grade, pm10Grade1h, pm25Grade1h
    }
    
    ///측정소 타입에 따른 데이터 번환
    func measureTypeExtract (_ type: AirPollutionMeasureType, data: Any?) -> Any? {
        guard let result = data as? [String: Any], let list = result["list"] as? [[String: Any]] else {
            return nil
        }
        
        switch type {
        case .nearbyMeasuringSt:
            return extractNearByMeasuringStation(list)
        case .realtimeMeasurement:
            return extractRealtimeMeasuringStation(result,list)
        }
    }
    
    ///실시간 특정소 데이터 반환
    private func extractRealtimeMeasuringStation(_ result: Any?, _ data: Any?) -> Any? {
        var realtimeData = extractRealtimeData(data)
        guard let result = result as? [String: Any] else {
            return nil
        }
        if let value = result["ArpltnInforInqireSvcVo"] as? [String: Any] {
            let stationName = value["stationName"] as? String
            realtimeData?.stationName = stationName
        }
        return realtimeData
    }
    
    
    
    /// 근접 측정소의 stationName의 정보를 담고있는 배열 반환
    private func extractNearByMeasuringStation(_  data: Any?) -> Any? {
        guard let items = data as? [[String: Any]] else {
            return nil
        }
        
        var stationNames = [String]()
        // 근접 측정소 정보 배열을 받아온다
        for item in items {
            if let stationName = item["stationName"] as? String {
                stationNames.append(stationName)
            }
        }
        return stationNames
    }
    
    /// 측정소별 실시간 측정정보 JSON 배열 형태로 추출 후 반환
    private func extractRealtimeData(_ data: Any?) -> AirPollutionData? {
        guard let items = data as? [[String: Any]], let item = items.first else {
            return nil
        }
        
        var airPollutionData = AirPollutionData()
        for (key, value) in item {
            switch key {
            case "dataTime":
                airPollutionData.dataTime = convertToString(.dataTime, value: value)
            case "mangName":
                airPollutionData.mangName = convertToString(.mangName, value: value)
            case "so2Value":
                airPollutionData.so2Value = convertToString(.so2Value, value: value)
            case "coValue":
                airPollutionData.coValue = convertToString(.coValue, value: value)
            case "o3Value":
                airPollutionData.o3Value = convertToString(.o3Value, value: value)
            case "no2Value":
                airPollutionData.no2Value = convertToString(.no2Value, value: value)
            case "pm10Value":
                airPollutionData.pm10Value = convertToString(.pm10Value, value: value)
            case "pm10Value24":
                airPollutionData.pm10Value24 = convertToString(.pm10Value24, value: value)
            case "pm25Value":
                airPollutionData.pm25Value = convertToString(.pm25Value, value: value)
            case "pm25Value24":
                airPollutionData.pm25Value24 = convertToString(.pm25Value24, value: value)
            case "khaiValue":
                airPollutionData.khaiValue = convertToString(.khaiValue, value: value)
            case "khaiGrade":
                airPollutionData.khaiGrade = convertToString(.khaiGrade, value: value)
            case "so2Grade":
                airPollutionData.so2Grade = convertToString(.so2Grade, value: value)
            case "coGrade":
                airPollutionData.coGrade = convertToString(.coGrade, value: value)
            case "o3Grade":
                airPollutionData.o3Grade = convertToString(.o3Grade, value: value)
            case "no2Grade":
                airPollutionData.no2Grade = convertToString(.no2Grade, value: value)
            case "pm10Grade":
                airPollutionData.pm10Grade = convertToString(.pm10Grade, value: value)
            case "pm25Grade":
                airPollutionData.pm25Grade = convertToString(.pm25Grade, value: value)
            case "pm10Grade1h":
                airPollutionData.pm10Grade1h = convertToString(.pm10Grade1h, value: value)
            case "pm25Grade1h":
                airPollutionData.pm25Grade1h = convertToString(.pm25Grade1h, value: value)
            default:
                ()
            }
        }
        return airPollutionData
    }
    
    /// 추출한 데이터의 정보를 문자열로 변환 (임시)
    private func convertToString(_ type: RealtimeCategoryType, value: Any) -> String {
        var result = ""
        
        result = "\(value)"
        
        return result
        
    }
    
    
    
}
