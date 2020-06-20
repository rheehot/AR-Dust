//
//  MainModel.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/20.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import RxSwift

struct MainModel {
    let apiService: APIService
    let coordinate: LatLng
    
    init(apiService: APIService = APIServiceImpl(), coordinate: LatLng) {
        self.apiService = apiService
        self.coordinate = coordinate
    }
    // rx weather 데이터 request test
    func rxTest(latLng: LatLng) -> Observable<Result<WeatherRealtimeData, NetworkError>> {
        return apiService.rxTest(latLng: latLng)
    }
}
