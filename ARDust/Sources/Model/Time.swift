//
//  Time.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

class Time {
    
    var hour: Int { return Calendar.current.component(.hour, from: Date()) }
    var minute: Int { return Calendar.current.component(.minute, from: Date()) }
    
    // 요청 타입의 년월일 반환: 어제, 오늘, 내일, 모레
    func baseDate(_ type: DayType) -> String {
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
    // MARK: - Weather API 요청 시간 컨버팅 함수
    // 초단기 실황 API 요청 시간 컨버팅 함수
    func convertRequestTime(_ type: WeatherType) -> (String, String) {
        switch type {
        case .realtime, .sky:
            return forecastGribTime()
        case .local:
            return forecastLocalTime()
        }
    }
    
    private func forecastGribTime() -> (String, String) {
        var dateString = baseDate(.today)
        var hourString = "\(hour)"
        let minuteString = "\(minute)"
        // 초단기 실황 API 제공 시간 -> 매 시간 40분
        if minute < 40 {
            if hour == 0 {
                // 0시면 어제의 측정값 요청
                dateString = baseDate(.yesterday)
                hourString = "23"
            } else if hour < 10 {
                hourString = "0\(hour)"
            } else {
                hourString = "\(hour)"
            }
        }
        // 00:40분 일때
        if hour == 0 && minute == 40 {
            hourString = "0" + hourString
        } else if hour < 10 {
            hourString = "0" + hourString
        }
        return (dateString, hourString + minuteString)
    }
    
    private func forecastLocalTime() -> (String, String) {
        var dateString = baseDate(.today)
        var hourString = "\(hour)"
        let minuteString = "\(minute)"
        
        if hour >= 2 && hour < 5 {
            if hour == 2 && minute < 10 {
                dateString = baseDate(.yesterday)
                hourString = "23"
            } else {
                hourString = "02"
            }
        } else if hour >= 5 && hour < 8 {
            if hour == 5 && minute < 10 {
                hourString = "02"
            } else {
                hourString = "05"
            }
        } else if hour >= 8 && hour < 11 {
            if hour == 8 && minute < 10 {
                hourString = "05"
            } else {
                hourString = "08"
            }
        } else if hour >= 11 && hour < 14 {
            if hour == 11 && minute < 10 {
                hourString = "08"
            } else {
                hourString = "11"
            }
        } else if hour >= 14 && hour < 17 {
            if hour == 14 && minute < 10 {
                hourString = "11"
            } else {
                hourString = "14"
            }
        } else if hour >= 17 && hour < 20 {
            if hour == 17 && minute < 10 {
                hourString = "14"
            } else {
                hourString = "17"
            }
        } else if hour >= 20 && hour < 23 {
            if hour == 20 && minute < 10 {
                hourString = "17"
            } else {
                hourString = "20"
            }
        } else if hour >= 23 || hour < 2 {
            if hour == 23 && minute < 10 {
                hourString = "20"
            } else {
                if hour != 23 {
                    dateString = baseDate(.yesterday)
                }
                hourString = "23"
            }
        }
        return (dateString, hourString + minuteString)
    }
    
}
