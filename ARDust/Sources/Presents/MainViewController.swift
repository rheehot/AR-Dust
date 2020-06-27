//
//  ViewController.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel?
    
    var viewModel: WeatherViewModel?
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        // networkTest()
    }
    
    func bind() {
        self.disposeBag = DisposeBag()
        self.viewModel = WeatherViewModel(coordinate: LatLng(latitude: 37.359255, longitude: 127.105046))
        
        viewModel?.weatherData
            .emit(to: self.rx.setData)
        .disposed(by: disposeBag)
    }
    
    func networkTest() {
        let latLng = LatLng(latitude: 37.359255, longitude: 127.105046)
        let apiService = APIServiceImpl()
        apiService.requestForecastGrib(latLng: latLng) { (isSuccess, data, error) in
            if isSuccess {
                print("성공","초단기",data)
            } else {
                print("실패")
            }
        }
    }
}

extension Reactive where Base: MainViewController {
    var setData: Binder<WeatherRealtimeData> {
        return Binder(base) { base, data in
            base.testLabel?.text = data.t1h
        }
    }
}
