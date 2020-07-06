//
//  FineDustViewModel.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/29.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

final class FineDustViewModel {
    let fineDust: Signal<FineDust>
    var loading: Driver<Bool>
    
    init(coordinate: LatLng) {
        let model = FineDustModel(coordinate: coordinate)
        let loading = ActivityIndicator()
        self.loading = loading.asDriver()
        
        let fineDustResult = model.fineDust(latLng: coordinate)
            .asObservable()
            .share()

        let fineDustValue = fineDustResult
            .map { result -> Any? in
                guard case .success(let value) = result else { return nil }
                return value
        }
        .filterNil()
        
        fineDust = fineDustValue
            .map(model.parseData)
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
    }
}
