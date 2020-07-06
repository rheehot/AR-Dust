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
    let fineDustMapper = FineDustMapper()
    
    init(apiService: APIService = APIServiceImpl(), coordinate: LatLng) {
        self.apiService = apiService
        self.coordinate = coordinate
    }
    
    func fineDust(latLng: LatLng) -> Observable<Swift.Result<Any, NetworkError>> {
        var stationNames: [String] = [String]()
        self.stationNames(latLng: latLng) { (isSuccess, data, error) in
            if isSuccess, let list = data as? [String] {
                stationNames = list
            } else {
                print("실패")
            }
        }
        return apiService.fineDust(stationNames: stationNames)
    }
    
    private func stationNames(latLng: LatLng, completion: @escaping RequestHandler) {
        DispatchQueue.global().async {
            self.apiService.requestNearbyMsrstnList(latLng: latLng) { (isSuccess, data, error) in
                print("진입")
                if isSuccess {
                    if let list = self.fineDustMapper.parseData(.realtimeMeasurement, data: data) as? [String] {
                        completion(true, list, nil)
                    }
                } else {
                    print("실패")
                    completion(false, nil, .requestFailed)
                }
            }
        }
    }
    
    func parseData(data: Any?) -> FineDust? {
        guard let fineDust = fineDustMapper.parseData(.nearbyMeasuringSt, data: data) as? FineDust else { return nil }
        return fineDust
    }
}

