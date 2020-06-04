//
//  ViewController.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import SpriteKit
import CoreLocation
import Hero


class MainViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let apiService = APIServiceImpl()
        // 그린팩토리 37.359255, 127.105046
        
        let latLng = LatLng(latitude: 37.359255, longitude: 127.105046)
        apiService.requestForecastGrib(latLng: latLng) { (isSuccess, data, error) in
            if isSuccess {
                print(data)
            } else {
                print("실패")
            }
        }
    }
    
    
    
}
