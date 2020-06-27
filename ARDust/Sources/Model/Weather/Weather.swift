//
//  Weather.swift
//  ARDust
//
//  Created by youngjun goo on 08/06/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation


class Weather {
    
    // 현재 날짜를 반환한다.
    private func todayBaseDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        var dateString = ""
        formatter.dateFormat = "YYYYMMdd"
        dateString = formatter.string(from: date)
        return dateString
    }
    
    func extractData(_ type: WeatherType, data: Any?) -> Any? {
        guard let result = data as? [String: Any],
            let response = result["response"] as? [String: Any],
            let body = response["body"] as? [String: Any],
            let items = body["items"] as? [String: Any],
            let item = items["item"] as? [[String: Any]] else {
                return nil
        }
        return extractRealtimeData(item)
    }
    
    // 요청 받은 날씨 데이터를 WeatherRaaltimeData 객체로 반환
    private func extractRealtimeData(_ data: Any) -> WeatherRealtimeData? {
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
                weatherRealtimeData.sky = convertToRealtimeString(.sky, value: value)
            case "PTY":
                weatherRealtimeData.pty = convertToRealtimeString(.pty, value: value)
            case "RN1":
                weatherRealtimeData.rn1 = convertToRealtimeString(.rn1, value: value)
            case "REH":
                weatherRealtimeData.reh = convertToRealtimeString(.reh, value: value)
            default:
                continue
            }
        }
        return weatherRealtimeData
    }
    
    // 요청한 날씨데이터를 String 형으로 formatting 해주는 함수
    private func convertToRealtimeString(_ type: RealtimeCategoryType, value: Double) -> String {
        var result = ""
        switch type {
        case .t1h:  // 현재온도
            result = "\(Int(round(value)))°"
        case .sky:  // 하늘상태
            if value == 1 {
                result = "맑음"
            } else if value == 2 {
                result = "구름조금"
            } else if value == 3 {
                result = "구름많음"
            } else if value == 4 {
                result = "흐림"
            }
        case .pty:  // 강수형태
            if value == 0 {
                result = "없음"
            } else if value == 1 {
                result = "비"
            } else if value == 2 {
                result = "비/눈"
            } else if value == 3 {
                result = "눈"
            }
        case .rn1:  // 강수량
            if value == 0 {
                result = "0mm"
            } else if value <= 1 {
                result = "1mm 미만"
            } else if value <= 5 {
                result = "1 ~ 4mm"
            } else if value <= 10 {
                result = "5 ~ 9mm"
            } else if value <= 20 {
                result = "10 ~ 19mm"
            } else if value <= 40 {
                result = "20 ~ 39mm"
            } else if value <= 70 {
                result = "40 ~ 69mm"
            } else if value == 100 {
                result = "70mm 이상"
            }
        case .reh:  // 습도
            result = "\(Int(value))%"
        }
        return result
    }
}
