//
//  APIRequestable.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/01.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation

typealias RequestHandler = (Bool, Any?, NetworkError?) -> Void

protocol WeatherAPIRequestable {
    // request Weather API
    func requestForecastGrib(latLng: LatLng, completion: @escaping RequestHandler)
    
    func requestForecastTimeData(latLng: LatLng, completion: @escaping RequestHandler)
    
    func requestForecastSpaceData(latLng: LatLng, completion: @escaping RequestHandler)
}

protocol FineDustAPIRequestable {
    // request FineDust API
    func requestNearbyMsrstnList(latLng: LatLng, completion: @escaping RequestHandler)
    
    func requestMsrstnAcctoRltmMesureDnsty(_ stationNames: [String], completion: @escaping RequestHandler)
}
