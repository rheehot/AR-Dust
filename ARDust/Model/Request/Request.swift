//
//  Request.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation
import Alamofire

enum URIType: String {
    case ForecastGrib
    case getNearbyMsrstnList
    case getMsrstnAcctoRltmMesureDnsty
}


class Request: RequestProtocol {
    // MARK: - Properties
    // MARK: -
    
    private let serviceKey = "TQBRjs7R7pNt0EO4AnzEB4wxwNQDbQYimvrsNuv%2BbL2mSzlrwpBRh%2BStWg9%2BQY4NyJ1JwLFbDinv8Dyvs8gg5g%3D%3D"
    private let airPollution = AirPollution()
    private let weather = Weather()
    private let locationCoordinate = LocationCoordinate()
    // 영구 저장소에 저장 되어있는 위치 데이터를 로딩 한다.
    private lazy var locations: [LocationData] = {
        var locations = (UIApplication.shared.delegate as! AppDelegate).locations
        locations = LocationManager().fetch()
        return locations
    }()
    
    // MARK: - RequestProtocol Method
    // MARK: -
    func getAirDataList(_ data: LocationData, completion: @escaping requestCompletionHandler) {
        print("getAirDataList 접근")
        var requestError: RequestError?
        
        let deadlineTask = DispatchWorkItem {
            requestError = .networkDelay
            completion(false, nil, requestError)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 30, execute: deadlineTask)
        var airDataList = [AirData]()
        let dispatchGroup = DispatchGroup()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var firstAirData: AirData?
        dispatchGroup.enter()
        request(data) { (isSuccess, data, error) in
            if isSuccess, let airData = data as? AirData {
                firstAirData = airData
            } else {
                print("AirData 가져오기 실패")
                requestError = error
            }
            dispatchGroup.leave()
        }
        
        locations.removeAll()
        
        if !locations.isEmpty {
            print("coreData에 데이터 있을시")
            for location in locations {
                dispatchGroup.enter()
                request(location) { (isSuccess, data, error) in
                    if isSuccess, let airData = data as? AirData {
                        print(airData)
                        airDataList.append(airData)
                    } else {
                        print("Request Error")
                        requestError = error
                    }
                    dispatchGroup.leave()
                }
            }
        }
 
        dispatchGroup.notify(queue: .main) {
            // 네트워크 인디케이터 로딩 종료
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            // 데드라인테스크 취소
            deadlineTask.cancel()
            // requestError 존재한다면 에러를, 아닐 경우 데이터 전달
            if requestError != nil {
                completion(false, nil, requestError)
                return
            }
            // totlaDataList를 등록순으로 정렬후 전달한다
            airDataList.sort { (first, second) -> Bool in
                return first.registerDate < second.registerDate
            }
            if let firstAirData = firstAirData {
                airDataList.insert(firstAirData, at: 0)
            }
            completion(true, airDataList, nil)
            
        }
    }
    
    func request(_ data: LocationData, completion: @escaping requestCompletionHandler) {
        guard let locationName = data.locationName,
            let registerDate = data.registerDate,
            let latitude = data.latitude,
            let longtitude = data.longitude else {
                return
        }
       // var weatherRealTimeData = WeatherRealtimeData()
        var airPollutionData = AirPollutionData()
        let dispatchGroup = DispatchGroup()
        var requestError: RequestError?
        var weatherRealTimeData = WeatherRealtimeData()
        
        dispatchGroup.enter()
        print("\(locationName) \(latitude) \(longtitude)")
        requestNearbyMsrstnList(latitude: latitude, longitude: longtitude) { (isSuccess, data, error) in
            if isSuccess, let list = data as? [String] {
                dispatchGroup.enter()
                self.requestMsrstnAcctoRltmMesureDnsty(list) { (isSuccess, data, error) in
                    if isSuccess, let data = data as? AirPollutionData {
                        airPollutionData = data
                    } else {
                        print("측정소 값 반환 실패")
                        requestError = error
                    }
                    dispatchGroup.leave()
                }
            } else {
                print("근접 측정소 값 반환 실패")
                requestError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        requestRealTimeWeatherCast(latitude: latitude, longtitude: longtitude) { (isSuccess, data, error) in
            if isSuccess, let data = data as? WeatherRealtimeData {
                weatherRealTimeData = data
            } else {
                print("날씨예보 가져오기에 실패했습니다.")
                requestError = error
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .global()) {
            // requestError 존재한다면 에러를, 아닐 경우 데이터 전달
            if requestError != nil {
                completion(false, nil, requestError)
            } else {
                let airData = AirData(locationName: locationName, registerDate: registerDate, airPollutionData: airPollutionData, weatherRealTimeData: weatherRealTimeData)
                completion(true, airData, nil)
            }
        }
        
    }
    
    
    
    func createURL(_ type: URIType) -> URL? {
        var urlString: String
        switch type {
        case .ForecastGrib:
            urlString = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/"
        case .getNearbyMsrstnList:
            urlString = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/"
        case .getMsrstnAcctoRltmMesureDnsty:
            urlString = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/"
        }
        urlString += "\(type.rawValue)?ServiceKey=\(serviceKey)"
        
        guard let url = URL(string: urlString) else {
            return URL(string: "")
        }
        
        return url
    }
    
    // 실시간 단기 예보
    private func requestRealTimeWeatherCast(latitude: Double, longtitude: Double, completion: @escaping requestCompletionHandler) {
        guard let url = createURL(.ForecastGrib) else {
            return
        }
        
        let (nx, ny) = locationCoordinate.convertToGrid(latitude: latitude, longitude: longtitude)
        let (date, time) = weather.getBaseDateTime(.realtime)
        let parameters: Parameters = [
            "base_date": date,
            "base_time": time,
            "nx": nx,
            "ny": ny,
            "_type": "json",
            "numOfRows": 10
        ]
        
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = self.weather.extractData(.realtime, data: response.result.value) {
                completion(true, data, nil)
            } else {
                print("실시간 단기 예보 가져오기 실패")
                completion(false, nil, RequestError.requestFailed)
            }
        }
    }
    
    
    /// 근접측정소 목록을 호출하는 메서드
    private func requestNearbyMsrstnList(latitude: Double, longitude: Double, completion: @escaping requestCompletionHandler) {
        guard let url = createURL(.getNearbyMsrstnList) else {
            return
        }
        let (tmX, tmY) = locationCoordinate.convertToPlaneRect(latitude: latitude, longitude: longitude)
        let parameters: Parameters = [
            "tmX": tmX,
            "tmY": tmY,
            "numOfRows": 1,
            "_returnType": "json"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = self.airPollution.measureTypeExtract(.nearbyMeasuringSt, data: response.result.value) {
                completion(true, data, nil)
            } else {
                completion(false, nil, RequestError.requestFailed)
            }
        }
    }
    
    /// 측정소별 실시간 측정정보를 호출하는 메서드
    private func requestMsrstnAcctoRltmMesureDnsty(_ stationNames: [String], completion: @escaping requestCompletionHandler) {
        guard let url = createURL(.getMsrstnAcctoRltmMesureDnsty) else {
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
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = self.airPollution.measureTypeExtract(.realtimeMeasurement, data: response.result.value) {
                completion(true, data, nil)
            } else {
                if stationNames.isEmpty {
                    completion(false, nil, RequestError.requestFailed)
                    return
                }
                self.requestMsrstnAcctoRltmMesureDnsty(stationNames, completion: completion)
            }
        }
    }
    
    
    
    
}
