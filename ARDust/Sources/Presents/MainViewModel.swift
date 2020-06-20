//
//  MainViewModel.swift
//  ARDust
//
//  Created by youngjun goo on 2020/05/29.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewModel {
    let viewWillApearSubject = PublishSubject<Void>()
    
    init(coordinate: LatLng) {
        // Model 생성
        let model = MainModel(coordinate: coordinate)
        // [Test] 그린팩토리
        // 그린팩토리 37.359255, 127.105046
        let latLng = LatLng(latitude: 37.359255, longitude: 127.105046)
        let initalResult = self.viewWillApearSubject
        .asObservable()
            .flatMap { _ in
                model
                .rxTest(latLng: latLng)
        }
    }
}

