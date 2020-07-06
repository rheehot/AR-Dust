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
    
    @IBOutlet weak var weatherView: UIView?
    @IBOutlet weak var fineDustView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.weatherView?.layer.cornerRadius = 20
        self.weatherView?.layer.masksToBounds = true
        
        self.fineDustView?.layer.cornerRadius = 20
        self.fineDustView?.layer.masksToBounds = true
        
        let apiService = APIServiceImpl()
        apiService.requestNearbyMsrstnList(latLng: LatLng(latitude: 37.359255, longitude: 127.105046)) { (isSuccess, data, error) in
            if isSuccess {
                print(data)
            }
        }
    }
}

