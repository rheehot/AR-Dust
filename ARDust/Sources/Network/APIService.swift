//
//  APIService.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/01.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol APIService {
    func weatherRxTest(latLng: LatLng) -> Observable<Swift.Result<Any, NetworkError>>
    func fineDust(stationNames: [String]) -> Observable<Swift.Result<Any, NetworkError>>
    // func weather(_ data: LocationData) -> Observable<Swift.Result<Weather, NetworkError>>
    func requestNearbyMsrstnList(latLng: LatLng, completion: @escaping RequestHandler)
    func requestMsrstnAcctoRltmMesureDnsty(_ stationNames: [String], completion: @escaping RequestHandler)
}

class APIServiceImpl: APIService {
    // MARK: - Properties
    private let locationCoordinate = LocationCoordinate()
    
    func fineDust(stationNames: [String]) -> Observable<Swift.Result<Any, NetworkError>> {
        guard let url = createURL(.getMsrstnAcctoRltmMesureDnsty) else {
            return .just(.failure(.requestFailed))
        }
        var stationNames = stationNames
        let firstStationName = stationNames.removeFirst()
        let parameters: Parameters = [
            "stationName": firstStationName,
            "dataTerm": "DAILY",
            "ver": 1.3,
            "numOfRows": 10,
            "_returnType": "json"
        ]
        return Observable.create { observer -> Disposable in
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case let .success(value):
                        observer.onNext(.success(value))
                    case let .failure(error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    //    func weather(_ data: LocationData) -> Observable<Swift.Result<Weather, NetworkError>> {
    //
    //    }
}
// MARK: - Request API Data
extension APIServiceImpl: WeatherAPIRequestable {
    
    func weatherRxTest(latLng: LatLng) -> Observable<Swift.Result<Any, NetworkError>> {
        guard let url = createURL(.forecastGrib) else {
            return .just(.failure(.requestFailed))
        }
        let (nx, ny) = locationCoordinate.convertToGrid(latLng: latLng)
        let (baseDate, baseTime) = Time().convertRequestTime(.realtime)
        let parameters: Parameters = [
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 10
        ]
        
        return Observable.create { observer -> Disposable in
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case let .success(value):
                        observer.onNext(.success(value))
                    case let .failure(error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    // 초단기실황
    func requestForecastGrib(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.forecastGrib) else {
            completion(false, nil, .requestFailed)
            return
        }
        let (nx, ny) = locationCoordinate.convertToGrid(latLng: latLng)
        let (baseDate, baseTime) = Time().convertRequestTime(.realtime)
        let parameters: Parameters = [
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 10
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                if let data = response.value {
                    completion(true, data, nil)
                } else {
                    completion(false, nil, .requestFailed)
                }
        }
    }
    
    // 초단기예보
    func requestForecastTimeData(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.forecastTimeData) else {
            completion(false, nil, NetworkError.requestFailed)
            return
        }
        let (nx, ny) = locationCoordinate.convertToGrid(latLng: latLng)
        let (baseDate, baseTime) = Time().convertRequestTime(.realtime)
        let parameters: Parameters = [
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 30
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                if let data = response.value {
                    completion(true, data, nil)
                } else {
                    completion(false, nil, NetworkError.requestFailed)
                }
        }
    }
    // 동네예보
    func requestForecastSpaceData(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.forecastSpaceData) else {
            return
        }
        let (nx, ny) = locationCoordinate.convertToGrid(latLng: latLng)
        let (baseDate, baseTime) = Time().convertRequestTime(.local)
        let parameters: Parameters = [
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 112
        ]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                if let data = response.value {
                    completion(true, data, nil)
                } else {
                    completion(false, nil, NetworkError.requestFailed)
                }
        }
    }
}

extension APIServiceImpl: FineDustAPIRequestable {
    // 근접측정소 목록
    func requestNearbyMsrstnList(latLng: LatLng, completion: @escaping RequestHandler) {
        guard let url = createURL(.getNearbyMsrstnList) else {
            completion(false, nil, NetworkError.requestFailed)
            return
        }
        let (tmX, tmY) = locationCoordinate.convertToPlaneRect(latLng: latLng)
        let parameters: Parameters = [
            "tmX": tmX,
            "tmY": tmY,
            "numOfRows": 1,
            "_returnType": "json"
        ]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { (response) in
                if let data = response.value {
                    print("성공")
                    completion(true, data, nil)
                } else {
                    completion(false, nil, NetworkError.requestFailed)
                    print("실패")
                    return
                }
        }
    }
    // 실시간 측정소별 측정정보
    func requestMsrstnAcctoRltmMesureDnsty(_ stationNames: [String], completion: @escaping RequestHandler) {
        guard let url = createURL(.getMsrstnAcctoRltmMesureDnsty) else {
            completion(false, nil, NetworkError.requestFailed)
            return
        }
        var stationNames = stationNames
        let stationName = stationNames.removeFirst()
        let parameters: Parameters = [
            "stationName": stationName,
            "dataTerm": "DAILY",
            "ver": 1.3,
            "numOfRows": 10,
            "_returnType": "json"
        ]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { (response) in
                if let data = response.value {
                    completion(true, data, nil)
                    return
                } else {
                    if stationNames.isEmpty {
                          completion(false, nil, .requestFailed)
                          return
                      }
                      self.requestMsrstnAcctoRltmMesureDnsty(stationNames, completion: completion)
                }
        }
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
        return components
    }
}

