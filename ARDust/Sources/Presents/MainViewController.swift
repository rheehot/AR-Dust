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
    @IBOutlet weak var weatherView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

