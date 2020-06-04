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
        
    }
    
    func weather(_ data: LocationData, completion: @escaping RequestHandler) {
        
    }
}
// MARK: - Request API Data
extension APIServiceImpl: APIRequestable {
    
    func requestForecastGrib(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.forecastGrib) else {
            print("실패")
            completion(false, nil, .requestFailed)
            return
        }
        print(url)
        let (nx, ny) = locationCoordinate.convertToGrid(latitude: latLng.latitude, longitude: latLng.longitude)
        let (baseData, baseTime) = Time().convertRequestTime(.realtime)
        let parameters: Parameters = [
            "base_date": baseData,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 10
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                print("요청")
                if let data = response.result.value {
                    print("성공",data)
                    completion(true, data, nil)
                } else {
                    print("실패")
                    completion(false, nil, NetworkError.requestFailed)
                }
        }
    }
    
    func requestForecastTimeData(latLng: LatLng, completion: @escaping RequestHandler) {
        
    }
    
    func requestForecastSpaceData(latLng: LatLng, completion: @escaping RequestHandler) {
        
    }
    
    func requestNearbyMsrstnList(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.getNearbyMsrstnList) else {
            completion(false, nil, NetworkError.requestFailed)
            return
        }
        let (tmX, tmY) = locationCoordinate.convertToPlaneRect(latitude: latLng.latitude, longitude: latLng.longitude)
        let parameters: Parameters = [
            "tmX": tmX,
            "tmY": tmY,
            "numOfRows": 1,
            "_returnType": "json"
        ]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                if let data = response.result.value {
                    completion(true, data, nil)
                } else {
                    completion(false, nil, NetworkError.requestFailed)
                }
        }
    }
    
    func requestMsrstnAcctoRltmMesureDnsty(latLng: LatLng, completion: @escaping RequestHandler) {
        
    }
}

// MARK: - Create Request Components Method
private extension APIServiceImpl {
    
    private func createURL(_ type: URIType) -> URL? {
        var urlString: String
        switch type {
        case .forecastGrib, .forecastSpaceData, .forecastTimeData:
            urlString = weatherURLComponents(type).description
        case .getMsrstnAcctoRltmMesureDnsty, .getNearbyMsrstnList:
            urlString = fineDustURLComponents(type).description
        }
        urlString += "/\(type.rawValue)?ServiceKey=\(WeatherAPI.serviceKey.rawValue)"
        return URL(string: urlString)
    }
    
    private func weatherURLComponents(_ type: URIType) -> URLComponents {
        var components = URLComponents()
        components.scheme = WeatherAPI.scheme.rawValue
        components.host = WeatherAPI.host.rawValue
        components.path = WeatherAPI.path.rawValue
        components.path += WeatherAPI.weatherService.rawValue
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
        components.query = "ServiceKey=\(FineDustAPI.serviceKey.rawValue)"
        return components
    }
}

