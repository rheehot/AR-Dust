//
//  WeatherViewModel.swift
//  ARDust
//
//  Created by youngjun goo on 2020/05/29.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

final class WeatherViewModel {
    let weatherData: Signal<WeatherRealtimeData>
    
    var loading: Driver<Bool>
    
    init(coordinate: LatLng) {
        // Model 생성
        let model = WeatherModel(coordinate: coordinate)
        // Activity Indicator
        let loading = ActivityIndicator()
        self.loading = loading.asDriver()
        
        let weatherResult = model.weatherRxTest(latLng: coordinate)
            .asObservable()
            .share()
        
        let weatherValue = weatherResult
            .map { result -> Any? in
                guard case .success(let value) = result else { return nil }
                return value
        }
        .filterNil()
        
        weatherData = weatherValue
            .map(model.parseData)
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
    }
}

