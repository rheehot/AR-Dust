//
//  APIService.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/01.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

typealias RequestHandler = (Bool, Any?, NetworkError?) -> Void

protocol APIService {
    func fineDust(_ data: LocationData, completion: @escaping RequestHandler)
    func weather(_ data: LocationData, completion: @escaping RequestHandler)
}

class APIServiceImpl: APIService {
    
    func fineDust(_ data: LocationData, completion: @escaping RequestHandler) {
        <#code#>
    }
    
    func weather(_ data: LocationData, completion: @escaping RequestHandler) {
        <#code#>
    }
}
// MARK: - Create Request Components Method
private extension APIServiceImpl {
    
    private func createURL(_ type: URIType) -> URL? {
        switch type {
        case .forecastGrib, .forecastSpaceData, .forecastTimeData:
            return weatherURLComponents(type).url
        case .getMsrstnAcctoRltmMesureDnsty, .getNearbyMsrstnList:
            return fineDustURLComponents(type).url
        }
    }
    
    private func weatherURLComponents(_ type: URIType) -> URLComponents {
        var components = URLComponents()
        components.scheme = WeatherAPI.scheme.rawValue
        components.host = WeatherAPI.host.rawValue
        components.path = WeatherAPI.path.rawValue
        components.path += WeatherAPI.weatherService.rawValue
        components.path += "/\(type.rawValue)"
        components.query = "/ServiceKey=\(WeatherAPI.serviceKey.rawValue)"
        return components
    }
    
    private func fineDustURLComponents(_ type: URIType) -> URLComponents {
        var components = URLComponents()
        components.scheme = FineDustAPI.scheme.rawValue
        components.host = FineDustAPI.host.rawValue
        components.path = FineDustAPI.path.rawValue
        
        if type == .getMsrstnAcctoRltmMesureDnsty {
            components.path += FineDustAPI.realtimeService.rawValue
        } else if type == .getNearbyMsrstnList {
            components.path += FineDustAPI.nearByService.rawValue
        }
        components.path += "/\(type.rawValue)"
        components.query = "/ServiceKey=\(FineDustAPI.serviceKey.rawValue)"
        return components
    }
}

