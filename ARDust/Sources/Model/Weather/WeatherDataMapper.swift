//
//  WeatherMapper.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/21.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

struct WeatherMapper {
    
    func parseData(_ type: WeatherType, data: Any?) -> Any? {
        guard let result = data as? [String: Any],
            let response = result["response"] as? [String: Any],
            let body = response["body"] as? [String: Any],
            let items = body["items"] as? [String: Any],
            let item = items["item"] as? [[String: Any]] else {
                return nil
        }
        // [임시] skyData 만 추출
        return parseRealtimeData(item)
    }
    // 요청 받은 날씨 데이터를 WeatherRaaltimeData 객체로 반환
    private func parseRealtimeData(_ data: Any) -> WeatherRealtimeData? {
        guard let items = data as? [[String: Any]] else {
            return nil
        }
        var weatherRealtimeData = WeatherRealtimeData()
        for item in items {
            guard let category = item["category"] as? String,
                let value = item["obsrValue"] as? Double else {
                    return nil
            }
            switch category {
            case "T1H":
                weatherRealtimeData.convertToRealtimeString(.t1h, value: value)
            case "SKY":
                weatherRealtimeData.convertToRealtimeString(.sky, value: value)
            case "PTY":
                weatherRealtimeData.convertToRealtimeString(.pty, value: value)
            case "RN1":
                weatherRealtimeData.convertToRealtimeString(.rn1, value: value)
            case "REH":
                weatherRealtimeData.convertToRealtimeString(.reh, value: value)
            default:
                continue
            }
        }
        return weatherRealtimeData
    }
    // 초단기 예보 SKY 값 -> 날씨 상태로 parsing
    private func parseSkyData(_ data: Any) -> String? {
        guard let items = data as? [[String: Any]] else { return nil }
        
        for item in items {
            if let category = item["categoty"] as? String,
                category != "SKY" {
                continue
            }
            guard let skyValue = item["fcstValue"] as? Int else { return nil }
            
            switch skyValue {
            case 1:
                return "맑음"
            case 2:
                return "구름조금"
            case 3:
                return "구름많음"
            case 4:
                return "흐림"
            default:
                return nil
            }
        }
        return nil
    }
}
