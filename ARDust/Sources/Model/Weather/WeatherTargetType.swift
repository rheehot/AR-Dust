//
//  WeatherTargetType.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/02.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

enum WeatherType {
    case realtime
    case local
    case sky
}

enum RealtimeCategoryType: String {
    case t1h
    case sky
    case pty
    case rn1
    case reh
}

enum LocalCategoryType: String {
    case date
    case time
    case pop
    case pty
    case r06
    case reh
    case s06
    case sky
    case t3h
    case tmn
    case tmx
    case uuu
    case vvv
    case wav
    case vec
    case wsd
}

enum DayType {
     case today
     case yesterday
     case tomorrow
     case dayAfterTomorrow
 }
