//
//  Weather.swift
//  ARDust
//
//  Created by youngjun goo on 08/06/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation


class Weather {
    
    enum WeatherType {
        case realtime
    }
    
    private enum RealtimeCategoryType: String {
        case t1h, sky, pty, rn1, reh, vec, wsd, lgt, uuu, vvv
    }
    
    private enum LocalCategoryType: String {
        case date, time, pop, pty, r06, reh, s06, sky, t3h, tmn, tmx, uuu, vvv, wav, vec, wsd
    }
    
    private enum DayType {
        case today
        case yesterday
        case tomorrow
        case dayAfterTomorrow
    }
    
    func getBaseDateTime(_ type: WeatherType) -> (String, String) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        var dateString = getBaseDate(.today)
        var hourString = "\(hour)"
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0" + "\(minute)"
        }
        
        if minute < 40 {
            if hour == 0 {
                dateString = getBaseDate(.yesterday)
                hourString = "23"
            } else if hour == 10 {
                hourString = "0\(hour - 1)"
            } else {
                hourString = "\(hour - 1)"
            }
        }
        if hour == 0 && minute >= 40 {
            hourString = "0" + hourString
        } else if hour != 0 && hour < 10 {
            hourString = "0" + hourString
        }
        return (dateString, hourString + minuteString)
    }
    /// base_date에 사용되는 현재 년월일을 문자열로 반환한다.
    private func getBaseDate(_ type: DayType) -> String {
        let date = Date()
        let formatter = DateFormatter()
        let calendar = Calendar.current
        var dateString = ""
        formatter.dateFormat = "YYYYMMdd"
        switch type {
        case .today:
            dateString = formatter.string(from: date)
        case .yesterday:
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
                dateString = formatter.string(from: yesterday)
            }
        case .tomorrow:
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) {
                dateString = formatter.string(from: tomorrow)
            }
        case .dayAfterTomorrow:
            if let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: date) {
                dateString = formatter.string(from: dayAfterTomorrow)
            }
        }
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
                weatherRealtimeData.t1h = convertToRealtimeString(.t1h, value: value)
            case "SKY":
                weatherRealtimeData.sky = convertToRealtimeString(.sky, value: value)
            case "PTY":
                weatherRealtimeData.pty = convertToRealtimeString(.pty, value: value)
            case "RN1":
                weatherRealtimeData.rn1 = convertToRealtimeString(.rn1, value: value)
            case "REH":
                weatherRealtimeData.reh = convertToRealtimeString(.reh, value: value)
            case "VEC":
                weatherRealtimeData.vec = convertToRealtimeString(.vec, value: value)
            case "WSD":
                weatherRealtimeData.wsd = convertToRealtimeString(.wsd, value: value)
            case "LGT":
                weatherRealtimeData.lgt = convertToRealtimeString(.lgt, value: value)
            case "UUU":
                weatherRealtimeData.uuu = convertToRealtimeString(.uuu, value: value)
            case "VVV":
                weatherRealtimeData.vvv = convertToRealtimeString(.vvv, value: value)
            default:
                continue
            }
        }
        return weatherRealtimeData
    }
    
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
        case .vec:  // 풍향
            let vec = Int((value + 22.5 * 0.5) / 22.5)
            if vec == 0 || vec == 16 {
                result = "북"
            } else if vec <= 3 {
                result = "북동"
            } else if vec == 4 {
                result = "동"
            } else if vec <= 7 {
                result = "동남"
            } else if vec == 8 {
                result = "남"
            } else if vec <= 11 {
                result = "남서"
            } else if vec == 12 {
                result = "서"
            } else if vec <= 15 {
                result = "서북"
            }
        case .wsd:  // 풍속
            result = "\(value)m/s"
        case .lgt:  // 낙뢰
            if value == 0 {
                result = "없음"
            } else {
                result = "있음"
            }
        case .uuu, .vvv:  // 동서바람성분, 남북바람성분
            result = "\(Int(round(value)))m/s"
        }
        return result
    }
}
