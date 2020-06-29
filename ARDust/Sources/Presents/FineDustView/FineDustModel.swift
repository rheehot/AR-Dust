//
//  FineDustModel.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/29.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import RxSwift
import RxCocoa

class FineDustModel {
    let apiService: APIService
    let coordinate: LatLng
    
    init(apiService: APIService = APIServiceImpl(), coordinate: LatLng) {
        self.apiService = apiService
        self.coordinate = coordinate
    }
    
    func findDuestRxTest(latLng: LatLng) -> Observable<Result<Any, NetworkError>> {
        return apiService.fineDustRxTest(latLng: latLng)
    }
}

