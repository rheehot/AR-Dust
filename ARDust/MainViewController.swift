//
//  ViewController.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {
    
    var locationData = LocationData()
    private var locationManager =  CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("진입")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    private func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        
        print(locations)
        print("Request 수행1")
        
        //        locationData.latitude = locations.first?.coordinate.latitude
        //        locationData.longitude = locations.first?.coordinate.longitude
        
        getCurrentLocation(locations.first!) { (isSuccess, data) in
            if isSuccess, let currentLocation = data {
                Request().getAirDataList(currentLocation) { (isSuccess,  data, error) in
                    if isSuccess, let airDataList = data as? [AirData] {
                        print("성공")
                        print(airDataList.first as Any)
                    } else {
                        print("실패")
                        if let errorDescription = error?.errorDescription {
                            print(errorDescription)
                        }
                    }
                    
                }
            } else {
                print("실패")
            }
        }
        
    }
}
