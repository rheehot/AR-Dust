//
//  WeatherModel.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/20.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import RxSwift

struct WeatherModel {
    let apiService: APIService
    let coordinate: LatLng
    let weatherDataMapper: WeatherDataMapper
    
    init(apiService: APIService = APIServiceImpl(), weatherDataMapper: WeatherDataMapper = WeatherDataMapper(), coordinate: LatLng) {
        self.apiService = apiService
        self.coordinate = coordinate
        self.weatherDataMapper = weatherDataMapper
    }
    // rx weather 데이터 request test
    func rxTest(latLng: LatLng) -> Observable<Result<Any, NetworkError>> {
        return apiService.rxTest(latLng: latLng)
    }
    // Data Mapper function
    func parseData(data: Any?) -> WeatherRealtimeData? {
        if let parseData = weatherDataMapper.parseData(.sky, data: data) {
            return parseData as! WeatherRealtimeData
        }
        return nil
    }
}
