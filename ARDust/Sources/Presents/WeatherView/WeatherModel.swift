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
    let weatherMapper: WeatherMapper
    
    init(apiService: APIService = APIServiceImpl(), weatherMapper: WeatherMapper = WeatherMapper(), coordinate: LatLng) {
        self.apiService = apiService
        self.coordinate = coordinate
        self.weatherMapper = weatherMapper
    }
    // rx weather 데이터 request test
    func weatherRxTest(latLng: LatLng) -> Observable<Result<Any, NetworkError>> {
        return apiService.weatherRxTest(latLng: latLng)
    }
    // Data Mapper function
    func parseData(data: Any?) -> WeatherRealtimeData? {
        guard let weather = weatherMapper.parseData(.sky, data: data) as? WeatherRealtimeData else { return nil }
        return weather
    }
}
