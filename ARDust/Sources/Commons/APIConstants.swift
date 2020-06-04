//
//  APIConstants.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/01.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

public enum FineDustAPI: String {
    case scheme = "http"
    case host = "openapi.airkorea.or.kr"
    case path = "/openapi/services/rest"
    case realtimeService = "/ArpltnInforInqireSvc"
    case nearByService = "/MsrstnInfoInqireSvc"
    case serviceKey = "TQBRjs7R7pNt0EO4AnzEB4wxwNQDbQYimvrsNuv%2BbL2mSzlrwpBRh%2BStWg9%2BQY4NyJ1JwLFbDinv8Dyvs8gg5g%3D%3D"
}

public enum WeatherAPI: String {
    case scheme = "http"
    case host = "newsky2.kma.go.kr"
    case path = "/service"
    case weatherService = "/SecndSrtpdFrcstInfoService2"
    case serviceKey = "TQBRjs7R7pNt0EO4AnzEB4wxwNQDbQYimvrsNuv%2BbL2mSzlrwpBRh%2BStWg9%2BQY4NyJ1JwLFbDinv8Dyvs8gg5g%3D%3D"
}

