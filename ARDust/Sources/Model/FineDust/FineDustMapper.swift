//
//  FineDustMapper.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

class FineDustMapper {
    
    func parseData(_ type: AirPollutionMeasureType, data: Any?) -> Any? {
        guard let result = data as? [String: Any], let list = result["list"] as? [[String: Any]] else { return nil }
        
        switch type {
        case .nearbyMeasuringSt:
            return parseMsrstnAcctoRltmMesureDnstyData(result, list)
        case .realtimeMeasurement:
            return parseNearByMeasuringStationName(list)
        }
    }
    // 실시간 측정소별 측정정보 반환
    private func parseMsrstnAcctoRltmMesureDnstyData(_ result: Any?, _ data: Any?) -> Any? {
        var realtimeData = parseRealtimeData(data)
        guard let result = result as? [String: Any] else { return nil }
        if let value = result["ArpltnInforInqireSvcVo"] as? [String: Any] {
            let stationName = value["stationName"] as? String
            realtimeData?.stationName = stationName
        }
        return realtimeData
    }
    // 근접 측정소 목록 반환
    private func parseNearByMeasuringStationName(_ data: Any?) -> Any? {
        guard let items = data as? [[String: Any]] else { return nil }
        
        return items
            .map { item -> String? in
                if let stationName = item["stationName"] as? String {
                    return stationName
                }
                return nil
        }.compactMap { $0 }
    }
    
    private func parseRealtimeData(_ data: Any?) -> FineDust? {
        guard let items = data as? [[String: Any]], let item = items.first else { return nil }
        
        var fineDust = FineDust()
        for (key, value) in item {
            switch key {
            case "dataTime":
                fineDust.dataTime = "\(value)"
            case "mangName":
                fineDust.mangName = "\(value)"
            case "so2Value":
                fineDust.so2Value = "\(value)"
            case "coValue":
                fineDust.coValue = "\(value)"
            case "o3Value":
                fineDust.o3Value = "\(value)"
            case "no2Value":
                fineDust.no2Value = "\(value)"
            case "pm10Value":
                fineDust.pm10Value = "\(value)"
            case "pm10Value24":
                fineDust.pm10Value24 = "\(value)"
            case "pm25Value":
                fineDust.pm25Value = "\(value)"
            case "pm25Value24":
                fineDust.pm25Value24 = "\(value)"
            case "khaiValue":
                fineDust.khaiValue = "\(value)"
            case "khaiGrade":
                fineDust.khaiGrade = "\(value)"
            case "so2Grade":
                fineDust.so2Grade = "\(value)"
            case "coGrade":
                fineDust.coGrade = "\(value)"
            case "o3Grade":
                fineDust.o3Grade = "\(value)"
            case "no2Grade":
                fineDust.no2Grade = "\(value)"
            case "pm10Grade":
                fineDust.pm10Grade = "\(value)"
            case "pm25Grade":
                fineDust.pm25Grade = "\(value)"
            case "pm10Grade1h":
                fineDust.pm10Grade1h = "\(value)"
            case "pm25Grade1h":
                fineDust.pm25Grade1h = "\(value)"
            default:
                ()
            }
        }
        return fineDust
    }
}
