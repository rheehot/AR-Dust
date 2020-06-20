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
import RxSwift


class MainViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func networkTest() {
        //        apiService.requestForecastGrib(latLng: latLng) { (isSuccess, data, error) in
        //            if isSuccess {
        //                print("성공","초단기",data)
        //            } else {
        //                print("실패")
        //            }
        //        }
        //        apiService.requestForecastTimeData(latLng: latLng) { (isSuccess, data, error) in
        //            if isSuccess {
        //                print("성공", "실시간", data)
        //            } else {
        //                print("실패")
        //            }
        //        }
        //        apiService.requestForecastSpaceData(latLng: latLng) { (isSuccess, data, error) in
        //            if isSuccess {
        //                print("성공","동네예보",data)
        //            } else {
        //                print("실패")
        //            }
        //        }
        //        // 미세먼지
        //        print("미세먼지")
        //        apiService.requestNearbyMsrstnList(latLng: latLng) { (isSuccess, data, error) in
        //            if isSuccess {
        //                print("성공","근접측정소",data)
        //            } else {
        //                print("실패")
        //            }
        //        }
        //        // 측정소별
        //        apiService.requestMsrstnAcctoRltmMesureDnsty("화원") { (isSuccess, data, error) in
        //            if isSuccess {
        //                print("성공","측정소별",data)
        //            } else {
        //                print("실패")
        //            }
        //        }
    }
}
