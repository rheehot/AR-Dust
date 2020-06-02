//
//  APIService.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/01.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import Alamofire

protocol APIService {
    func fineDust(_ data: LocationData, completion: @escaping RequestHandler)
    func weather(_ data: LocationData, completion: @escaping RequestHandler)
}

class APIServiceImpl: APIService {
    // MARK: - Properties
    private let locationCoordinate = LocationCoordinate()
    
    func fineDust(_ data: LocationData, completion: @escaping RequestHandler) {
        <#code#>
    }
    
    func weather(_ data: LocationData, completion: @escaping RequestHandler) {
        <#code#>
    }
}
// MARK: - Request API Data
extension APIServiceImpl: APIRequestable {
    
    func requestForecastGrib(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.forecastGrib) else {
            completion(false, nil, .requestFailed)
            return
        }
        let (nx, ny) = locationCoordinate.convertToGrid(latitude: latLng.latitude, longitude: latLng.longitude)
        let (baseData, baseTime) = Time().convertRequestTime(.realtime)
        let parameters: Parameters = [
            "base_date": baseData,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 30
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                if let data =
        }
    }
    
    func requestForecastTimeData(latLng: LatLng, completion: @escaping RequestHandler) {
        <#code#>
    }
    
    func requestForecastSpaceData(latLng: LatLng, completion: @escaping RequestHandler) {
        <#code#>
    }
    
    func requestNearbyMsrstnList(latLng: LatLng, completion: @escaping RequestHandler) {
        <#code#>
    }
    
    func requestMsrstnAcctoRltmMesureDnsty(latLng: LatLng, completion: @escaping RequestHandler) {
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

